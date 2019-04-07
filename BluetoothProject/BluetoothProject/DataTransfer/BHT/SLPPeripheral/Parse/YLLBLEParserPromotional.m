//
//  YLLBLEV1Parser.m
//  Sleepace
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLEParserPromotional.h"
#import "CRC.h"

@interface YLLBLEParserPromotional (){
    NSMutableArray<YLLBLEReceivePacket *> *_cachePacketList;
}
@end

@implementation YLLBLEParserPromotional

+ (YLLBLEReceivePacket *)receiveBluetoothPacketWithData:(NSData *)data {
   YLLBLEParserPromotional *parserPromotional = [[self alloc] init];
   return [parserPromotional packetWithData:data];
}

- (id)init{
    if (self = [super init]){
        _cachePacketList = [NSMutableArray array];
    }
    return self;
}

- (void)reset{
    [super reset];
    [_cachePacketList removeAllObjects];
}

- (NSArray<YLLBLEReceivePacket *>*)appendData:(NSData *)data{
    if (!data || data.length == 0){
        return nil;
    }
    
    [_dataBuffer appendData:data];
    NSData *separator = [NSData dataWithBytes:kSeparator length:sizeof(kSeparator)];
    NSArray *subDataList = [Utils separateBuffer:_dataBuffer withSeparator:separator];
    if (subDataList.count == 0){
        KFLog_Normal(YES, @"no more packet with separator");
        return nil;
    }
    
    NSMutableArray *pacektList = [NSMutableArray array];
    for (NSData *data in subDataList){
        YLLBLEReceivePacket *pacekt = [self checkAndParseDataToRecievePacket:data];
        if (pacekt){
            [pacektList addObject:pacekt];
        }
    }
    [_cachePacketList addObjectsFromArray:pacektList];
    NSArray *completePacketList = [self pickUpCompletePacketFromSubPacketList:_cachePacketList];
    return completePacketList;
}

//data可能为一个完整的数据包,也可能为为一个完整数据包里的一个分包。
- (YLLBLEReceivePacket *)packetWithData:(NSData *)data{
    YLLBLEReceivePacket *packet = [[YLLBLEReceivePacket alloc] init];
    
    return packet;
}

/*
 1:检测和缓存中包的联系
 2:如果这个数据为分包~ 检测这个数据的分包在之前是否就已经丢弃掉了~
 3:CRC32检测包是否合法~ 如果包不合法~ 并且为response或ACK消息则回调提示返回不合法~
 */
- (YLLBLEReceivePacket *)checkAndParseDataToRecievePacket:(NSData *)data{
    [self checkSubPacketSituationWithTheDataJustReceived:data];
    if([self checkSubDataAbandonedBefore:data]){
        KFLog_Normal(YES, @"data abandoned before:%@",data);
        return nil;
    }
    
    if (![self checkCRC32:data]){
        KFLog_Normal(YES, @"data is illegal:%@",data);
        YLLFramTypes framType = [self framTypeFromData:data];
        switch (framType) {
            case YLLFramType_Response:
            case YLLFramType_ACK:
                //回调告知收到的数据不合法~
                if (self.delegate && [self.delegate respondsToSelector:@selector(framWithSequenceIllegal:)]){
                    [self.delegate framWithSequenceIllegal:[self messageSequecenFrom:data]];
                }
                break;
            case YLLFramType_Post:
                break;
            default:
                break;
        }
        return nil;
    }
    
    YLLBLEReceivePacket *packet = [self packetWithData:data];
    return packet;
}

/*检测刚接收到的包与缓存中的包得联系
 前提：缓存中最后的分包没有接收完毕
 步骤：
 1:如果刚接收到的包和上缓存中最后一个包不是同一个类型的包（通过sequence和framType判断）则将缓存中相应的包丢弃
 2:如果刚接收到的包和缓存中的最后一个包是同一个类型的，但是帧序号不连续，则将缓存中相应的包丢弃~ 刚收到的包在下一个逻辑中处理
 */
- (void)checkSubPacketSituationWithTheDataJustReceived:(NSData *)data{
    NSInteger messageSequence = [self messageSequecenFrom:data];
    YLLFramTypes framType = [self framTypeFromData:data];
    //获取缓存中最后一个的包
    YLLBLEReceivePacket *cacheLastPacket = [_cachePacketList lastObject];
    if (cacheLastPacket){
        //framNumber > 1则分包了~
        NSInteger framNumber = cacheLastPacket.framNumber;
        NSInteger framIndex = cacheLastPacket.framIndex;
        //分包了,并且分包还没有接收完毕
        if (framNumber > 1 && framNumber != framIndex + 1){
            //是同一类型的分包
            if (messageSequence == cacheLastPacket.framSequence
                && framType == cacheLastPacket.framType){
                UInt8 framIndexOfJustGet = [self framIndexFromData:data];
                //如果序号不连续则丢弃缓存中相应的包，刚收到的包在下一个逻辑中丢弃
                if (framIndex + 1 != framIndexOfJustGet){
                    [self removeCachePacketsType:cacheLastPacket.framType sequence:cacheLastPacket.framSequence];
                }
            }else{//和最后一个包不是同一类型~则丢弃缓存中相应的包
                [self removeCachePacketsType:cacheLastPacket.framType sequence:cacheLastPacket.framSequence];
            }
        }
    }
}

//检测数据分包在之前是否就已经丢弃了~
- (BOOL)checkSubDataAbandonedBefore:(NSData *)data{
    UInt8 framNumber  = [self framNumberFromData:data];
    UInt8 framIndex = [self framIndexFromData:data];
    if (framNumber > 1 && framIndex != 0){//为分包,并且不为第一个包
        UInt8 framType  = [self framTypeFromData:data];
        UInt8 messageSquence = [self messageSequecenFrom:data];
        //获取缓存中最后一个的包
        YLLBLEReceivePacket *cacheLastPacket = [_cachePacketList lastObject];
        if (framType != cacheLastPacket.framType
            || messageSquence != cacheLastPacket.framSequence){
            return YES;
        }
    }
    return NO;
}

//从缓存中移除同一个消息的分包
- (void)removeCachePacketsType:(YLLFramTypes)framTypes sequence:(UInt8)messageSequecen{
    NSInteger count = [_cachePacketList count];
    for (NSInteger index = 0; index < count; index++){
        YLLBLEReceivePacket *packet = [_cachePacketList objectAtIndex:index];
        if (packet && packet.framSequence == messageSequecen && packet.framType == framTypes){
            [_cachePacketList removeObject:packet];
        }
    }
}

/*从_subPacketList中提取完整的数据包(主要针对分包的处理)
 默认接收到的分包在缓存中都是连续的~ 如果不连续就已经在前面的逻辑里面丢弃掉了~
 */
- (NSArray *)pickUpCompletePacketFromSubPacketList:(NSMutableArray *)subPacketList{
    NSInteger count = subPacketList.count;
    NSMutableArray *completePacketList = [NSMutableArray array];
    NSInteger index = 0;
    while (index < count) {
        YLLBLEReceivePacket *packet = [subPacketList objectAtIndex:index];
        NSInteger number = packet.framNumber;
        if (index + number > count){
            break;
        }
        NSArray *packetList = [subPacketList subarrayWithRange:NSMakeRange(index, number)];
        YLLBLEReceivePacket *completePacket = [self combinePacketList:packetList];
        if (completePacket){
            [completePacketList addObject:completePacket];
        }
        index += number;
    }
    
    if (index > 0){
        [subPacketList removeObjectsInRange:NSMakeRange(0, index)];
    }
    return completePacketList;
}

- (YLLBLEReceivePacket *)combinePacketList:(NSArray *)packetList{
    NSInteger packetCount = [packetList count];
    if (packetCount == 0){
        return nil;
    }
    YLLBLEReceivePacket *paceket = [packetList firstObject];
    if (packetCount == 1){
        return paceket;
    }
    
    NSMutableData *sumContenteData = [NSMutableData dataWithData:paceket.content];
    for (int index = 1; index < packetCount; index++){
        YLLBLEReceivePacket *pacekt = [packetList objectAtIndex:index];
        NSData *content = pacekt.content;
        if (content.length > 1){
            NSData *subContentData = [content subdataWithRange:NSMakeRange(1, content.length - 1)];
            if (subContentData.length > 0){
                [sumContenteData appendData:subContentData];
            }
        }
    }
    paceket.framNumber = 1;
    paceket.framIndex = 0;
    return paceket;
}

#pragma mark 从数据包中获取相应的元素
- (YLLFramTypes)framTypeFromData:(NSData *)data{
    Byte *pByte = (Byte *)data.bytes;
    YLLFramTypes type = [Utils byteToInt8:pByte + 4];
    return type;
}

- (YLLDeviceTypes)deviceTypeFromData:(NSData *)data{
    Byte *pByte = (Byte *)data.bytes;
    YLLDeviceTypes type = [Utils byteToInt16:pByte + 6];
    return type;
}

- (UInt8)messageSequecenFrom:(NSData *)data{
    Byte *pByte = (Byte *)data.bytes;
    UInt8 sequecen = [Utils byteToInt8:pByte + 1];
    return sequecen;
}

- (NSData *)contentFromData:(NSData*)data{
    NSData *content = [data subdataWithRange:NSMakeRange(7, data.length - 15)];
    return content;
}

- (UInt8)framNumberFromData:(NSData *)data{
    Byte *pByte = (Byte *)data.bytes;
    UInt8 number = [Utils byteToInt8:pByte + 2];
    return number;
}

- (UInt8)framIndexFromData:(NSData *)data{
    Byte *pByte = (Byte *)data.bytes;
    UInt8 number = [Utils byteToInt8:pByte + 5];
    return number;
}

//检测CRC32
- (BOOL)checkCRC32:(NSData *)data{
    return true;
}

@end

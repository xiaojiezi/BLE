//
//  YLLBLEBasicParser.m
//  Sleepace
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLEParserOriginal.h"
#import "CRC.h"
#import "YLLDataTransferCommon.h"

#define kFramHeadLength (8)
@interface YLLBLEParserOriginal ()
{
    NSData *_preHead;
}
@end

@implementation YLLBLEParserOriginal

+ (YLLBLEReceivePacket *)receiveBluetoothPacketWithData:(NSData *)data {
    YLLBLEParserOriginal *parserOriginal = [[self alloc] init];
    return [parserOriginal receivePacketFrom:data];
}

- (id)init{
    if (self = [super init]){
        _preHead = [Utils streamDataByInt16:kBLEPreCode];
    }
    return self;
}

- (NSArray<YLLBLEReceivePacket *>*)appendData:(NSData *)data{
    if (!data || data.length == 0){
        return nil;
    }
    [_dataBuffer appendData:data];
    NSMutableArray *framDataList = [NSMutableArray array];
    NSInteger bufferLen = _dataBuffer.length;
    NSInteger index = 0;
    
    while (index + kFramHeadLength <= bufferLen) {
        NSData *headData = [_dataBuffer subdataWithRange:NSMakeRange(index, kFramHeadLength)];
        NSData *prefixData = [headData subdataWithRange:NSMakeRange(0, 2)];
        if ([prefixData isEqual:_preHead] && [self checkCRC8:headData]){//数据头合法
            NSInteger framLength = [self framLengthInHeadData:headData];
            if (framLength + index <= bufferLen){
                NSData *framData = [_dataBuffer subdataWithRange:NSMakeRange(index, framLength)];
                NSInteger sequence = [self sequenceInHeadData:headData];
                YLLFramTypes framType = (YLLFramTypes)[self framTypeInHeadData:headData];
                if ([self checkCRC32:framData]){//帧数据合法
                    YLLBLEReceivePacket *recPakcet = [self receivePacketFrom:framData];
                    [recPakcet setDeviceType:YLLDeviceType_Unknown];
                    switch (framType) {
                        case YLLFramType_Post:
                            if (recPakcet){
                                [framDataList addObject:recPakcet];
                            }
                            break;
                        case YLLFramType_ACK:
                        case YLLFramType_Response:
                            if (self.delegate && [self.delegate respondsToSelector:@selector(isFramWithSequenceSendSourceExist:)]){
                                if ([self.delegate isFramWithSequenceSendSourceExist:sequence]){
                                    if (recPakcet){
                                        KFLog_Normal(YES, @"recieve seq = %d data = %@",recPakcet.framSequence,recPakcet.content);
                                        [framDataList addObject:recPakcet];
                                    }
                                }else{
                                    KFLog_Normal(YES, @"check fram data invalid :%@",framData);
                                }
                            }
                            break;
                        default:
                            break;
                    }
                }else{//帧数据不合法
                    //整个帧CRC32不合法则去掉整条数据，接着循环判断消息头合法性
                    KFLog_Normal(YES, @"check CRC32 data illegal: %@",framData);
                    if (framType != YLLFramType_Post){//post消息不合法直接丢弃
                        if (self.delegate && [self.delegate respondsToSelector:@selector(framWithSequenceIllegal:)]){
                            [self.delegate framWithSequenceIllegal:sequence];
                        }
                    }
                }
                index += framLength;
            }else{//数据不够长
                KFLog_Normal(YES, @"CRC8 succeed, but data is not long enough, continue accepting data rest");
                break;
            }
        }else{//数据头不合法
            //消息头CRC8不合法则去掉第一个byte，接着循环判断消息头合法性
            KFLog_Normal(YES, @"check CRC8 data illegal:%@",headData);
            index ++;
        }
    }
    
    //截掉处理过的数据
    if (index > 0){
        [Utils removeDataAtRange:NSMakeRange(0, index) fromDataBuffer:_dataBuffer];
    }
    return framDataList;
}

- (YLLBLEReceivePacket *)receivePacketFrom:(NSData *)packetData{
    Byte *pByte = (Byte *)packetData.bytes;
    NSInteger contentLength = [Utils byteToInt16:pByte+1];
    if (packetData.length != contentLength){
        KFLog_Normal(YES, @"packet data length is not correct");
        return nil;
    }
    YLLBLEReceivePacket *packet = [[YLLBLEReceivePacket alloc] init];
    //包内容
    return packet;
}

//获取帧类型
- (NSInteger)framTypeInHeadData:(NSData *)headData{
    Byte *pByte = (Byte *)headData.bytes;
    NSInteger sequence = [Utils byteToInt8:pByte + 3];
    return sequence;
}

//获取消息序号 老协议里面帧序号和消息序号一样
- (NSInteger)sequenceInHeadData:(NSData *)headData{
    Byte *pByte = (Byte *)headData.bytes;
    NSInteger sequence = [Utils byteToInt8:pByte + 2];
    return sequence;
}

//获取帧的长度
- (NSInteger)framLengthInHeadData:(NSData *)headData{
    Byte *pByte = (Byte *)headData.bytes;
    NSInteger sequence = [Utils byteToInt16:pByte + 1];
    return sequence;
}

//检测消息头是否合法
- (BOOL)checkCRC8:(NSData *)headData{

    return true;
}

//检测帧数据是否合法
- (BOOL)checkCRC32:(NSData *)framData{
    BOOL ret = true;
    return ret;
}
@end

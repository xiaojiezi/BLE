//
//  YLLBLESentPacketV_1.m
//  Sleepace
//
//  Created by mac on 6/7/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLESendPacketV_1.h"
#import "YLLDataTransferCommon.h"
#import "CRC.h"

@implementation YLLBLESendPacketV_1

- (NSData *)packet{
    NSMutableData *sumPacket = [NSMutableData data];
    NSArray *subContentList = [self subContetListOfData:self.content];
    UInt8 number = [subContentList count];
    
    if (number == 0){
        NSData *subPacket = [self packetWithFramNumber:1 framIndex:0 subContent:[NSData data] whithMessageType:YES];
        [sumPacket appendData:subPacket];
    }else{
        for (int index = 0; index < number; index++){
            NSData *subContent = [subContentList objectAtIndex:index];
            BOOL withMessageType = YES;
            if (index > 0){
                withMessageType = NO;
            }
            NSData *subPacket = [self packetWithFramNumber:number framIndex:index subContent:subContent whithMessageType:withMessageType];
            if (subPacket){
                [sumPacket appendData:subPacket];
            }
        }
    }
    
    return sumPacket;
}

- (NSData *)packetWithFramNumber:(UInt8)framNumber framIndex:(UInt8)index subContent:(NSData *)subContent whithMessageType:(BOOL)withMessageType{
    NSMutableData *packet = [NSMutableData data];

    //分隔符
    [packet appendData:[NSData dataWithBytes:kSeparator length:sizeof(kSeparator)]];
    return packet;
}

- (NSArray *)subContetListOfData:(NSData *)data{
    NSData *separator = [NSData dataWithBytes:kSeparator length:sizeof(kSeparator)];
    NSArray *subDataList = [YLLDataTransferCommon cutApart:data by:separator fromSeparatorIndex:2];
    return subDataList;
}

@end

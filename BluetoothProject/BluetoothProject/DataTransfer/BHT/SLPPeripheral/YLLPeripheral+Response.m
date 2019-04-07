//
//  YLLPeripheral+Response.m
//  Sleepace
//
//  Created by mac on 7/14/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLPeripheral+Response.h"
#import "YLLBLEDataAnalyzer.h"
#import "YLLBLECommon.h"
#import "YLLBLEBaseSendPacket.h"
#import "YLLBLEReceivePacket.h"
#import "YLLBLEParserOriginal.h"
#import "YLLBLEParserPromotional.h"

@implementation YLLPeripheral (Response)

//当前的协议类型
- (YLLBLEProtocalType)currentBLEProtocalType{
    YLLBLEProtocalType protocalType = YLLBLEProtocalType_Promotional;
    //z1和z2统一用老协议~ 之后的设备用新协议
    switch (self.deviceType) {
//            protocalType = YLLBLEProtocalType_Original;
            break;
            
        default:
            break;
    }
    return protocalType;
}

//通过消息序号获取发送的数据源
- (YLLBLEBaseSendPacket *)getSendPacketWithSequece:(NSInteger)sequence{
    YLLBLEBaseSendPacket *packet = nil;
    for (YLLBLEBaseSendPacket *aPacket in mSendPacketList){
        if (aPacket.sequence == sequence){
            packet = aPacket;
            break;
        }
    }
    return packet;
}

- (void)appendData:(NSData *)data{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf appendDataOnMainThread:data];
    });
}

- (void)appendDataOnMainThread:(NSData *)data{
    NSArray *packetList = nil;
    if (data.length > 0){
        switch ([self currentBLEProtocalType]) {
            case YLLBLEProtocalType_Original:
                packetList = [mParserV0 appendData:data];
                break;
            case YLLBLEProtocalType_Promotional:
                packetList = [mParserV1 appendData:data];
                break;
            default:
                break;
        }
    }
    if (packetList.count > 0){
        for (YLLBLEReceivePacket *packet in packetList) {
            packet.deviceType = self.deviceType;
        }
        [self receivePacketList:packetList];
    }
}


//收到数据包 全部为完整的数据包
- (void)receivePacketList:(NSArray<YLLBLEReceivePacket *> *)packetList{
    for (YLLBLEReceivePacket *packet in packetList){
        YLLBLEBaseEntity *entity = nil;
        switch (packet.framType) {
            case YLLFramType_Response:
            case YLLFramType_ACK:
            {
                YLLBLEBaseSendPacket *sendPacket = [self getSendPacketWithSequece:packet.framSequence];
                if (sendPacket){
                    entity = [YLLBLEDataAnalyzer analyzData:packet.content withMessageUniqType:sendPacket.uniqMessageType];
                    if (sendPacket.completion){
                        if (entity){
                            KFLog_Normal(YES, @"data received succeed :%@ %@",YLLBLEMessageTypeDescription(sendPacket.uniqMessageType),packet.content);
                            sendPacket.completion (YLLDataTransferReturnStatus_Succeed,entity);
                        }else{
                            KFLog_Normal(YES, @"data miss matched :%@ %@",YLLBLEMessageTypeDescription(sendPacket.uniqMessageType),packet.content);
                            sendPacket.completion (YLLDataTransferReturnStatus_WrongMessageType,nil);
                        }
                    }
                    [mSendPacketList removeObject:sendPacket];
                }else{
                    KFLog_Normal(YES, @"data recieved invalid = %@",packet.content);
                }
                
                //超时停掉
                if (sendPacket){
                    [sendPacket invalidate];
                }
            }
                break;
            case YLLFramType_Post:
                entity = [YLLBLEDataAnalyzer analyzPostData:packet.content withDeviceType:packet.deviceType];
                break;
            default:
                break;
        }
        //检测是否还有其他的用处
        //设备 -> APP post的消息在此处理
        if (entity){
            [entity checkReuseableFor:self.peripheral];
        }
    }
}

#pragma mark YLLBLEBaseParserDelegate
- (BOOL)isFramWithSequenceSendSourceExist:(NSInteger)sequence{
    YLLBLEBaseSendPacket *packet = [self getSendPacketWithSequece:sequence];
    BOOL ret = (packet != nil);
    if (!ret){
        KFLog_Normal(YES, @"fram send source not exist");
    }
    return ret;
}

- (void)framWithSequenceIllegal:(NSInteger)sequence{
    YLLBLEBaseSendPacket *packet = [self getSendPacketWithSequece:sequence];
    if (packet){
        if (packet.completion){
            packet.completion (YLLDataTransferReturnStatus_Illegal,nil);
            [mSendPacketList removeObject:packet];
        }
        KFLog_Normal(YES, @"illigal send source = %@",packet);
    }else{
        KFLog_Normal(YES, @"illigal fram send source not exist");
    }
}

#pragma mark 异常处理
//蓝牙断开的处理
- (void)handleSendPacketWhenBLEDisconnected{
    for (YLLBLEBaseSendPacket *packet in mSendPacketList){
        [packet invalidate];
        if (packet.completion){
            packet.completion(YLLDataTransferReturnStatus_ConnectionDisconnected,nil);
        }
    }
    [mSendPacketList removeAllObjects];
}

//蓝牙禁用的处理
- (void)handleSendPacketWhenBLEDisabled{
    for (YLLBLEBaseSendPacket *packet in mSendPacketList){
        [packet invalidate];
        if (packet.completion){
            packet.completion(YLLDataTransferReturnStatus_ConnectionDisabled,nil);
        }
    }
    [mSendPacketList removeAllObjects];
}
@end

//
//  YLLPeripheral.m
//  Sleepace
//
//  Created by mac on 7/13/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "YLLPeripheral+Response.h"
#import "YLLBLESendPacketV_1.h"

#define kWriteSeverUUID @"0xFFA2"
#define kWriteCharacteristic @"0xFFA4"
#define kReadSeverUUID @"0XFFA5"
#define kReadCharacteristic @"0xFFA9"

#define kBLEWriteDataLength (20)

@interface YLLPeripheral ()<CBPeripheralDelegate,YLLBLEBaseSendPacketDelegate>
{
    CBPeripheral *_peripheral;
    CBCharacteristic  *_readCharactertic;
    CBCharacteristic  *_writeCharactertic;
    NSLock *_sendLock;
}
@property (nonatomic,strong) NSMutableArray<YLLBLEConnectObject *> *connectRequestList;
@property (nonatomic,strong) NSMutableArray <YLLBLEDisconnectObject *> *disconnectRequestList;
@property (nonatomic,readonly) NSString *writeServerUUID;
@property (nonatomic,readonly) NSString *writeCharacteristic;
@property (nonatomic,readonly) NSString *readSeverUUID;
@property (nonatomic,readonly) NSString *readCharacteristic;
@end

@implementation YLLPeripheral
@synthesize peripheral = _peripheral;

- (void)dealloc{
    
}

- (id)init{
    if (self = [super init]){
        self.connectRequestList =  [NSMutableArray array];
        self.disconnectRequestList = [NSMutableArray array];
        mSendPacketList = [NSMutableArray array];
        mParserV0 = [[YLLBLEParserOriginal alloc] init];
        [mParserV0 setDelegate:self];
        mParserV1 = [[YLLBLEParserPromotional alloc] init];
        [mParserV1 setDelegate:self];
        _sendLock = [[NSLock alloc] init];
    }
    return self;
}

- (void)setPeripheral:(CBPeripheral *)peripheral{
    _peripheral = peripheral;
    [_peripheral setDelegate:self];
}

- (void)addConnectRequest:(YLLBLEConnectObject *)request{
    if (!request){
        return;
    }
    [self.connectRequestList addObject:request];
}

- (void)removeConnectRequest:(YLLBLEConnectObject *)request{
    if (request){
        [request invalidate];
        [self.connectRequestList removeObject:request];
    }
}

- (void)connectedSucceed{
    for (YLLBLEConnectObject *request in self.connectRequestList){
        if (request.handle){
            request.handle(YLLBLEConnectReturnCode_Succeed,request.handleID);
        }
        [request invalidate];
    }
    [self.connectRequestList removeAllObjects];
}

- (void)handleConenctRequestListReturnCode:(YLLBLEConnectReturnCodes)code{
    for (YLLBLEConnectObject *request in self.connectRequestList){
        if (request.handle){
            request.handle(code,request.handleID);
        }
        [request invalidate];
    }
    [self.connectRequestList removeAllObjects];
}

- (void)connectFailed{
    [self handleConenctRequestListReturnCode:YLLBLEConnectReturnCode_Failed];
    [self cleanUp];
    
}

//添加断开连接请求
- (void)addDisconnectRequest:(YLLBLEDisconnectObject *)request{
    if (!request){
        return;
    }
    [self.disconnectRequestList addObject:request];
}
//移除断开连接请求
- (void)removeDisconnectRequest:(YLLBLEDisconnectObject *)request{
    if (request){
        [request invalidate];
        [self.disconnectRequestList removeObject:request];
    }
}
//断开连接成功
- (void)disconnectSucceed{
    for (YLLBLEDisconnectObject *request in self.disconnectRequestList){
        if (request.handle){
            request.handle(YLLBLEDisconnectReturnCode_Succeed,request.handleID);
        }
    }
    [self.disconnectRequestList removeAllObjects];
}

- (void)handleDisconenctRequestListReturnCode:(YLLBLEDisconnectReturnCodes)code{
    for (YLLBLEDisconnectObject *request in self.disconnectRequestList){
        if (request.handle){
            request.handle(code,request.handleID);
        }
        [request invalidate];
    }
    [self.disconnectRequestList removeAllObjects];
}

//断开连接失败
- (void)disconnectFailed{
    [self handleDisconenctRequestListReturnCode:YLLBLEDisconnectReturnCode_Failed];
}

- (void)packetSendFailedWithDisconnectCompletion:(YLLTransforCompletion)completion{
    if (completion){
        completion (YLLDataTransferReturnStatus_ConnectionDisconnected, nil);
    }
}

- (NSInteger)maxWriteDataLengthForPacket:(YLLBLEBaseSendPacket *)packet{
    NSInteger dataLen = kBLEWriteDataLength;
    if ([packet isKindOfClass:[YLLBLESendPacketV_1 class]]){
        YLLBLESendPacketV_1 *sendPacket = (YLLBLESendPacketV_1 *)packet;
        
    }
    return dataLen;
}

- (int)sendPacketIntervalForPacket:(YLLBLEBaseSendPacket *)packet{
    NSInteger interval = 10000;
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
    {
        interval =20000;
    }
    if ([packet isKindOfClass:[YLLBLESendPacketV_1 class]]){
        YLLBLESendPacketV_1 *sendPacket = (YLLBLESendPacketV_1 *)packet;
        
    }
    return (int)interval;
}

- (void)sendPacket:(YLLBLEBaseSendPacket *)packet{
    //每次发送数据之前判断当前蓝牙是否在连接状态 如果不是则直接回调蓝牙连接失败
    if (self.peripheral.state != CBPeripheralStateConnected){
        [self performSelectorOnMainThread:@selector(packetSendFailedWithDisconnectCompletion:) withObject:packet.completion waitUntilDone:NO];
        return;
    }
    
    [_sendLock lock];
    [packet setDelegate:self];
    [mSendPacketList addObject:packet];
    [packet fire];
    NSData *data = [packet packet];
    KFLog_Normal(YES, @"send packet %@ %@",packet,data);
    NSInteger dataLen = data.length;
    if (data.length > 0){
        if (self.peripheral && _readCharactertic){
            NSInteger index = 0;
            NSInteger maxWriteDataLen = [self maxWriteDataLengthForPacket:packet];
            int packetSendInterval = [self sendPacketIntervalForPacket:packet];
            do{
                NSInteger len = maxWriteDataLen;
                if (index + len > dataLen){
                    len = dataLen - index;
                }
                NSData *subData = [data subdataWithRange:NSMakeRange(index, len)];
                index += len;
                [self.peripheral writeValue:subData forCharacteristic:_readCharactertic type:[self writeType]];
                if (packetSendInterval > 0){
                    usleep(packetSendInterval);
                }
            }while(index < dataLen);
        }else{
            if (!self.peripheral){
                KFLog_Normal(YES, @"_currentPeripheral is empty");
            }else if (!_readCharactertic){
                KFLog_Normal(YES, @"_readCharactertic is empty");
            }
        }
    }else{
        KFLog_Normal(YES, @"send empty packet");
    }
    
    [_sendLock unlock];
}

#warning Nox2_WiFi版暂用WriteWithResponse
- (CBCharacteristicWriteType)writeType {
    return CBCharacteristicWriteWithoutResponse;
}

- (void)handleDisconnectException{
    //数据请求处理
    [self handleSendPacketWhenBLEDisconnected];
    
    //连接请求处理
    [self handleConenctRequestListReturnCode:YLLBLEConnectReturnCode_Failed];
    [self cleanUp];
}

- (void)handleBluetoothDisableException{
    //数据请求处理
    [self handleSendPacketWhenBLEDisabled];
    
    //连接请求处理
    [self handleConenctRequestListReturnCode:YLLBLEConnectReturnCode_Disable];
    //断开连接请求处理
    [self handleDisconenctRequestListReturnCode:YLLBLEDisconnectReturnCode_Disable];
    [self cleanUp];
}

- (NSString *)readSeverUUID{
    return kReadSeverUUID;
}

- (NSString *)readCharacteristic{
    return kReadCharacteristic;
}

- (NSString *)writeServerUUID{
    return kWriteSeverUUID;
}

- (NSString *)writeCharacteristic{
    return kWriteCharacteristic;
}

- (void)cleanUp{
    if (!_peripheral){
        return;
    }
    
    for (CBService *service in _peripheral.services){
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:self.writeCharacteristic]) {
                if (characteristic.isNotifying) {
                    // It is notifying, so unsubscribe
                    [_peripheral setNotifyValue:NO forCharacteristic:characteristic];
                }
            }
            
            if ([characteristic.UUID isEqual:self.readCharacteristic]){
                if (characteristic.isNotifying) {
                    // It is notifying, so unsubscribe
                    [_peripheral setNotifyValue:NO forCharacteristic:characteristic];
                }
            }
        }
    }
}

- (void)peripheralFailed{
    [self connectFailed];
    if (self.delegate && [self.delegate respondsToSelector:@selector(peripheralFailed:)]){
        [self.delegate peripheralFailed:self];
    }
}

#pragma mark YLLBLEBaseSendPacketDelegate
- (void)sendPacketTimeout:(YLLBLEBaseSendPacket *)sendPacket{
    if (sendPacket.completion){
        sendPacket.completion (YLLDataTransferReturnStatus_TimeOut, nil);
    }
    
    [mSendPacketList removeObject:sendPacket];
}

#pragma mark CBPeripheralDelegate
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error){
        KFLog_Normal(YES, @"#####discoverservices error:%@",error);
//        [self peripheralFailed];
    }else{
        for (CBService *service in peripheral.services){
            //找到服务的uuid  然后判断自己需要的服务UUid  去下一步  特征值UUID
            if ([service.UUID  isEqual:[CBUUID UUIDWithString:self.writeServerUUID]]){
                [_peripheral discoverCharacteristics:nil forService:service];
            }
            else if ([service.UUID  isEqual:[CBUUID UUIDWithString:self.readSeverUUID]]){
                [_peripheral discoverCharacteristics:nil forService:service];
            }
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error){
        KFLog_Normal(YES, @"#####didDiscoverCharacteristicsForService error:%@",error);
//        [self peripheralFailed];
    }else{
        if ([service.UUID isEqual:[CBUUID UUIDWithString:self.writeServerUUID]]){
            for (CBCharacteristic  *characteristic  in service.characteristics ){
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:self.writeCharacteristic]]){
                    _writeCharactertic = characteristic;
                    break;
                }
            }
        }
        if([service.UUID isEqual:[CBUUID UUIDWithString:self.readSeverUUID]]){
            for (CBCharacteristic  *characteristic  in service.characteristics ){
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:self.readCharacteristic]]){
                    _readCharactertic = characteristic;
                    break;
                }
            }
        }
    }
    
    if (_writeCharactertic && _readCharactertic){
        [peripheral setNotifyValue:YES forCharacteristic:_writeCharactertic];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error){
        KFLog_Normal(YES, @"#####didUpdateNotificationStateForCharacteristic error:%@",error);
//        [self peripheralFailed];
    }else{
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:self.writeCharacteristic]]){
            if (characteristic.isNotifying){
                KFLog_Normal(YES, @"peripheral connected");
                [self connectedSucceed];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameBLEDeviceConnected object:peripheral];
                if (_delegate && [_delegate respondsToSelector:@selector(peripheralConnectedSucceed:)]){
                    [_delegate peripheralConnectedSucceed:self];
                }
            }
            else{
                [self connectFailed];
                if (_delegate && [_delegate respondsToSelector:@selector(peripheralConnectedFailed:)]){
                    [_delegate peripheralConnectedFailed:self];
                }
            }
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error){
        KFLog_Normal(YES, @"#####didWriteValueForCharacteristic error:%@",error);
//        [self peripheralFailed];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error){
        KFLog_Normal(YES, @"#####didUpdateValueForCharacteristic error:%@",error);
//        [self peripheralFailed];
    }else{
        if ([characteristic isEqual:_writeCharactertic]){
            NSData *data = characteristic.value;
            if (data.length == 0){
                KFLog_Normal(YES, @"update empty data");
                return;
            }
            KFLog_Normal(YES, @"%@",data);
            [self appendData:data];
        }else{
            KFLog_Normal(YES, @"not this charactertic");
        }
    }
}


@end

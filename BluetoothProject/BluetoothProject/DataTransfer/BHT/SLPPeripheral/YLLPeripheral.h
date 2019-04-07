//
//  YLLPeripheral.h
//  Sleepace
//
//  Created by mac on 7/13/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLLBLEConnectObject.h"
#import "YLLBLEBaseSendPacket.h"

@class YLLBLEBaseSendPacket;
@class YLLBLEParserOriginal;
@class YLLBLEParserPromotional;
@class CBPeripheral;
@protocol YLLPeripheralDelegate;
@interface YLLPeripheral : NSObject
{
    NSMutableArray<YLLBLEBaseSendPacket *> *mSendPacketList;
    YLLBLEParserOriginal *mParserV0;
    YLLBLEParserPromotional *mParserV1;
    
}
@property (nonatomic,weak) id<YLLPeripheralDelegate>delegate;
@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,assign) YLLDeviceTypes deviceType;
@property (nonatomic,copy) NSString *deviceID;


//处理连接断开的异常
- (void)handleDisconnectException;
//处理蓝牙禁用的异常
- (void)handleBluetoothDisableException;
//添加连接请求
- (void)addConnectRequest:(YLLBLEConnectObject *)request;
//移除连接请求
- (void)removeConnectRequest:(YLLBLEConnectObject *)request;
//连接成功
- (void)connectedSucceed;
//连接失败
- (void)connectFailed;

//添加断开连接请求
- (void)addDisconnectRequest:(YLLBLEDisconnectObject *)request;
//移除断开连接请求
- (void)removeDisconnectRequest:(YLLBLEDisconnectObject *)request;
//断开连接成功
- (void)disconnectSucceed;
//断开连接失败
- (void)disconnectFailed;

//发送数据
- (void)sendPacket:(YLLBLEBaseSendPacket *)packet;
@end

@protocol YLLPeripheralDelegate <NSObject>
- (void)peripheralFailed:(YLLPeripheral *)sender;
- (void)peripheralConnectedSucceed:(YLLPeripheral *)sender;
- (void)peripheralConnectedFailed:(YLLPeripheral *)sender;
@end

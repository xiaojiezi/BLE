//
//  YLLBLEManager.h
//  Sleepace
//
//  Created by mac on 7/13/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLLBLEScanObject.h"
#import "YLLPeripheral.h"


#define YLLBLESharedManager [YLLBLEManager sharedBLEManager]
@class CBCentralManager;
@class YLLPeripheral;
@class CBPeripheral;
@class YLLBLEBaseSendPacket;
@interface YLLBLEManager : NSObject<YLLPeripheralDelegate>
{
    CBCentralManager *mCentralManager;
    NSMutableArray<YLLPeripheral *> *mPeripheralList;//连接设备列表
    NSMutableArray<YLLBLEScanObject *> *mScanRequestList;//扫描请求列表
    BOOL mIsScaning;//是否正在扫描
    BOOL mIsCenterManagerInited;//centralManager是否已经初始化
}
+ (YLLBLEManager *)sharedBLEManager;

//发送数据
- (BOOL)sendPacket:(YLLBLEBaseSendPacket *)packet peripheral:(CBPeripheral *)peripheral;

//清除蓝牙的连接
- (void)removePeripheralList:(NSArray<YLLPeripheral *> *)peripheralList;
@end

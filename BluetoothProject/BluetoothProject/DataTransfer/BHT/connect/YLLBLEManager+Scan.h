//
//  YLLBLEManager+Scan.h
//  Sleepace
//
//  Created by mac on 7/13/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLEManager.h"

@interface YLLBLEManager (Scan)

//停止单个扫描
- (void)stopScanHandle:(NSInteger)handleID;
//扫描设置
- (BOOL)scanBluetoothWithTimeoutInterval:(CGFloat)timeOutInterval completion:(YLLBLEScanHandle)handle;

//蓝牙是否打开
- (BOOL)blueToothIsOpen;

///停止所有扫描
- (void)stopAllPeripheralScan;

@end

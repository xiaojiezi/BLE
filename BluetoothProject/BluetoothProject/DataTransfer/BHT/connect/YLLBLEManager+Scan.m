//
//  YLLBLEManager+Scan.m
//  Sleepace
//
//  Created by mac on 7/13/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLEManager+Scan.h"
#import <CoreBluetooth/CoreBluetooth.h>

@implementation YLLBLEManager (Scan)

#pragma mark scan 扫描
- (BOOL)scanBluetoothWithTimeoutInterval:(CGFloat)timeOutInterval completion:(YLLBLEScanHandle)handle{
    if (mIsCenterManagerInited && mCentralManager.state != CBCentralManagerStatePoweredOn){
        KFLog_Normal(YES, @"bluetooth is off");
        return NO;
    }
    
    if (!handle){
        return NO;
    }
    
    if (timeOutInterval == 0){
        timeOutInterval = kBLEDefaultScanTimeoutInterval;
    }
    
    YLLBLEScanObject *scanObject = [[YLLBLEScanObject alloc] init];
    [scanObject setScanHandle:handle];
    [scanObject setTimeoutInterval:timeOutInterval];
    [mScanRequestList addObject:scanObject];
    
    __weak typeof(self) weakSelf = self;
    YLLBLEScanTimeoutHandle timeoutHandle = ^{
        [weakSelf stopScanHandle:scanObject.handleID];
    };
    [scanObject setTimeoutHandle:timeoutHandle];
    
    if (mIsCenterManagerInited){
        if (!mIsScaning){
            KFLog_Normal(YES, @"scan called");
            [self startScan];
        }else{
            KFLog_Normal(YES, @"It is in scaning,no need to rescan");
            [scanObject fire];
        }
    }
    return YES;
}

- (void)startScan{
    KFLog_Normal(YES, @"start scan");
    mIsScaning = YES;
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    CBUUID *uuidA = [CBUUID UUIDWithString:@"FAA0"];
    NSArray *uuidArray = [NSArray arrayWithObjects:uuidA,nil];
    [mCentralManager scanForPeripheralsWithServices:uuidArray options:options];
    
    //fire all scan object
    for (YLLBLEScanObject *scanObject in mScanRequestList){
        [scanObject fire];
    }
}

- (void)stopScan{
    KFLog_Normal(YES, @"stop scan");
    mIsScaning = NO;
    //invalidate all scan object
    for (YLLBLEScanObject *scanObject in mScanRequestList){
        [scanObject invalidate];
    }
    [mScanRequestList removeAllObjects];
    [mCentralManager stopScan];
}

- (void)stopScanHandle:(NSInteger)handleID{
    KFLog_Normal(YES, @"stop single scan");
    YLLBLEScanObject *aScanObject = nil;
    for (YLLBLEScanObject *scanObject in mScanRequestList){
        if (scanObject.handleID == handleID){
            [scanObject invalidate];
            aScanObject = scanObject;
            break;
        }
    }
    
    if (aScanObject){
        [aScanObject invalidate];
        [mScanRequestList removeObject:aScanObject];
    }
    
    if (mScanRequestList.count == 0){
        [self stopScan];
    }
}

- (void)stopAllPeripheralScan
{
    [self stopScan];
}


- (void)checkScan{
    CBManagerState state = mCentralManager.state;
    //CBCentralManager初始化之前的扫描需要重新调用~
    if (!mIsCenterManagerInited){
        if ([mScanRequestList count] != 0 && state == CBCentralManagerStatePoweredOn){
            KFLog_Normal(YES, @"start scan which called before centralManager init");
            [self startScan];
        }else{
            KFLog_Normal(YES, @"bluetooth is not on,remove scanList");
            for (YLLBLEScanObject *scanObject in mScanRequestList){
                if (scanObject.scanHandle){
                    scanObject.scanHandle (YLLBLEScanReturnCode_Disable,scanObject.handleID,nil);
                }
            }
            [mScanRequestList removeAllObjects];
        }
    }else if (state != CBCentralManagerStatePoweredOn){
        KFLog_Normal(YES, @"bluetooth is not on,remove scanList");
        for (YLLBLEScanObject *scanObject in mScanRequestList){
            if (scanObject.scanHandle){
                scanObject.scanHandle (YLLBLEScanReturnCode_Disable,scanObject.handleID,nil);
            }
        }
        [self stopScan];
    }
}

- (BOOL)blueToothIsOpen
{
    if (mCentralManager && mCentralManager.state == CBCentralManagerStatePoweredOn){
        KFLog_Normal(YES, @"bluetooth is on");
        return YES;
    }
    return NO;
}


@end

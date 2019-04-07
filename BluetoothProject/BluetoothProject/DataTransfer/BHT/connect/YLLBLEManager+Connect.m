//
//  YLLBLEManager+Connect.m
//  Sleepace
//
//  Created by mac on 7/13/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLEManager+Connect.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "YLLPeripheral.h"

@implementation YLLBLEManager (Connect)

- (YLLPeripheral *)mostUnusefulPeripheralOBJ{
    NSInteger count = [mPeripheralList count];
    if (count > 0){
        return [mPeripheralList firstObject];
    }
    return nil;
}

- (NSInteger)maxConnectedBluetoothNumber{
    return 4;
}

- (void)addPeripheralOBJ:(YLLPeripheral *)peripheralOBJ{
    NSInteger count = [mPeripheralList count];
    if (count >= [self maxConnectedBluetoothNumber]){
        YLLPeripheral *mostUnusefulOBJ = [self mostUnusefulPeripheralOBJ];
        if (mostUnusefulOBJ){
            CBPeripheralState state = mostUnusefulOBJ.peripheral.state;
            if (state == CBPeripheralStateConnecting || CBPeripheralStateConnected == state){
                [mCentralManager cancelPeripheralConnection:mostUnusefulOBJ.peripheral];
            }
            [self removePeripheralList:@[mostUnusefulOBJ]];
        }
    }
    [mPeripheralList addObject:peripheralOBJ];
}

- (BOOL)connectPeripheral:(CBPeripheral *)peripheral deviceType:(YLLDeviceTypes)deviceType timeout:(CGFloat)timeout completion:(YLLBLEConnectHandle)handle{
    if (mCentralManager.state != CBCentralManagerStatePoweredOn){
        KFLog_Normal(YES, @"bluetooth is off");
        return NO;
    }
    
    if (!peripheral){
        KFLog_Normal(YES, @"empty peripheral")
        return NO;
    }
    
    if (!handle){
        KFLog_Normal(YES, @"conenct handle should not be nil");
        return NO;
    }
    
    if (timeout == 0){
        timeout = kBLEDefaultConnectTimeoutInterval;
    }
    
    YLLPeripheral *peripheralOBJ = nil;
    for (YLLPeripheral *aPeripheral in mPeripheralList){
        if ([aPeripheral.peripheral isEqual:peripheral]){
            peripheralOBJ = aPeripheral;
            break;
        }
    }
    
    if (!peripheralOBJ){
        peripheralOBJ = [[YLLPeripheral alloc] init];
        [peripheralOBJ setPeripheral:peripheral];
        [peripheralOBJ setDeviceType:deviceType];
        [peripheralOBJ setDelegate:self];
        [self addPeripheralOBJ:peripheralOBJ];
    }
    
    YLLBLEConnectObject *connectRequest = [[YLLBLEConnectObject alloc] init];
    [connectRequest setPeripheral:peripheral];
    [connectRequest setHandle:handle];
    [connectRequest setTimeoutInterval:timeout];
    __weak YLLBLEConnectObject *weakRequest = connectRequest;
    [connectRequest setTimeoutHandle:^{
        [peripheralOBJ removeConnectRequest:weakRequest];
    }];
    
    CBPeripheralState state = peripheral.state;
    NSString *statusDescription = @"unknown";
    switch (state) {
        case CBPeripheralStateDisconnected:
            statusDescription = @"CBPeripheralStateDisconnected";
            break;
        case CBPeripheralStateConnecting:
            statusDescription = @"CBPeripheralStateConnecting";
            break;
        case CBPeripheralStateConnected:
        {
            statusDescription = @"CBPeripheralStateConnected";
            
            /////连接蓝牙成功后，1秒后再通讯，防止不能接收bug
            double delayInSeconds = 1.0f;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                handle (YLLBLEConnectReturnCode_Succeed, connectRequest.handleID);
            });
        }
            return YES;
            break;
        default:
            break;
    }
    
    KFLog_Normal(YES, @"current status is %@ %d",statusDescription,(int)state);
    //add connect request to list
    [peripheralOBJ addConnectRequest:connectRequest];
    if (state != YLLConnectStatusConnecting){
        [mCentralManager connectPeripheral:peripheral options:nil];
    }
    [connectRequest fire];
    return YES;
}

- (BOOL)disconnectPeripheral:(CBPeripheral *)peripheral timeout:(CGFloat)timeout completion:(YLLBLEDisconnectHandle)handle{
    if (mCentralManager.state != CBCentralManagerStatePoweredOn){
        KFLog_Normal(YES, @"bluetooth is off");
        return NO;
    }
    
    if (!peripheral){
        KFLog_Normal(YES, @"empty peripheral")
        return NO;
    }
    
    if (timeout == 0){
        timeout = kBLEDefaultConnectTimeoutInterval;
    }
    [mCentralManager stopScan];//停止扫描
    [mCentralManager cancelPeripheralConnection:peripheral];
    if (handle){
        handle (YLLBLEDisconnectReturnCode_Succeed,0);
    }
    return YES;
}

- (BOOL)peripheralIsConnected:(CBPeripheral *)peripheral {
    if (peripheral.state == CBPeripheralStateConnected) {
        return YES;
    }
    return NO;
}

@end

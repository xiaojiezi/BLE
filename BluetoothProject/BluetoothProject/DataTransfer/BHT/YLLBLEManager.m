
//  YLLBLEManager.m
//  Sleepace
//
//  Created by mac on 7/13/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLEManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "YLLPeripheral.h"

@interface YLLBLEManager ()<CBCentralManagerDelegate,YLLPeripheralDelegate>
@end

@implementation YLLBLEManager

+ (YLLBLEManager *)sharedBLEManager{
    static dispatch_once_t onceToken;
    static YLLBLEManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YLLBLEManager alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    if (self = [super init]){
        mCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey: @(NO)}];
        mScanRequestList = [NSMutableArray array];
        mPeripheralList = [NSMutableArray array];
    }
    return self;
}

- (void)checkScan{
    //do this at YLLBLEManager+Scan
}

- (void)removePeripheralList:(NSArray<YLLPeripheral *> *)peripheralList{
    if (peripheralList){
        [mPeripheralList removeObjectsInArray:peripheralList];
    }
    for (YLLPeripheral *peripheral in peripheralList){
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameBLEDeviceDisconnect object:peripheral.peripheral];
    }
}

- (YLLPeripheral *)peripheralObjectOf:(CBPeripheral *)peripheral{
    for (YLLPeripheral *peripheralOBJ in mPeripheralList){
        if ([peripheralOBJ.peripheral isEqual:peripheral]){
            return peripheralOBJ;
        }
    }
    return nil;
}

- (BOOL)sendPacket:(YLLBLEBaseSendPacket *)packet peripheral:(CBPeripheral *)peripheral{
    YLLPeripheral *peripheralOBJ = [self peripheralObjectOf:peripheral];
    if (!peripheralOBJ){
        KFLog_Normal(YES, @"can not find this peripheral");
        return NO;
    }
    [packet setDeviceType:peripheralOBJ.deviceType];
    [peripheralOBJ sendPacket:packet];
    return YES;
}

#pragma mark Exception 异常处理
- (void)printConnectedBluetoothNumber{
    NSInteger number = 0;
    for (YLLPeripheral *peripheralOBJ in mPeripheralList){
        if (peripheralOBJ.peripheral.state == CBPeripheralStateConnected){
            number++;
        }
    }
    KFLog_Normal(YES, @"connected device number = %d",(int)number);
}

- (void)handleBluetoothDisableException{
    for (YLLPeripheral *peripheralOBJ in mPeripheralList){
        [peripheralOBJ handleBluetoothDisableException];
    }
    [self removePeripheralList:[NSArray arrayWithArray:mPeripheralList]];
}

- (void)handleDisconnectException:(CBPeripheral *)peripheral{
    YLLPeripheral *peripheralOBJ = [self peripheralObjectOf:peripheral];
    if (peripheralOBJ){
        KFLog_Normal(YES, @"%d disconnected",(int)peripheralOBJ.deviceType);
        [peripheralOBJ handleDisconnectException];
        [self removePeripheralList:@[peripheralOBJ]];
        [self printConnectedBluetoothNumber];
    }else{
        KFLog_Normal(YES, @"but can not find this bluetooth device");
    }
}


- (void)handleDeviceConnectedFailed:(CBPeripheral *)peripheral{
    if (!peripheral){
        return;
    }
    
    KFLog_Normal(YES, @"device conencted failed");
    YLLPeripheral *peripheralOBJ = [self peripheralObjectOf:peripheral];
    if (peripheralOBJ){
        KFLog_Normal(YES, @"device conencted succeed %d",(int)peripheralOBJ.deviceType);
        [peripheralOBJ connectFailed];
        [self removePeripheralList:@[peripheralOBJ]];
        [self printConnectedBluetoothNumber];
    }else{
        KFLog_Normal(YES, @"but can not find the device");
    }
}

#pragma mark YLLPeripheralDelegate
- (void)disconnect:(YLLPeripheral *)sender{
    [self removePeripheralList:@[sender]];
    CBPeripheralState state = sender.peripheral.state;
    if (state == CBPeripheralStateConnecting || CBPeripheralStateConnected == state){
        sender.peripheral.delegate = nil;
        [mCentralManager cancelPeripheralConnection:sender.peripheral];
    }
    [self printConnectedBluetoothNumber];
}

- (void)peripheralFailed:(YLLPeripheral *)sender{
    KFLog_Normal(YES, @"%d", (int)sender.deviceType);
    [self disconnect:sender];
}

- (void)peripheralConnectedSucceed:(YLLPeripheral *)sender{
    KFLog_Normal(YES, @"%d", (int)sender.deviceType);
    [self printConnectedBluetoothNumber];
}

- (void)peripheralConnectedFailed:(YLLPeripheral *)sender{
    KFLog_Normal(YES, @"%d", (int)sender.deviceType);
    [self disconnect:sender];
}


#pragma mark CBCentralManagerDelegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    [self checkScan];
    mIsCenterManagerInited = YES;
    switch (central.state){
        case CBCentralManagerStatePoweredOn:{
            KFLog_Normal(YES, @"local bluetooth power on");
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameBLEEnable object:nil];
            break;
        }
        case CBCentralManagerStateResetting:
        case CBCentralManagerStateUnknown :
        case CBCentralManagerStateUnsupported:
        case CBCentralManagerStateUnauthorized:
        case  CBCentralManagerStatePoweredOff:{
            KFLog_Normal(YES, @"local bluetooth power off %d",(int)central.state);
            [self handleBluetoothDisableException];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameBLEDisable object:nil];
            break;
        }
        default:
            break;
    }
}

//搜索到周边设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSData *data = [advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey];
    if (data != nil){
        NSString *peripheralDeviceID = [YLLDataTransferCommon converDeviceIDFromData:data];
        NSMutableString *deviceID = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",peripheralDeviceID]];
        YLLDeviceTypes deviceType=0;
        
        
        NSString *name = peripheral.name;
        YLLPeripheralInfo *pheralInfo = [[YLLPeripheralInfo alloc] init];
        [pheralInfo setID:deviceID];
        [pheralInfo setPeripheral:peripheral];
        [pheralInfo setName:name];
        
        NSArray *scanRequestList = [NSArray arrayWithArray:mScanRequestList];
        for (YLLBLEScanObject *scanObject in scanRequestList){
            if (scanObject.scanHandle){
                scanObject.scanHandle (YLLBLEScanReturnCode_Normal,scanObject.handleID,pheralInfo);
            }
        }
    }
}

//与周边设备断开连接
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    KFLog_Normal(YES, @"");
    [self handleDisconnectException:peripheral];
}

//与周边设备连接成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    if (![self peripheralObjectOf:peripheral]){
        KFLog_Normal(YES, @"can not find this bluetooth device");
        [mCentralManager cancelPeripheralConnection:peripheral];
    }else{
        [peripheral discoverServices:nil];
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //
        //        });
    }
}

//与周边设备连接失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    KFLog_Normal(YES, @"");
    [self handleDeviceConnectedFailed:peripheral];
}
@end

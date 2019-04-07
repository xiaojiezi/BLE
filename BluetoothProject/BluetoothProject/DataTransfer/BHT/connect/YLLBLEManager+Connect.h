//
//  YLLBLEManager+Connect.h
//  Sleepace
//
//  Created by mac on 7/13/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLEManager.h"
#import "YLLBLEConnectObject.h"

@class CBPeripheral;
@interface YLLBLEManager (Connect)

- (BOOL)connectPeripheral:(CBPeripheral *)peripheral deviceType:(YLLDeviceTypes)deviceType timeout:(CGFloat)timeout completion:(YLLBLEConnectHandle)handle;

- (BOOL)disconnectPeripheral:(CBPeripheral *)peripheral timeout:(CGFloat)timeout completion:(YLLBLEDisconnectHandle)handle;

- (BOOL)peripheralIsConnected:(CBPeripheral *)peripheral;

@end

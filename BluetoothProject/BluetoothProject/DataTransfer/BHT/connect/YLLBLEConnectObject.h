//
//  YLLBLEConnectObject.h
//  Sleepace
//
//  Created by mac on 6/13/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YLLBLEConnectReturnCodes) {
    YLLBLEConnectReturnCode_Succeed,
    YLLBLEConnectReturnCode_Failed,
    YLLBLEConnectReturnCode_Disable,
    YLLBLEConnectReturnCode_Timeout,
};

typedef void(^YLLBLEConnectHandle)(YLLBLEConnectReturnCodes code,NSInteger connectHandleID);
typedef void (^YLLBLEConnectTimeoutHandle)(void);


@class CBPeripheral;
@interface YLLBLEConnectObject : NSObject
@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,copy) YLLBLEConnectHandle handle;
@property (nonatomic,assign) CGFloat timeoutInterval;
@property (nonatomic,readonly) NSInteger handleID;
@property (nonatomic,copy) YLLBLEConnectTimeoutHandle timeoutHandle;

- (void)fire; //start timer
- (void)invalidate; // invalidate timer
@end

typedef NS_ENUM(NSInteger,YLLBLEDisconnectReturnCodes) {
    YLLBLEDisconnectReturnCode_Succeed,
    YLLBLEDisconnectReturnCode_Failed,
    YLLBLEDisconnectReturnCode_Disable,
    YLLBLEDisconnectReturnCode_Timeout,
};


typedef void(^YLLBLEDisconnectHandle)(YLLBLEDisconnectReturnCodes code,NSInteger disconnectHandleID);
typedef void (^YLLBLEDisconnectTimeoutHandle)(void);
@interface YLLBLEDisconnectObject : NSObject
@property (nonatomic,copy) YLLBLEDisconnectHandle handle;
@property (nonatomic,assign) CGFloat timeoutInterval;
@property (nonatomic,readonly) NSInteger handleID;
@property (nonatomic,copy) YLLBLEDisconnectTimeoutHandle timeoutHandle;

- (void)fire; //start timer
- (void)invalidate; // invalidate timer
@end

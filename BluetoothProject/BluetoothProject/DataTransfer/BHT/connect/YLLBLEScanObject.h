//
//  YLLBLEScanObject.h
//  Sleepace
//
//  Created by mac on 6/12/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CBPeripheral;
@interface YLLPeripheralInfo : NSObject
@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *ID;
@end


typedef NS_ENUM(NSInteger,YLLBLEScanReturnCodes) {
    YLLBLEScanReturnCode_Normal,
    YLLBLEScanReturnCode_Disable,//蓝牙禁止了
    YLLBLEScanReturnCode_TimeOut,
};
typedef void(^YLLBLEScanHandle)(YLLBLEScanReturnCodes code,NSInteger handleID, YLLPeripheralInfo *peripheralInfo);
typedef void (^YLLBLEScanTimeoutHandle)(void);
@interface YLLBLEScanObject : NSObject
@property (nonatomic,copy) YLLBLEScanHandle scanHandle;
@property (nonatomic,assign) CGFloat timeoutInterval;
@property (nonatomic,readonly) NSInteger handleID;
@property (nonatomic,copy)YLLBLEScanTimeoutHandle timeoutHandle;

- (void)fire; //start timer
- (void)invalidate; // invalidate timer
@end

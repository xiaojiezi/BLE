//
//  YLLBLESendData.h
//  Sleepace
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLLDataTransferCommon.h"
#import "YLLBLECommon.h"
#import <UIKit/UIKit.h>

@class YLLBLEBaseSendPacket;
@protocol YLLBLEBaseSendPacketDelegate <NSObject>
//超时
- (void)sendPacketTimeout:(YLLBLEBaseSendPacket *)sendPacket;
@end

@interface YLLBLEBaseSendPacket : NSObject
@property (nonatomic,weak) id<YLLBLEBaseSendPacketDelegate> delegate;
@property (nonatomic,assign) YLLBLEProtocalType protocalType;//协议类型 对应版本
@property (nonatomic,assign) YLLFramTypes framType;//帧类型
@property (nonatomic,assign) NSInteger messageType;//消息类型
@property (nonatomic,readonly) NSInteger sequence;//消息序号
@property (nonatomic,strong) NSData *content;//消息内容 //纯内容，一些参数
//控制用的
//自定义的消息类型~ 和蓝牙的消息一一对应
@property (nonatomic,assign) YLLBLEMessagetUniqTypes uniqMessageType;
//新协议才有的
@property (nonatomic,assign) YLLDeviceTypes deviceType;//设备类型
@property (nonatomic,assign) CGFloat timeout;//超时时间
@property (nonatomic,copy) YLLTransforCompletion completion;

- (NSData *)packet;

- (void)fire;
- (void)invalidate;

@end

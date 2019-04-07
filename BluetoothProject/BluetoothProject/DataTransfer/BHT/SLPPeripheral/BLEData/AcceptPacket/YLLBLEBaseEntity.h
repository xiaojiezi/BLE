//
//  YLLBLEBaseData.h
//  Sleepace
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLLBLECommon.h"


@interface YLLBLEBaseEntity : NSObject
@property (nonatomic,assign) NSInteger messageType;
@property (nonatomic,assign) UInt8 status;
@property (nonatomic,assign) YLLBLEMessagetUniqTypes uniqType;
@property (nonatomic,readonly) BOOL isSucceed;

+ (YLLBLEBaseEntity *)entityWithData:(NSData *)data;
- (id)initWithData:(NSData *)data;


//无参数的消息使用
+ (NSData *)content;

//检测是否还有其他的用处
//设备 -> APP post的消息在此处理
- (void)checkReuseableFor:(id)sender;


@end

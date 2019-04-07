//
//  YLLBLEDataAnalyzer.h
//  Sleepace
//
//  Created by mac on 6/7/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLLBLECommon.h"
#import "YLLDataTransferCommon.h"
#import "YLLBLEBaseEntity.h"

@interface YLLBLEDataAnalyzer : NSObject

//解析Response类型或ACK的消息
+ (YLLBLEBaseEntity *)analyzData:(NSData *)data withMessageUniqType:(YLLBLEMessagetUniqTypes)type;
//解析post类型的数据
+ (YLLBLEBaseEntity *)analyzPostData:(NSData *)data withDeviceType:(YLLDeviceTypes)deviceType;
@end

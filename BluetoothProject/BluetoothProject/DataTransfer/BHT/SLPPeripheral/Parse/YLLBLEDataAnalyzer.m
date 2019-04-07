//
//  YLLBLEDataAnalyzer.m
//  Sleepace
//
//  Created by mac on 6/7/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLEDataAnalyzer.h"

@implementation YLLBLEDataAnalyzer

+ (YLLBLEBaseEntity *)analyzData:(NSData *)data withMessageUniqType:(YLLBLEMessagetUniqTypes)type{
    YLLBLEBaseEntity *entity = nil;
    NSString *classString = [YLLBLECommon entityClassStringFrom:type];
    if (classString){
        entity = [NSClassFromString(classString) entityWithData:data];
    }
    [entity setUniqType:type];
    return entity;
}

//解析post类型的数据
+ (YLLBLEBaseEntity *)analyzPostData:(NSData *)data withDeviceType:(YLLDeviceTypes)deviceType{
    Byte *pByte = (Byte *)data.bytes;
    NSInteger messageType = [Utils byteToInt8:pByte];
    YLLBLEMessagetUniqTypes uniqType = YLLBLEMessagetUniqType_None;
    switch (deviceType) {
        default:
            break;
    }
    
    YLLBLEBaseEntity *entity = nil;
    if (uniqType != YLLBLEMessagetUniqType_None){
        entity = [self analyzData:data withMessageUniqType:uniqType];
    }
    return entity;
}
@end

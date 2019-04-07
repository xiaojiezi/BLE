//
//  YLLBLEBaseData.m
//  Sleepace
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLEBaseEntity.h"

@implementation YLLBLEBaseEntity

+ (YLLBLEBaseEntity *)entityWithData:(NSData *)data{
    return [[self alloc] initWithData:data];
}

- (id)initWithData:(NSData *)data{
    if (self = [super init]){
        //消息类型
        self.messageType = [Utils byteToInt8:(Byte *)data.bytes];
    }
    return self;
}

- (BOOL)isSucceed{
    return self.status == 0;
}

- (void)checkReuseableFor:(id)sender{
    return;
}

+ (NSData *)content{
    return [NSData data];
}
@end

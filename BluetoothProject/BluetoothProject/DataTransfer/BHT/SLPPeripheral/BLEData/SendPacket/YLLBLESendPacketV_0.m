//
//  YLLBLESentPacketV_0.m
//  Sleepace
//
//  Created by mac on 6/7/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLESendPacketV_0.h"
#import "CRC.h"

@implementation YLLBLESendPacketV_0

- (id)init{
    if (self = [super init]){
        
    }
    return self;
}

- (NSData *)packet{
    NSMutableData *packet = [NSMutableData data];
    
    // 协议包

    
    return packet;
}

- (UInt16)messageLength{
    NSInteger length = 15 + self.content.length;
    return length;
}


@end

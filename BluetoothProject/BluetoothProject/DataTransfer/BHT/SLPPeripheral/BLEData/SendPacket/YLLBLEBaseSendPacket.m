//
//  YLLBLESendData.m
//  Sleepace
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLEBaseSendPacket.h"

#define kMaxSequence (0x7f)

static NSInteger g_sequence = 0;
@interface YLLBLEBaseSendPacket ()
{
    NSTimer *_timer;
    NSInteger _sequence;
}
@end

@implementation YLLBLEBaseSendPacket
@synthesize sequence = _sequence;

- (void)dealloc{
    
}

- (id)init{
    if (self = [super init]){
        //设置消息序号
        _sequence = g_sequence;
        g_sequence ++;
        g_sequence = g_sequence%kMaxSequence;
    }
    return self;
}

- (NSData *)packet{
    return nil;
}

- (void)fire{
    if (self.timeout > 0){
        CGFloat timeout = self.timeout;
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(timeOut:) userInfo:nil repeats:NO];
    }
}

- (void)timeOut:(NSTimer *)timer{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendPacketTimeout:)]){
        [self.delegate sendPacketTimeout:self];
    }
}

- (void)invalidate{
    if (_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

- (NSString *)description{
    NSString *messageTypeDescription = [YLLBLECommon descriptionOfMessagetType:self.uniqMessageType];
    NSString *description = [NSString stringWithFormat:@"%@ seq:%d %@",messageTypeDescription,(int)self.sequence,self.content];
    return description;
}
@end

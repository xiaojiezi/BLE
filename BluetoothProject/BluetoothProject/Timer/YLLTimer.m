//
//  YLLTimer.m
//  Sleepace
//
//  Created by mac on 5/17/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLTimer.h"

@interface YLLTimer ()
{
    NSTimer *_aTimer;
    __weak id _weakTarget;
}
@property (nonatomic,copy) YLLTimerHandle handle;
@end

@implementation YLLTimer
@synthesize timer = _aTimer;

- (void)dealloc{
    
}

- (id)initWithTimerWithTimeInterval:(NSTimeInterval)ti target:(id)target userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo handle:(YLLTimerHandle)handle{
    if (self = [super init]){
        self.handle = handle;
        self.userInfo = userInfo;
        _weakTarget = target;
        _aTimer = [NSTimer timerWithTimeInterval:ti target:self selector:@selector(timeCallback:) userInfo:userInfo repeats:yesOrNo];
    }
    return self;
}

- (id)initWithScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)target userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo handle:(nullable YLLTimerHandle)handle{
    if (self = [super init]){
        self.handle = handle;
        self.userInfo = userInfo;
        _weakTarget = target;
        _aTimer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(timeCallback:) userInfo:userInfo repeats:yesOrNo];
    }
    return self;
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)target userInfo:(id)userInfo repeats:(BOOL)yesOrNo handle:(YLLTimerHandle)handle{
    return [[self alloc] initWithTimerWithTimeInterval:ti target:target userInfo:userInfo repeats:yesOrNo handle:handle];
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)target userInfo:(id)userInfo repeats:(BOOL)yesOrNo
                                     handle:( YLLTimerHandle)handle{
    return [[self alloc] initWithScheduledTimerWithTimeInterval:ti target:target userInfo:userInfo repeats:yesOrNo handle:handle];
}

- (NSTimer *)timer{
    return _aTimer;
}

- (void)fire{
    if (self.timer){
        [self.timer fire];
    }
}

- (void)invalidate{
    if (self.timer){
        [self.timer invalidate];
        _aTimer = nil;
    }
}

- (void)pause
{
    if (self.timer){
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)reusme
{
    if (self.timer){
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

- (void)timeCallback:(NSTimer *)timer{
    if (_weakTarget){
        if (self.handle){
            self.handle (self);
        }
    }else{
        [self.timer invalidate];
    }
}
@end

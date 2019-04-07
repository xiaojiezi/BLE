//
//  YLLTimer.h
//  Sleepace
//
//  Created by mac on 5/17/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YLLTimer;
typedef void(^YLLTimerHandle)( YLLTimer* _Nonnull  timer);

@interface YLLTimer : NSObject
@property (nonatomic,readonly) NSTimer  * _Nullable timer;
@property (nonatomic,strong) id _Nullable userInfo;

//target 其实没什么用~ 只是为了判断使用block的页面是否已经释放掉了 如果释放了 就要invalidate这里的timer
+ (YLLTimer * _Nullable)timerWithTimeInterval:(NSTimeInterval)ti target:(id _Nonnull)target userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo handle:(YLLTimerHandle _Nullable)handle;
+ (YLLTimer * _Nullable)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id _Nonnull)target userInfo:(id _Nullable)userInfo repeats:(BOOL)yesOrNo handle:( YLLTimerHandle _Nullable)handle;

- (void)fire;
- (void)invalidate;

///暂停，恢复
- (void)pause;
- (void)reusme;


@end

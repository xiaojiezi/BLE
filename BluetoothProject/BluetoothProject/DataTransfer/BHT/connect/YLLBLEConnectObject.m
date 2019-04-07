//
//  YLLBLEConnectObject.m
//  Sleepace
//
//  Created by mac on 6/13/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLEConnectObject.h"
#import "YLLTimer.h"

#define kMaxConnectHandleID (100000)

static NSInteger g_ConnectHandleID = 0;
@interface YLLBLEConnectObject ()
{
    YLLTimer *_timer;
    NSInteger _handleID;
}
@end

@implementation YLLBLEConnectObject
@synthesize handleID = _handleID;

- (id)init{
    if (self = [super init]){
        g_ConnectHandleID ++;
        g_ConnectHandleID = g_ConnectHandleID%kMaxConnectHandleID;
        _handleID = g_ConnectHandleID;
    }
    return self;
}

- (void)fire{
    if (self.timeoutInterval > 0){
        __weak typeof(self) weakSelf = self;
        _timer = [YLLTimer scheduledTimerWithTimeInterval:self.timeoutInterval target:self userInfo:nil repeats:NO handle:^(YLLTimer * _Nonnull timer) {
            //取消连接
//            [[YLLBLEManager sharedBLEManager] disconnectPeripheral:self.peripheral timeout:0 completion:nil];
            if (weakSelf.handle){
                weakSelf.handle (YLLBLEConnectReturnCode_Timeout,_handleID);
            }
            
            if (weakSelf.timeoutHandle){
                weakSelf.timeoutHandle ();
            }
        }];
    }
}

- (void)invalidate{
    if (_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

@end

@interface YLLBLEDisconnectObject()
{
    YLLTimer *_timer;
    NSInteger _handleID;
}

@end

@implementation YLLBLEDisconnectObject
@synthesize handleID = _handleID;

- (id)init{
    if (self = [super init]){
        g_ConnectHandleID ++;
        g_ConnectHandleID = g_ConnectHandleID%kMaxConnectHandleID;
        _handleID = g_ConnectHandleID;
    }
    return self;
}

- (void)fire{
    if (self.timeoutInterval > 0){
        __weak typeof(self) weakSelf = self;
        _timer = [YLLTimer scheduledTimerWithTimeInterval:self.timeoutInterval target:self userInfo:nil repeats:NO handle:^(YLLTimer * _Nonnull timer) {
            if (weakSelf.handle){
                weakSelf.handle (YLLBLEDisconnectReturnCode_Timeout,_handleID);
            }
            
            if (weakSelf.timeoutHandle){
                weakSelf.timeoutHandle ();
            }
        }];
    }
}

- (void)invalidate{
    if (_timer){
        [_timer invalidate];
        _timer = nil;
    }
}
@end

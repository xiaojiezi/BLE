//
//  YLLBLEScanObject.m
//  Sleepace
//
//  Created by mac on 6/12/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLEScanObject.h"
#import "YLLTimer.h"

#define kMaxConnectHandleID (100000)

static NSInteger g_ScanHandleID = 0;
@interface YLLBLEScanObject ()
{
    NSTimer *_timer;
    NSInteger _handleID;
}
@end

@implementation YLLBLEScanObject
@synthesize handleID = _handleID;

- (void)dealloc{
    
}

- (id)init{
    if (self = [super init]){
        g_ScanHandleID ++;
        g_ScanHandleID = g_ScanHandleID%kMaxConnectHandleID;
        _handleID = g_ScanHandleID;
    }
    return self;
}

- (void)fire{
    if (self.timeoutInterval > 0){
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeoutInterval target:self selector:@selector(timeout:) userInfo:nil repeats:NO];
    }
}

- (void)timeout:(NSTimer *)timer{
    if (self.scanHandle){
        self.scanHandle (YLLBLEScanReturnCode_TimeOut,_handleID,nil);
    }
    if (self.timeoutHandle){
        self.timeoutHandle();
    }
}

- (void)invalidate{
    if (_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

@end

@implementation YLLPeripheralInfo

@end

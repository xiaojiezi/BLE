//
//  YLLBLEBaseParser.m
//  Sleepace
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLEBaseParser.h"

@implementation YLLBLEBaseParser

- (id)init{
    if (self = [super init]){
        _dataBuffer = [NSMutableData data];
    }
    return self;
}

- (void)reset{
    [Utils emptyMutableData:_dataBuffer];
}

- (NSArray<YLLBLEReceivePacket *>*)appendData:(NSData *)data{
    return nil;
}

@end

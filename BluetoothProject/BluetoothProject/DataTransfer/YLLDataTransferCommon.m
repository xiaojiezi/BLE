//
//  YLLDataTransferCommo.m
//  Sleepace
//
//  Created by mac on 6/18/17.
//  Copyright © 2017年 YJ. All rights reserved.
//

#import "YLLDataTransferCommon.h"

@implementation YLLDataTransferCommon

+ (NSArray *)cutApart:(NSData *)data by:(NSData *)separator fromSeparatorIndex:(NSInteger)index{
    NSInteger length = data.length;
    if (!data || length == 0){
        return nil;
    }
    if (length < separator.length){
        return [NSArray arrayWithObject:data];
    }
    
    NSMutableArray *mutArray = [NSMutableArray array];
    NSData *subData = data;
    NSRange range = NSMakeRange(NSNotFound, 0);
    do{
        @autoreleasepool {
            NSInteger subDataLen = subData.length;
            range = [subData rangeOfData:separator options:NSDataSearchBackwards range:NSMakeRange(0, subDataLen)];
            if (range.location != NSNotFound){
                NSInteger location = range.location + index;
                NSData *aData = [subData subdataWithRange:NSMakeRange(location, subDataLen - location)];
                if (aData){
                    [mutArray insertObject:aData atIndex:0];
                }
                subData = [subData subdataWithRange:NSMakeRange(0, location)];
            }
        }
    }while (range.location != NSNotFound);
    
    if (subData){
        [mutArray insertObject:subData atIndex:0];
    }
    
    return mutArray;
}

+ (NSData *)convertDeviceDataFromID:(NSString *)deviceID{
    NSMutableData *mutData = [NSMutableData data];
    NSData *data = [deviceID dataUsingEncoding:NSUTF8StringEncoding];
    if (data){
        [mutData appendData:data];
    }
    if (data.length < 14){
        [mutData appendData:[Utils streamDataByInt8:0]];
    }
    return mutData;
}

+ (NSString *)converDeviceIDFromData:(NSData *)data{
    NSString *deviceID = nil;
    return deviceID;
}
@end

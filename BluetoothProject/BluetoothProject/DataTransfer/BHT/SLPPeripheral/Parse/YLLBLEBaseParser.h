//
//  YLLBLEBaseParser.h
//  Sleepace
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLLBLEReceivePacket.h"

@protocol YLLBLEBaseParserDelegate <NSObject>
/*发送源不存在。1：请求超时 2：分包的情况下~ 前面的包发现不合法*/
- (BOOL)isFramWithSequenceSendSourceExist:(NSInteger)sequence;
//数据是否合法
- (void)framWithSequenceIllegal:(NSInteger)sequence;
@end

@interface YLLBLEBaseParser : NSObject
{
    //单线程的所以不需要用锁
    NSMutableData *_dataBuffer;
}
@property (nonatomic,weak) id<YLLBLEBaseParserDelegate>delegate;

- (void)reset;

- (NSArray<YLLBLEReceivePacket *>*)appendData:(NSData *)data;
@end

//
//  YLLPeripheral+Response.h
//  Sleepace
//
//  Created by mac on 7/14/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLPeripheral.h"
#import "YLLBLEParserOriginal.h"
#import "YLLBLEParserPromotional.h"

@interface YLLPeripheral (Response)<YLLBLEBaseParserDelegate>

- (void)appendData:(NSData *)data;
#pragma mark 异常处理
- (void)handleSendPacketWhenBLEDisconnected;
- (void)handleSendPacketWhenBLEDisabled;


@end

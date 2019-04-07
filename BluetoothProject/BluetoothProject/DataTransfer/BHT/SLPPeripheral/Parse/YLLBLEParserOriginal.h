//
//  YLLBLEBasicParser.h
//  Sleepace
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLLBLEBaseParser.h"

@interface YLLBLEParserOriginal : YLLBLEBaseParser

+ (YLLBLEReceivePacket *)receiveBluetoothPacketWithData:(NSData *)data;

@end

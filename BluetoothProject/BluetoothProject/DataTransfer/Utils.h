//
//  Utils.h
//  Sleepace
//
//  Created by mac on 5/16/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSData *)streamDataByInt64:(int64_t)value;
+ (NSData *)streamDataByInt32:(int32_t)value;
+ (NSData *)streamDataByInt16:(int16_t)value;
+ (NSData *)streamDataByInt8:(int8_t)value;
+ (UInt64)byteToUInt64:(Byte *)byte;
+ (int32_t)byteToInt32:(Byte *)byte;
+ (int16_t)byteToInt16:(Byte *)byte;
+ (int8_t)byteToInt8:(Byte *)byte;
+(short)bytesToShort:(Byte *)src;

//清空mutableData
+ (void)emptyMutableData:(NSMutableData *)mutData;
//从dataBuffer中移除range范围的数据
+ (void)removeDataAtRange:(NSRange)range fromDataBuffer:(NSMutableData *)dataBuffer;

/*从buffer前面开始查找第一个和data相等的location
 data   :要查找的subData
 buffer :源buffer
 range  :要查找的范围
 */
+ (NSRange)searchSubData:(NSData *)subData fromTheBeginOfBuffer:(NSData *)buffer atRange:(NSRange)range;
/*将buffer以separator为分割符分开
 应用场景 TCP或BLE收到数据，通过separator将buffer分割以separator结尾完整的数据包。并将完整的数据包从buffer中移除出去
 buffer :TCP或BLE数据的缓存
 separator  :分隔符
 */
+ (NSArray *)separateBuffer:(NSMutableData *)buffer withSeparator:(NSData *)separator;

@end

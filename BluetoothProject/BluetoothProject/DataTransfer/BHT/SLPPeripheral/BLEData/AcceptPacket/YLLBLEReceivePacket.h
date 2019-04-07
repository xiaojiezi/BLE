//
//  YLLBLEFramData.h
//  Sleepace
//
//  Created by mac on 6/6/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLLDataTransferCommon.h"
#import "YLLBLEBaseEntity.h"

@interface YLLBLEReceivePacket : NSObject
@property (nonatomic,assign) YLLFramTypes framType;//帧类型
@property (nonatomic,assign) YLLDeviceTypes deviceType;//设备类型
@property (nonatomic,assign) UInt8 framSequence;//消息序号 通过这个将接收的内容和发送的内容一一对应起来
/*消息内容
 老协议    :消息类型（1B）+ 消息序号（2B）+消息内容
 新协议    :消息类型 （1B）+ 消息内容
 */
@property (nonatomic,strong) NSData *content;

//分包 碰到包内容里面有分割符 则需要进行分包
@property (nonatomic,assign) UInt8 framNumber;//帧数目
@property (nonatomic,assign) UInt8 framIndex;//帧编号
@end

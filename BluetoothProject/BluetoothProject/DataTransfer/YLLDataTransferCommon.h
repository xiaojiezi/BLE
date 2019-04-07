//
//  YLLDataTransferCommon.h
//  Sleepace
//
//  Created by mac on 5/16/17.
//  Copyright © 2017年 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>

//TCP或蓝牙的帧类型
typedef enum {
    YLLFramType_ACK = 0,
    YLLFramType_Post,
    YLLFramType_Request,
    YLLFramType_Response
}YLLFramTypes;

typedef enum {
    YLLConnectStatusInit = 0, //初始状态
    YLLConnectStatusConnecting,//正在连接
    YLLConnectStatusConnected,//已连接
    YLLConnectStatusDisconnected,//断开连接状态
    
}YLLConnectStatus;


//TCP或蓝牙请求返回值的枚举
typedef NS_ENUM(NSInteger,YLLDataTransferReturnStatus) {
    YLLDataTransferReturnStatus_Succeed = 0,//成功
    YLLDataTransferReturnStatus_ConnectionDisconnected = -1,//连接断开
    YLLDataTransferReturnStatus_TimeOut = -2,//超时
    YLLDataTransferReturnStatus_Illegal = -3,//非法的
    YLLDataTransferReturnStatus_WrongMessageType = -4,//错误的消息类型
    YLLDataTransferReturnStatus_ConnectionDisabled = -5,//连接禁用了 或者网络断开了
};

//post消息放在dictionary中的key
#define kNotificationPostData @"postData"//post的数据

//TCP协议和蓝牙新协议的分隔符,每个包用分割符分开
static const Byte kSeparator[4] = {0x8D,0x7A,0x98,0x72};

/*蓝牙或TCP请求时的回调
 status :TCP或蓝牙请求返回值
 data   :回调的数据,status为YLLDataTransferReturnStatus_Succeed时有效
 */
typedef void(^YLLTransforCompletion)(YLLDataTransferReturnStatus status,id data);

//设备类型
typedef NS_ENUM(NSInteger,YLLDeviceTypes) {
    YLLDeviceType_Unknown = -2, 
    YLLDeviceType_Phone = -1,//手机
    YLLDeviceType_None = 0,//无设备
};



@interface YLLDataTransferCommon : NSObject

//分包
/*
 data: 总的数据
 separator:分隔符
 index:将separactor的前index数据分割给前一段数据 剩余的分割给后一段数据
 */
+ (NSArray *)cutApart:(NSData *)data by:(NSData *)separator fromSeparatorIndex:(NSInteger)index;
+ (NSData *)convertDeviceDataFromID:(NSString *)deviceID;
+ (NSString *)converDeviceIDFromData:(NSData *)data;
@end

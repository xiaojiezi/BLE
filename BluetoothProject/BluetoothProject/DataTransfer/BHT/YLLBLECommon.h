//
//  YLLBLECommon.h
//  Sleepace
//
//  Created by mac on 6/7/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,YLLBLEProtocalType){
    YLLBLEProtocalType_Original = 0,
    YLLBLEProtocalType_Promotional,
};

//蓝牙消息的唯一ID 界面上使用
typedef NS_ENUM(NSInteger,YLLBLEMessagetUniqTypes) {
    //Reston
    YLLBLEMessagetUniqType_RestonLogin = 0,//reston登录
    YLLBLEMessagetUniqType_RestonSetSmartWake,//设置智能唤醒
    YLLBLEMessagetUniqType_RestonGetSmartWake,//获取智能唤醒
    YLLBLEMessagetUniqType_RestonSetAudoCollecting,//设置自动采集
    YLLBLEMessagetUniqType_RestonGetAudoCollecting,//获取自动采集
    YLLBLEMessagetUniqType_RestonGetBattery,//获取电量
    YLLBLEMessagetUniqType_RestonGetDeviceInfo,//获取设备信息
    YLLBLEMessagetUniqType_RestonSetCollectionStatus,//设置采集状态
    YLLBLEMessagetUniqType_RestonGetCollectionStatus,//获取采集状态
    YLLBLEMessagetUniqType_RestonGetDeviceVersion,//获取设备版本信息
    YLLBLEMessagetUniqType_RestonNotify,//通知设备开始上报数据
    YLLBLEMessagetUniqType_RestonPostRealTimeData,//设备向客户端上报实时数据 设备->APP
    YLLBLEMessagetUniqType_RestonPostOriginalData,//设备向客户端上报原始数据 设备->APP
    YLLBLEMessagetUniqType_RestonHistorySummaryQuery,//历史数据的概要查询
    YLLBLEMessagetUniqType_RestonHistoryBoundaryQuery,//历史数据的边界查询
    YLLBLEMessagetUniqType_RestonDownloadHistoryData,//历史数据下载
    YLLBLEMessagetUniqType_RestonDownloadHistoryDataAdditional,
    YLLBLEMessagetUniqType_RestonPostStatus,//控制盒状态上报  设备->APP
    YLLBLEMessagetUniqType_RestonUpgradeSummery,//概要上传请求
    YLLBLEMessagetUniqType_RestonUpgradeContent,//内容上传请求
    YLLBLEMessagetUniqType_RestonGetEnviormentData,//获取环境数据
    
    //Milky
    YLLBLEMessagetUniqType_MilkyTimeCalibration,//时间校准
    YLLBLEMessagetUniqType_MilkyGetSystemInfo,//获取系统信息
    YLLBLEMessagetUniqType_MilkyGetVersionInfo,//获取版本信息
    YLLBLEMessagetUniqType_MilkySetUserInfo,//设置用户信息
    YLLBLEMessagetUniqType_MilkyGetUserInfo,//获取用户信息
    YLLBLEMessagetUniqType_MilkySetSleepTime,//设置睡眠时间
    YLLBLEMessagetUniqType_MilkyGetSleepTime,//获取睡眠时间
    YLLBLEMessagetUniqType_MilkySetAlarm,//闹钟配置
    YLLBLEMessagetUniqType_MilkySetSmartWakeupInfo,//设置智能唤醒
    YLLBLEMessagetUniqType_MilkyGetSmartWakeupInfo,//获取智能唤醒
    YLLBLEMessagetUniqType_MilkySetCollectionStatus,//设置采集状态
    YLLBLEMessagetUniqType_MilkyGetBatteryInfo,//获取电量信息
    YLLBLEMessagetUniqType_MilkyGetSleepStatus,//获取睡眠状态
    YLLBLEMessagetUniqType_MilkyGetCollectionStatus,//获取采集状态
    YLLBLEMessagetUniqType_MilkyHistoryDataQuery,//历史数据查询
    YLLBLEMessagetUniqType_MilkyHistoryDownload,//历史数据下载啊
    YLLBLEMessagetUniqType_MilkySummaryUpload,//升级的概要信息上传
    YLLBLEMessagetUniqType_MilkyContrentUpload,//升级包上传
    
    
    //NOX2
    YLLBLEMessagetUniqType_NOX2TimeCalibration,//时间校准
    YLLBLEMessagetUniqType_NOX2GetSystemInfo,//获取系统信息
    YLLBLEMessagetUniqType_NOX2GetVersionInfo,//获取版本信息
    YLLBLEMessagetUniqType_NOX2ConfigureUserInfo,//配置用户信息
    YLLBLEMessagetUniqType_NOX2ConfigureSleepScene,//睡眠场景配置
    YLLBLEMessagetUniqType_NOX2ConfigureLightScene,//照明场景配置
    YLLBLEMessagetUniqType_NOX2ConfigureCommonScene,//普通设备场景配置
    YLLBLEMessagetUniqType_NOX2ConfigureMultyScene,//多个场景同时配置
    YLLBLEMessagetUniqType_NOX2ConfigureAlarm,//闹铃配置
    YLLBLEMessagetUniqType_NOX2LightOperation,//灯光操作
    YLLBLEMessagetUniqType_NOX2MusicOperation,//音乐操作
    YLLBLEMessagetUniqType_NOX2SceneOperation,//场景操作
    YLLBLEMessagetUniqType_NOX2SleepAidOperation,//助眠操作
    YLLBLEMessagetUniqType_NOX2AlarmOperation,//闹铃操作
    YLLBLEMessagetUniqType_NOX2PreviewOperation,//预览操作
    YLLBLEMessagetUniqType_NOX2PlayOperation,//预览操作
    YLLBLEMessagetUniqType_NOX2GetDeviceStatus,//获取设备状态
    YLLBLEMessagetUniqType_NOX2GetOperatingMode,//获取工作模式
    YLLBLEMessagetUniqType_NOX2GetOperatingModeInLight,//获取工作模式(nox设置灯光)
    YLLBLEMessagetUniqType_NOX2PostOperatingMode,//post工作模式
    YLLBLEMessagetUniqType_NOX2GetMusicList,//获取音乐列表
    YLLBLEMessagetUniqType_NOX2GetProgressOfUPgrade,//获取升级进度
    YLLBLEMessagetUniqType_NOX2UPgradeSummaryUpload,//升级概要信息上传
    YLLBLEMessagetUniqType_NOX2UPgradeContrentUpload,//升级包上传
    YLLBLEMessagetUniqType_NOX2GestureOperation,//手势操作
    YLLBLEMessagetUniqType_NOX2ConfigureWiFi,//配置WiFi
    YLLBLEMessagetUniqType_NOX2NightLightSetting,//小夜灯设置
    YLLBLEMessagetUniqType_NOX2ConfigureAlbum,//配置专辑列表
    YLLBLEMessagetUniqType_NOX2WiFiStatus,///WiFi状态查询
    YLLBLEMessagetUniqType_NOX2IpAddress,///ip地址获取
    
    
    //Pillow
    YLLBLEMessagetUniqType_PillowLogin,//Pillow登录
    YLLBLEMessagetUniqType_PillowSetSmartWake,//设置智能唤醒
    YLLBLEMessagetUniqType_PillowGetSmartWake,//获取智能唤醒
    YLLBLEMessagetUniqType_PillowSetAudoCollecting,//设置自动采集
    YLLBLEMessagetUniqType_PillowGetAudoCollecting,//获取自动采集
    YLLBLEMessagetUniqType_PillowGetBattery,//获取电量
    YLLBLEMessagetUniqType_PillowGetDeviceInfo,//获取设备信息
    YLLBLEMessagetUniqType_PillowSetCollectionStatus,//设置采集状态
    YLLBLEMessagetUniqType_PillowGetCollectionStatus,//获取采集状态
    YLLBLEMessagetUniqType_PillowGetDeviceVersion,//获取设备版本信息
    YLLBLEMessagetUniqType_PillowNotify,//通知设备开始上报数据
    YLLBLEMessagetUniqType_PillowPostRealTimeData,//设备向客户端上报实时数据 设备->APP
    YLLBLEMessagetUniqType_PillowPostOriginalData,//设备向客户端上报原始数据 设备->APP
    YLLBLEMessagetUniqType_PillowHistorySummaryQuery,//历史数据的概要查询
    YLLBLEMessagetUniqType_PillowHistoryBoundaryQuery,//历史数据的边界查询
    YLLBLEMessagetUniqType_PillowDownloadHistoryData,//历史数据下载
    YLLBLEMessagetUniqType_PillowPostStatus,//控制盒状态上报  设备->APP
    YLLBLEMessagetUniqType_PillowUpgradeSummery,//概要上传请求
    YLLBLEMessagetUniqType_PillowUpgradeContent,//内容上传请求
    
    YLLBLEMessagetUniqType_None,
};

//蓝牙设备升级每次发送的最大字节数

#define kDeviceVersionUpgradeMax (512)
typedef NS_ENUM(NSInteger,YLLBLEDeviceUpgradeStage) {
    YLLBLEDeviceUpgradeStage_Succeed,//升级成功
    YLLBLEDeviceUpgradeStage_GetPacketFailed,//获取数据包失败
    YLLBLEDeviceUpgradeStage_GetPacketSucceed,//获取数据包成功
    YLLBLEDeviceUpgradeStage_GetDeviceVersionFailed,//获取设备版本信息失败
    YLLBLEDeviceUpgradeStage_GetDeviceVersionSucceed,//获取设备版本信息成功
    YLLBLEDeviceUpgradeStage_SummaryUploadFailed,//概要信息上传失败
    YLLBLEDeviceUpgradeStage_SummaryUploadSucceed,//概要信息上传成功
    YLLBLEDeviceUpgradeStage_ContentUpgradeFailed,//内容上传失败
    YLLBLEDeviceUpgradeStage_ContentUpgradeSucceed,//内容上传成功
};

//蓝牙传输数据的默认超时时间
#define kBLEDefaultTimeoutInterval (10.0)
//蓝牙扫描的默认的超时时间
#define kBLEDefaultScanTimeoutInterval (10.0)
//蓝牙连接的默认的超时时间
#define kBLEDefaultConnectTimeoutInterval (10.0)

//获取蓝牙消息类型的描述
#define YLLBLEMessageTypeDescription(type) [YLLBLECommon descriptionOfMessagetType:type]

#define kBLEPreCode (0x8ea3) //蓝牙老协议前导码
@interface YLLBLECommon : NSObject

+ (NSString *)descriptionOfMessagetType:(YLLBLEMessagetUniqTypes)type;
+ (NSString *)entityClassStringFrom:(YLLBLEMessagetUniqTypes)type;
@end

//
//  YLLBLECommon.m
//  Sleepace
//
//  Created by mac on 6/7/17.
//  Copyright © 2017 YJ. All rights reserved.
//

#import "YLLBLECommon.H"

@implementation YLLBLECommon
+ (NSString *)descriptionOfMessagetType:(YLLBLEMessagetUniqTypes)type{
    return [self entityClassStringFrom:type];
}

+ (NSString *)entityClassStringFrom:(YLLBLEMessagetUniqTypes)type{
    NSString *classString = nil;
    switch (type) {
#pragma mark Reston
        case YLLBLEMessagetUniqType_RestonLogin:
            classString = @"YLLBLERestonLogin";
            break;
        case YLLBLEMessagetUniqType_RestonSetSmartWake:
            classString = @"YLLBLERestonSetSmartWake";
            break;
        case YLLBLEMessagetUniqType_RestonGetSmartWake:
            classString = @"YLLBLERestonGetSmartWake";
            break;
        case YLLBLEMessagetUniqType_RestonSetAudoCollecting:
            classString = @"YLLBLERestonSetAutoCollection";
            break;
        case YLLBLEMessagetUniqType_RestonGetAudoCollecting:
            classString = @"YLLBLERestonGetAutoCollection";
            break;
        case YLLBLEMessagetUniqType_RestonGetBattery:
            classString = @"YLLBLERestonGetBattery";
            break;
        case YLLBLEMessagetUniqType_RestonGetDeviceInfo:
            classString = @"YLLBLERestonGetDeviceInfo";
            break;
        case YLLBLEMessagetUniqType_RestonSetCollectionStatus:
            classString = @"YLLBLERestonSetCollectionStatus";
            break;
        case YLLBLEMessagetUniqType_RestonGetCollectionStatus:
            classString = @"YLLBLERestonGetCollectionStatus";
            break;
        case YLLBLEMessagetUniqType_RestonGetDeviceVersion:
            classString = @"YLLBLERestonGetDeviceVersion";
            break;
        case YLLBLEMessagetUniqType_RestonNotify:
            classString = @"YLLBLERestonNotifyReston";
            break;
        case YLLBLEMessagetUniqType_RestonPostRealTimeData:
            classString = @"YLLBLERestonRealtimeData";
            break;
        case YLLBLEMessagetUniqType_RestonPostOriginalData:
            classString = @"YLLBLERestonOriginalData";
            break;
        case YLLBLEMessagetUniqType_RestonHistorySummaryQuery:
            classString = @"YLLBLERestonSummaryQuery";
            break;
        case YLLBLEMessagetUniqType_RestonHistoryBoundaryQuery:
            classString = @"YLLBLERestonBoundaryQuery";
            break;
        case YLLBLEMessagetUniqType_RestonDownloadHistoryData:
            classString = @"YLLBLERestonHistoryDataItem";
            break;
        case YLLBLEMessagetUniqType_RestonDownloadHistoryDataAdditional:
            classString = @"YLLBLERestonHistoryDataAdditionalItem";
            break;
        case YLLBLEMessagetUniqType_RestonPostStatus:
            classString = @"YLLBLERestonStatus";
            break;
        case YLLBLEMessagetUniqType_RestonUpgradeSummery:
            classString = @"YLLBLERestonUpgradeSummary";
            break;
        case YLLBLEMessagetUniqType_RestonUpgradeContent:
            classString = @"YLLBLERestonUpgradeContent";
            break;
        case YLLBLEMessagetUniqType_RestonGetEnviormentData:
            classString = @"YLLBLERestonGetEnviormentData";
            break;
#pragma mark Milky
        case YLLBLEMessagetUniqType_MilkyTimeCalibration:
            classString = @"YLLBLEMilkyTimeCalibration";
            break;
        case YLLBLEMessagetUniqType_MilkyGetSystemInfo:
            classString = @"YLLBLEMilkyGetSystemInfo";
            break;
        case YLLBLEMessagetUniqType_MilkyGetVersionInfo:
            classString = @"YLLBLEMilkyGetVersionInfo";
            break;
        case YLLBLEMessagetUniqType_MilkySetUserInfo:
            classString = @"YLLBLEMilkySetUserInfo";
            break;
        case YLLBLEMessagetUniqType_MilkyGetUserInfo:
            classString = @"YLLBLEMilkyGetUserInfo";
            break;
        case YLLBLEMessagetUniqType_MilkySetSleepTime:
            classString = @"YLLBLEMilkySetSleepTime";
            break;
        case YLLBLEMessagetUniqType_MilkyGetSleepTime:
            classString = @"YLLBLEMilkyGetSleepTime";
            break;
        case YLLBLEMessagetUniqType_MilkySetAlarm:
            classString = @"YLLBLEMilkySetAlarm";
            break;
        case YLLBLEMessagetUniqType_MilkySetSmartWakeupInfo:
            classString = @"YLLBLEMilkySetSmartWakeupInfo";
            break;
        case YLLBLEMessagetUniqType_MilkyGetSmartWakeupInfo:
            classString = @"YLLBLEMilkyGetSmartWakeupInfo";
            break;
        case YLLBLEMessagetUniqType_MilkySetCollectionStatus:
            classString = @"YLLBLEMilkyCollectionStatus";
            break;
        case YLLBLEMessagetUniqType_MilkyGetBatteryInfo:
            classString = @"YLLBLEMilkyGetBatteryInfo";
            break;
        case YLLBLEMessagetUniqType_MilkyGetSleepStatus:
            classString = @"YLLBLEMilkySleepStatus";
            break;
        case YLLBLEMessagetUniqType_MilkyGetCollectionStatus:
            classString = @"YLLBLEMilkyGetCollectionStatus";
            break;
        case YLLBLEMessagetUniqType_MilkyHistoryDataQuery:
            classString = @"YLLBLEMilkyHistoryDataQuery";
            break;
        case YLLBLEMessagetUniqType_MilkyHistoryDownload:
            classString = @"YLLBLEMilkyHistoryDataDownload";
            break;
        case YLLBLEMessagetUniqType_MilkySummaryUpload:
            classString = @"YLLBLEMilkyUpgradeSummary";
            break;
        case YLLBLEMessagetUniqType_MilkyContrentUpload:
            classString = @"YLLBLEMilkyUpgradeContent";
            break;
#pragma mark Nox2
        case YLLBLEMessagetUniqType_NOX2TimeCalibration:
            classString=@"YLLBleNoxTimeCheck";
            break;
        case YLLBLEMessagetUniqType_NOX2GetSystemInfo:
            classString =@"YLLBleNoxGetSystemInfo";
            break ;
        case YLLBLEMessagetUniqType_NOX2GetVersionInfo:
            classString=@"YLLBleNoxGetVersionInfo";
            break ;
        case YLLBLEMessagetUniqType_NOX2ConfigureUserInfo:
            classString=@"YLLBleNoxConfigureUserInfo";
            break;
        case YLLBLEMessagetUniqType_NOX2ConfigureSleepScene:
            classString=@"YLLBleNoxConfigureSleepScene";
            break;
        case YLLBLEMessagetUniqType_NOX2ConfigureLightScene:
            classString=@"YLLBleNoxConfigureLightScene";
            break;
        case YLLBLEMessagetUniqType_NOX2ConfigureCommonScene:
            classString=@"YLLBleNoxConfigureCommonScene";
            break;
        case YLLBLEMessagetUniqType_NOX2ConfigureMultyScene:
            classString = @"YLLBleNoxSceneConfigMultyScene";
            break;
        case YLLBLEMessagetUniqType_NOX2ConfigureAlarm:
            classString=@"YLLBleNoxConfigureAlarm";
            break;
        case YLLBLEMessagetUniqType_NOX2LightOperation:
            classString=@"YLLBleNoxSetLight";
            break;
        case YLLBLEMessagetUniqType_NOX2MusicOperation:
            classString=@"YLLBleNoxSetMusic";
            break;
        case YLLBLEMessagetUniqType_NOX2SceneOperation:
            classString=@"YLLBleNoxSetScene";
            break;
        case YLLBLEMessagetUniqType_NOX2SleepAidOperation:
            classString=@"YLLBleNoxSetSleepAid";
            break;
        case YLLBLEMessagetUniqType_NOX2AlarmOperation:
            classString=@"YLLBleNoxSetAlarm";
            break;
        case YLLBLEMessagetUniqType_NOX2PreviewOperation:
            classString=@"YLLBleNoxSetPreview";
            break;
        case YLLBLEMessagetUniqType_NOX2PlayOperation:
            classString=@"YLLBleNoxSetPlay";
            break;
        case YLLBLEMessagetUniqType_NOX2GetDeviceStatus:
            classString=@"YLLBleNoxGetDeviceStatus";
            break;
        case YLLBLEMessagetUniqType_NOX2GetOperatingMode:
            classString=@"YLLBleNoxGetOperatingMode";
            break;
        case YLLBLEMessagetUniqType_NOX2GetOperatingModeInLight:
            classString=@"YLLBleNoxGetModeInLight";
            break;
        case YLLBLEMessagetUniqType_NOX2PostOperatingMode:
            classString = @"YLLBleNoxACKWorkMode";
            break;
        case YLLBLEMessagetUniqType_NOX2GetMusicList:
            classString=@"YLLBleNoxGetMusicList";
            break;
        case YLLBLEMessagetUniqType_NOX2GetProgressOfUPgrade:
            classString=@"YLLBleNoxProgressOfUpgrade";
            break ;
        case YLLBLEMessagetUniqType_NOX2UPgradeSummaryUpload:
            classString=@"YLLBleNoxUpgradeSummary";
            break ;
        case YLLBLEMessagetUniqType_NOX2UPgradeContrentUpload:
            classString=@"YLLBleNoxUpgradeContent";
            break;
        case YLLBLEMessagetUniqType_NOX2GestureOperation:
            classString=@"YLLBleNoxConfigureGesture";
            break;
        case YLLBLEMessagetUniqType_NOX2ConfigureWiFi:
            classString=@"YLLWiFiNOXConfigureWiFi";
            break;
        case YLLBLEMessagetUniqType_NOX2NightLightSetting:
            classString=@"YLLBleNoxConfigureNightLight";
            break;
        case YLLBLEMessagetUniqType_NOX2ConfigureAlbum:
            classString=@"YLLBleNoxConfigureAlbum";
            break;
        case YLLBLEMessagetUniqType_NOX2WiFiStatus:
            classString=@"YLLWiFiNoxConnectStatus";
            break;
        case YLLBLEMessagetUniqType_NOX2IpAddress:
            classString=@"YLLWiFiNoxiPaddress";
            break;
#pragma mark Pillow
        case YLLBLEMessagetUniqType_PillowLogin:
            classString = @"YLLBLEPillowLogin";
            break;
        case YLLBLEMessagetUniqType_PillowSetSmartWake:
            classString = @"YLLBLEPillowSetSmartWake";
            break;
        case YLLBLEMessagetUniqType_PillowGetSmartWake:
            classString = @"YLLBLEPillowGetSmartWake";
            break;
        case YLLBLEMessagetUniqType_PillowSetAudoCollecting:
            classString = @"YLLBLEPillowSetAutoCollection";
            break;
        case YLLBLEMessagetUniqType_PillowGetAudoCollecting:
            classString = @"YLLBLEPillowGetAutoCollection";
            break;
        case YLLBLEMessagetUniqType_PillowGetBattery:
            classString = @"YLLBLEPillowGetBattery";
            break;
        case YLLBLEMessagetUniqType_PillowGetDeviceInfo:
            classString = @"YLLBLEPillowGetDeviceInfo";
            break;
        case YLLBLEMessagetUniqType_PillowSetCollectionStatus:
            classString = @"YLLBLEPillowSetCollectionStatus";
            break;
        case YLLBLEMessagetUniqType_PillowGetCollectionStatus:
            classString = @"YLLBLEPillowGetCollectionStatus";
            break;
        case YLLBLEMessagetUniqType_PillowGetDeviceVersion:
            classString = @"YLLBLEPillowGetDeviceVersion";
            break;
        case YLLBLEMessagetUniqType_PillowNotify:
            classString = @"YLLBLEPillowNotifyPillow";
            break;
        case YLLBLEMessagetUniqType_PillowPostRealTimeData:
            classString = @"YLLBLEPillowRealtimeData";
            break;
        case YLLBLEMessagetUniqType_PillowPostOriginalData:
            classString = @"YLLBLEPillowOriginalData";
            break;
        case YLLBLEMessagetUniqType_PillowHistorySummaryQuery:
            classString = @"YLLBLEPillowSummaryQuery";
            break;
        case YLLBLEMessagetUniqType_PillowHistoryBoundaryQuery:
            classString = @"YLLBLEPillowBoundaryQuery";
            break;
        case YLLBLEMessagetUniqType_PillowDownloadHistoryData:
            classString = @"YLLBLEPillowHistoryDataItem";
            break;
        case YLLBLEMessagetUniqType_PillowPostStatus:
            classString = @"YLLBLEPillowStatus";
            break;
        case YLLBLEMessagetUniqType_PillowUpgradeSummery:
            classString = @"YLLBLEPillowUpgradeSummary";
            break;
        case YLLBLEMessagetUniqType_PillowUpgradeContent:
            classString = @"YLLBLEPillowUpgradeContent";
            break;
        default:
            break;
    }
    return classString;
}

@end

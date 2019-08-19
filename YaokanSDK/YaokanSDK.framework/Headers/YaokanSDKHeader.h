//
//  YaokanSDKHeader.h
//  Pods
//
//  Created by Don on 2017/1/16.
//
//

#ifndef YaokanSDKHeader_h
#define YaokanSDKHeader_h


#import <YaokanSDK/YKRemoteDeviceType.h>
#import <YaokanSDK/YKRemoteDeviceBrand.h>
#import <YaokanSDK/YKRemoteMatchDeviceKey.h>
#import <YaokanSDK/YKRemoteMatchDevice.h>
#import <YaokanSDK/YKRemoteDevice+YKDB.h>
#import <YaokanSDK/YKRemoteDeviceKey+CoreDataClass.h>
#import "YKRemoteDeviceKey+YKDB.h"

extern NSString * _Nonnull const NotificationDeviceListUpdate;

extern NSInteger const YKSDK_SMARTCONFIG_TIMEOUT;

extern NSInteger const  YKSDK_DEVICE_REG_TIMEOUT;

typedef NS_ENUM(NSInteger, RemoteDeviceType){
    kDeviceTypeUnkown = -1,
    kDeviceTypeCustom = 0,          // 自定义
    kDeviceAVType = 1,              // 有线电视机顶盒
    kDeviceTVType = 2,              // 电视机
    kDeviceDVDType = 3,             // DVD播放机
    kDeviceIPTVType = 4,            // IPTV机顶盒
    kDevicePRType = 5,              // 投影仪
    kDeviceFANType = 6,             // 风扇
    kDeviceACType = 7,              // 空调
    kDeviceLightType = 8,           // 智能灯泡
    kDeviceNetAVBoxType = 10,       // 互联网机顶盒
    kDeviceSatelliteType = 11,      // 卫星电视
    kDeviceSweeperType =  12,       // 扫地机
    kDeviceSoundType = 13,          // 音响
    kDeviceCameraType = 14,         // 照相机
    kDeviceAirPurifierType = 15,    // 空气净化器
    kDeviceFootbathType = 16,       // 洗脚盆
    kDeviceCarAudioType = 17,       // 汽车音响
    kDeviceAppleLightType = 18,     // 小苹果夜灯
    kDevice315And433Type = 19,      // 315和433,停用
    kDeviceDIYType = 20,            // DIY
    kDeviceRFSwitchType = 21,       // 射频遥控开关
    kDeviceRFSocketType = 22,       // 射频遥控插座
    kDeviceRFCurtainType = 23,      // 射频遥控窗帘
    kDeviceRFHangerType = 24,       // 射频遥控衣架
    kDeviceRFLightController = 25,  // 灯控器
    kDeviceRFFanLight = 38,         // 风扇灯
    kDeviceRFAirCooler = 41,        // 凉霸
    kDeviceRFFan = 42,              // 射频风扇
};

#endif /* YaokanSDKHeader_h */

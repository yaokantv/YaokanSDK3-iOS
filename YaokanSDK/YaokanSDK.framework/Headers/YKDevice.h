//
//  RCTypeModel.h
//  RemoteMaster
//
//  Created by biu on 11/12/2018.
//  Copyright © 2018 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/**
 @brief RCDeviceNetStatus 枚举，描述 SDK 支持的设备网路状态
 */
typedef NS_ENUM(NSInteger, RCDeviceNetStatus) {
    /** 离线状态 */
    RCDeviceOffline = 0,
    /** 在线状态 */
    RCDeviceOnline = 1,
    /** 可控状态 */
    RCDeviceControlled = 2,
    RCDeviceUnavailable = 3,
};

/**
 @brief RCWirelessType 枚举，支持无线类型
 */
typedef NS_ENUM(NSInteger, RCWirelessType) {
    
    /** 不支持 */
    RCWirelessTypeNone = 0,
    
    /** 红外 */
    RCWirelessTypeIR = 1 << 0,
    
    /** 射频 */
    RCWirelessTypeRF = 1 << 1,
    
    /** 红外和射频 */
    RCWirelessTypeIR_RF = RCWirelessTypeIR | RCWirelessTypeRF,

};

@interface YKDevice : NSObject

/**
 设备的物理地址
 */
@property (strong, nonatomic,readonly) NSString * _Nonnull macAddress;


/**
 设备云端身份标识 DID
 */
@property (strong, nonatomic,readonly) NSString * _Nonnull did;


/**
 NSString类型。设备的产品名称
 */
@property (strong, nonatomic,readonly) NSString * _Nonnull productName;


/**
 NSString类型。设备的备注信息，可以修改，默认为空
 */
@property (strong, nonatomic) NSString * _Nonnull remark;


/**
 NSString类型。设备的别名，可以修改，默认为空
 */
@property (strong, nonatomic,readonly) NSString * _Nonnull alias;


/**
 BOOL类型。设备是否为局域网
 */
@property (assign, nonatomic,readonly) BOOL isLAN;



/**
 RCDeviceNetStatus类型。设备的网络状态
 */
@property (assign, nonatomic) RCDeviceNetStatus netStatus;

/**
 RDRemoteType类型 支持的无线通讯类型
 */
@property (assign, nonatomic,readonly) RCWirelessType wirelessType;


/**
modelName类型 型号
*/
@property (strong, nonatomic,readonly) NSString *modelName;

/**
 当前固件版本
 */
@property (strong, nonatomic,readonly) NSString *version;


/**
 BOOL类型。设备是否已订阅
 */
@property (assign, nonatomic) BOOL isSubscribed;



/**
 BOOL 是否支持射频
 */
@property (assign, nonatomic,readonly) BOOL rf;

+(YKDevice *)deviceByMac:(NSString *)mac;
- (void)updateRemark:(NSString * _Nullable)remark alias:(NSString *)alias;

- (BOOL)isSupprtRF;
+ (BOOL)isRFSupportByType:(NSString *)type;
- (BOOL)isHardwarePreDownload;
@end

NS_ASSUME_NONNULL_END

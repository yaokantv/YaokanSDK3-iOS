//
//  YKRemoteDeviceKey+YKDB.h
//  YKCenterSDK
//
//  Created by Don on 2017/6/29.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import <YaokanSDK/YaokanSDK.h>

static NSString *KeyPowerOn = @"on";
static NSString *KeyPowerOff = @"off";

static NSString *ACModelAuto   = @"auto";    // 自动
static NSString *ACModelCool   = @"cold";    // 制冷
static NSString *ACModelDry    = @"dry";    // 抽湿
static NSString *ACModelWind   = @"wind";    // 送风
static NSString *ACModelHot    = @"hot";    // 制热

@interface YKRemoteDeviceKey (YKDB)

+ (NSArray<YKRemoteDeviceKey *> *)remoteDeviceKeysWithRemote:(YKRemoteDevice *)remote
                                                    contains:(NSString *)value;

+ (YKRemoteDeviceKey *)remoteDeviceKeyInRemoteDevice:(YKRemoteDevice *)remote
                                                 key:(NSString *)key;


@end

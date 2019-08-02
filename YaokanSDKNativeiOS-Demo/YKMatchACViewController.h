//
//  YKMatchACViewController.h
//  YaokanSDKNativeiOS-Demo
//
//  Created by biu on 29/7/2019.
//  Copyright © 2019 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YaokanSDK/YaokanSDK.h>
#import <YaokanSDK/YKRemoteMatchDevice.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKMatchACViewController : UIViewController

@property (nonatomic, strong) YKRemoteMatchDevice *matchDevice;
@property (nonatomic, strong) YKRemoteDeviceType *deviceType;
@property (nonatomic, strong) YKRemoteDeviceBrand *deviceBrand;

@property (nonatomic, weak) IBOutlet UILabel *lb;

@end

NS_ASSUME_NONNULL_END

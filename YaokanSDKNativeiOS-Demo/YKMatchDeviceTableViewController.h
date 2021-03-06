//
//  YKMatchDeviceTableViewController.h
//  YaoSDKNativeiOS-Demo
//
//  Created by Don on 2017/1/17.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YKRemoteDeviceType;
@class YKRemoteDeviceBrand;

/**
 一级匹配列表
 */
@interface YKMatchDeviceTableViewController : UITableViewController

@property (nonatomic, strong) YKRemoteDeviceType *deviceType;
@property (nonatomic, strong) YKRemoteDeviceBrand *deviceBrand;

@end

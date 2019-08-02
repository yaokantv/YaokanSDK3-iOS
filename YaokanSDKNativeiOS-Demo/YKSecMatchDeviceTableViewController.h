//
//  YKSecMatchDeviceTableViewController.h
//  YaokanSDKNativeiOS-Demo
//
//  Created by biu on 25/7/2019.
//  Copyright © 2019 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YKRemoteDeviceType;
@class YKRemoteDeviceBrand;

@interface YKSecMatchDeviceTableViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *lb;
@property (nonatomic, assign) NSInteger tid;
@property (nonatomic, assign) NSInteger bid;
@property (nonatomic, assign) NSInteger gid;

@end

NS_ASSUME_NONNULL_END

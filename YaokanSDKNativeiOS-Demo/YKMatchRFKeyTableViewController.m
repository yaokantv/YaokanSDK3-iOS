//
//  YKMatchRFKeyTableViewController.m
//  YaokanSDKNativeiOS-Demo
//
//  Created by biu on 6/8/2019.
//  Copyright © 2019 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKMatchRFKeyTableViewController.h"
#import <YaokanSDK/YaokanSDK.h>
#import <YaokanSDK/YKDevice.h>
#import "YKCenterCommon.h"
#import "MBProgressHUD.h"

@interface YKMatchRFKeyTableViewController ()
{
    NSArray *keys;
    YKRemoteMatchDevice *matchDevice;
    BOOL isLearning;
}
@end

@implementation YKMatchRFKeyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    keys = @[];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    __weak __typeof(self)weakSelf = self;
   
    [YaokanSDK fetchRFRemoteDeviceWithYKCId:[YKCenterCommon sharedInstance].currentYKCId remoteDeviceTypeId:_tid remoteDeviceBrandId:_bid completion:^(YKRemoteMatchDevice * mDevice, NSArray<YKRemoteMatchDeviceKey *> * matchKeys, NSError * error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        keys = matchKeys;
        matchDevice = mDevice;
        [weakSelf.tableView reloadData];
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (isLearning) {
        [YaokanSDK learnStopWithMatchRemote:matchDevice];
        isLearning = NO;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return keys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YKMatchRFKeyIdentifier"
                                                            forIndexPath:indexPath];
    
    YKRemoteMatchDeviceKey *key = keys[indexPath.row];
    cell.textLabel.text = key.key;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    YKRemoteMatchDeviceKey *key = self.matchDevice.matchKeys[indexPath.row];
    YKRemoteMatchDeviceKey *key = keys[indexPath.row];
    isLearning = YES;
    [YaokanSDK sendRemoteMatchingWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId] matchDevice:matchDevice cmdkey:key.key completion:^(BOOL result, NSError * _Nonnull error) {
        isLearning = NO;
    }];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"学习", nil);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YKRemoteMatchDeviceKey *key = matchDevice.matchKeys[indexPath.row];
        [YaokanSDK learnRFWithMatchRemote:matchDevice key:key.key completion:^(NSString * _Nonnull ridNew, NSError * _Nonnull error) {
            
        }];

    }
    
}

- (IBAction)save:(id)sender {
    //保存
    __weak __typeof(self)weakSelf = self;
    [YaokanSDK saveRFRemoteDeivceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] matchDevice:matchDevice
                                completion:^(YKRemoteDevice * _Nonnull remote, NSError * _Nonnull error) {
        if (remote && error == nil) {
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end

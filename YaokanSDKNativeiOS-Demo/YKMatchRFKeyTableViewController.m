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
    
    [YaokanSDK sendRemoteMatchingWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId] matchDevice:matchDevice cmdkey:key.key completion:^(BOOL result, NSError * _Nonnull error) {
        
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
        [YaokanSDK learnRFMatchingWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remote:matchDevice key:key.key originRid:matchDevice.rid completion:^(NSString * _Nonnull ridNew, NSError * _Nonnull error) {
            
        }];
//        [YaokanSDK learnIRWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remote:_remote key:key.key originRid:_remote.remoteId
//                         completion:^(NSString * _Nonnull ridNew, NSError * _Nonnull error) {
//                             if (error == nil) {
//                                 self.remote.remoteId = ridNew;
//                             }
//                         }];
    }
    
}

- (IBAction)save:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //保存
    __weak __typeof(self)weakSelf = self;
    [YaokanSDK saveRemoteDeivceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDeviceTypeId:_tid remoteDeviceId:matchDevice.rid completion:^(YKRemoteDevice * _Nonnull remote, NSError * _Nonnull error) {
        [MBProgressHUD  hideHUDForView:weakSelf.view animated:YES];
        if (remote && error == nil) {
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end

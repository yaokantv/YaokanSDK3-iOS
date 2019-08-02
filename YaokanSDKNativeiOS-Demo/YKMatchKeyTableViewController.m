//
//  YKMatchKeyTableViewController.m
//  YKCenterDemo
//
//  Created by Don on 2017/1/17.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKMatchKeyTableViewController.h"
#import <YaokanSDK/YaokanSDK.h>
#import <YaokanSDK/YKDevice.h>
#import "YKCenterCommon.h"
#import "MBProgressHUD.h"

@interface YKMatchKeyTableViewController ()
{
    NSArray *keys;
}
@end

@implementation YKMatchKeyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    keys = @[];
    [YaokanSDK requestRemoteDeivceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDeviceTypeId:_matchDevice.typeId remoteDeviceId:_matchDevice.rid completion:^(NSArray * _Nonnull matchKeys, NSError * _Nonnull error) {
        keys = matchKeys;
        [self.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return keys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YKRemoteMatchKeyIdentifier"
                                                            forIndexPath:indexPath];
    
    YKRemoteMatchDeviceKey *key = keys[indexPath.row];
    cell.textLabel.text = key.key;
    cell.detailTextLabel.text = key.kn;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    YKRemoteMatchDeviceKey *key = self.matchDevice.matchKeys[indexPath.row];
    YKRemoteMatchDeviceKey *key = keys[indexPath.row];
    
    [YaokanSDK sendRemoteWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId] remoteId:key.rid remoteDeviceTypeId:_matchDevice.typeId cmdkey:key.key completion:^(BOOL result, NSError * _Nonnull error) {
        
    }];

}

- (IBAction)save:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //保存
    __weak __typeof(self)weakSelf = self;
    [YaokanSDK saveRemoteDeivceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDeviceTypeId:_matchDevice.typeId remoteDeviceId:_matchDevice.rid completion:^(YKRemoteDevice * _Nonnull remote, NSError * _Nonnull error) {
        [MBProgressHUD  hideHUDForView:weakSelf.view animated:YES];
        if (remote && error == nil) {
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end

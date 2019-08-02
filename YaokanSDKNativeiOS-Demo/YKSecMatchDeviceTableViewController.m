//
//  YKSecMatchDeviceTableViewController.m
//  YaokanSDKNativeiOS-Demo
//
//  Created by biu on 25/7/2019.
//  Copyright © 2019 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKSecMatchDeviceTableViewController.h"
#import <YaokanSDK/YaokanSDK.h>
#import "YKCenterCommon.h"
#import "MBProgressHUD.h"

@interface YKSecMatchDeviceTableViewController ()
{
    NSArray *keys;
    NSInteger curIdx;
}
@property (nonatomic, strong) NSArray<YKRemoteMatchDevice *> *matchList;

@end

@implementation YKSecMatchDeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二级匹配发码";
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YaokanSDK requestSecondMatchRemoteDeviceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDeviceTypeId:_tid remoteDeviceBrandId:_bid group:_gid completion:^(NSArray<YKRemoteMatchDevice *> * _Nonnull mathes, NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD  hideHUDForView:weakSelf.view animated:YES];
        strongSelf.matchList = mathes;
        if (mathes.count > 0) {
            curIdx = 0;
            _lb.text = [NSString stringWithFormat:@"1/%ld",strongSelf.matchList.count];
            [strongSelf requestMatchKey:mathes[curIdx]];
        }
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(void)requestMatchKey:(YKRemoteMatchDevice *)matchDevice{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [YaokanSDK requestRemoteDeivceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDeviceTypeId:matchDevice.typeId remoteDeviceId:matchDevice.rid completion:^(NSArray * _Nonnull matchKeys, NSError * _Nonnull error) {
        [MBProgressHUD  hideHUDForView:weakSelf.view animated:YES];
        keys = matchKeys;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return keys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"
                                                            forIndexPath:indexPath];
    YKRemoteMatchDeviceKey *key = keys[indexPath.row];
    cell.textLabel.text = key.key;
    cell.detailTextLabel.text = key.kn;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YKRemoteMatchDeviceKey *key = keys[indexPath.row];
    [YaokanSDK sendRemoteWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId] remoteId:key.rid remoteDeviceTypeId:_tid cmdkey:key.key completion:^(BOOL result, NSError * _Nonnull error) {
        
    }];
}

- (IBAction)pre:(id)sender{
    if (curIdx > 0) {
        curIdx--;
    }
    YKRemoteMatchDevice *matchDevice = _matchList[curIdx];
    [self requestMatchKey:matchDevice];
    _lb.text = [NSString stringWithFormat:@"%ld/%ld",curIdx+1,self.matchList.count];
}

- (IBAction)next:(id)sender{
    if (curIdx <_matchList.count-1) {
        curIdx++;
    }
    YKRemoteMatchDevice *matchDevice = _matchList[curIdx];
    [self requestMatchKey:matchDevice];
    _lb.text = [NSString stringWithFormat:@"%ld/%ld",curIdx+1,self.matchList.count];
}

- (IBAction)save:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    YKRemoteMatchDevice *matchDevice = _matchList[curIdx];
    //保存
    __weak __typeof(self)weakSelf = self;
    [YaokanSDK saveRemoteDeivceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDeviceTypeId:matchDevice.typeId remoteDeviceId:matchDevice.rid completion:^(YKRemoteDevice * _Nonnull remote, NSError * _Nonnull error) {
        [MBProgressHUD  hideHUDForView:weakSelf.view animated:YES];
        if (remote && error == nil) {
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end

//
//  YKMatchDeviceTableViewController.m
//  YaoSDKNativeiOS-Demo
//
//  Created by Don on 2017/1/17.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKMatchDeviceTableViewController.h"
#import <YaokanSDK/YaokanSDK.h>
#import "YKCenterCommon.h"
#import "MBProgressHUD.h"
#import "YKSecMatchDeviceTableViewController.h"

@interface YKMatchDeviceTableViewController ()
@property (nonatomic, strong) NSArray<YKRemoteMatchDevice *> *matchList;
@end

@implementation YKMatchDeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YaokanSDK requestFirstMatchRemoteDeviceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDeviceTypeId:self.deviceType.tid.integerValue remoteDeviceBrandId:self.deviceBrand.bid completion:^(NSArray<YKRemoteMatchDevice *> * _Nonnull mathes, NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD  hideHUDForView:weakSelf.view animated:YES];
        strongSelf.matchList = mathes;
        [strongSelf.tableView reloadData];
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


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YKRemoteMatchCellIdentifier"
                                                            forIndexPath:indexPath];
    YKRemoteMatchDevice *match = self.matchList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long )match.order];
    cell.detailTextLabel.text = match.rid;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     //发送一级匹配
    [self performSegueWithIdentifier:@"segSecMatch" sender:nil];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    YKRemoteMatchDevice *device = self.matchList[indexPath.row];
    [YaokanSDK sendFirstMatchRemoteWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] matchRemote:device completion:^(BOOL result, NSError * _Nonnull error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YKRemoteMatchDevice *device = self.matchList[indexPath.row];
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //保存
        __weak __typeof(self)weakSelf = self;
        [YaokanSDK saveRemoteDeivceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDeviceTypeId:device.typeId remoteDeviceId:device.rid completion:^(YKRemoteDevice * _Nonnull remote, NSError * _Nonnull error) {
            [MBProgressHUD  hideHUDForView:weakSelf.view animated:YES];
            if (remote && error == nil) {
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"Save", nil);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[YKSecMatchDeviceTableViewController class]]) {
        YKSecMatchDeviceTableViewController *vc = segue.destinationViewController;

        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        
        YKRemoteMatchDevice *device = self.matchList[indexPath.row];
        
        vc.gid = device.gid;
        vc.bid = [device.bid integerValue];
        vc.tid = device.typeId;
        
    }
}


@end

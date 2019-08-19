//
//  YKDeviceTypeViewController.m
//  YaoSDKNativeiOS-Demo
//
//  Created by Don on 2017/1/17.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKDeviceTypeViewController.h"
#import <YaokanSDK/YaokanSDK.h>
#import "YKCenterCommon.h"
#import "YKBrandTableViewController.h"
#import "YKSetboxLocationViewController.h"

@interface YKDeviceTypeViewController ()

@property (nonatomic, strong) NSArray<YKRemoteDeviceType *> *typeList;

@end

@implementation YKDeviceTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak __typeof(self)weakSelf = self;
    [YaokanSDK fetchRemoteDeviceTypeWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] completion:^(NSArray<YKRemoteDeviceType *> * _Nonnull types, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@",error);
        }else{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.typeList = types;
            [strongSelf.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.typeList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YKDeviceTypeIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    YKRemoteDeviceType *deviceType = self.typeList[indexPath.row];
    cell.textLabel.text = deviceType.name;
    cell.detailTextLabel.text = @"";
    if (deviceType.rf == 1) {
        cell.detailTextLabel.text = @"射频";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YKRemoteDeviceType *deviceType = self.typeList[indexPath.row];
    if (deviceType.tid.integerValue == kDeviceAVType) {
        YKSetboxLocationViewController *vc = [[UIStoryboard storyboardWithName:@"Remote" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([YKSetboxLocationViewController class])];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        YKBrandTableViewController *vc = [[UIStoryboard storyboardWithName:@"Remote" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([YKBrandTableViewController class])];
        vc.deviceType = deviceType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[YKBrandTableViewController class]]) {
        YKBrandTableViewController *vc = segue.destinationViewController;
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        YKRemoteDeviceType *deviceType = self.typeList[indexPath.row];
        vc.deviceType = deviceType;
    }
}

@end

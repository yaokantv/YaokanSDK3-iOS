//
//  YKRemoteViewController.m
//  YaoSDKNativeiOS-Demo
//
//  Created by Don on 2017/1/19.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKRemoteViewController.h"
#import <YaokanSDK/YaokanSDK.h>
#import "YKCenterCommon.h"

@interface YKRemoteViewController ()
{
    NSArray *keys;
}
@end

@implementation YKRemoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.remote.name;
    
    
    
    
    keys = [self.remote.keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ( ((YKRemoteMatchDeviceKey *)obj1).standard) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    [self.tableView reloadData];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YKRemoteCellIdentifier"
                                                            forIndexPath:indexPath];
    
    YKRemoteDeviceKey *key = keys[indexPath.row];
    cell.textLabel.text = key.key;
    cell.detailTextLabel.text = key.name;
    
    if (key.standard) {
        cell.textLabel.textColor = [UIColor blueColor];
        cell.detailTextLabel.textColor = [UIColor blueColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YKRemoteDeviceKey *key = keys[indexPath.row];

    [YaokanSDK sendRemoteWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDevice:self.remote cmdkey:key.key completion:^(BOOL result, NSError * _Nonnull error) {
        
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
        YKRemoteDeviceKey *key = keys[indexPath.row];
        //射频设备
        if (kDeviceRFSwitchType == self.remote.typeId
            || kDeviceRFSocketType == self.remote.typeId
            || kDeviceRFCurtainType == self.remote.typeId
            || kDeviceRFHangerType == self.remote.typeId) {
            [YaokanSDK learnRFWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remote:_remote key:key.key originRid:_remote.remoteId completion:^(NSString * _Nonnull ridNew, NSError * _Nonnull error) {
                NSLog(@"RF rid :%@",ridNew);
            }];
            
        }else{
            [YaokanSDK learnIRWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remote:_remote key:key.key originRid:_remote.remoteId
                             completion:^(NSString * _Nonnull ridNew, NSError * _Nonnull error) {
                NSLog(@"IR rid :%@",ridNew);
            }];
        }

    }

}

@end

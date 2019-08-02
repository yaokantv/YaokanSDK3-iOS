//
//  YKSetboxLocationViewController.m
//  YaokanSDKNativeiOS-Demo
//
//  Created by biu on 29/7/2019.
//  Copyright © 2019 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKSetboxLocationViewController.h"
#import <YaokanSDK/YaokanSDK.h>
#import "YKMatchDeviceTableViewController.h"
#import "MBProgressHUD.h"


@interface YKSetboxLocationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *provinceArray;
@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, strong) NSArray *carrierArray;

@end

@implementation YKSetboxLocationViewController
{
    __weak IBOutlet UITableView *provinceTableView;
    __weak IBOutlet UITableView *cityTableView;
    __weak IBOutlet UITableView *carrierTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _provinceArray = @[];
    _cityArray = @[];
    _carrierArray = @[];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YaokanSDK requestProvincesWithYKCId:@"" completion:^(NSArray<YKArea *> * _Nonnull areas, NSError * _Nonnull error) {
        __weak __typeof(self)weakSelf = self;
        [MBProgressHUD  hideHUDForView:weakSelf.view animated:YES];
        _provinceArray = areas;
        [provinceTableView reloadData];
    }];
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == provinceTableView) {
        return _provinceArray.count;
    }
    else if (tableView == cityTableView) {
        return _cityArray.count;
    }else if (tableView == carrierTableView) {
        return _carrierArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString * const CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == provinceTableView) {
        YKArea *province = _provinceArray[indexPath.row];
        cell.textLabel.text = province.areaName;
    }
    else if (tableView == cityTableView) {
        YKArea *city = _cityArray[indexPath.row];
        cell.textLabel.text = city.areaName;
        
    }else if (tableView == carrierTableView) {
        YKSetboxCarrier *carrier = _carrierArray[indexPath.row];
        cell.textLabel.text = carrier.cName;
    }
    
    return cell;

}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == provinceTableView) {
         YKArea *province = _provinceArray[indexPath.row];
        [YaokanSDK requestCitiesWithYKCId:@"" provinceId:province.areaId completion:^(NSArray<YKArea *> * _Nonnull cities, NSError * _Nonnull error) {
            _cityArray = cities;
            [cityTableView reloadData];
        }];
    }
    else if (tableView == cityTableView) {
        YKArea *city = _cityArray[indexPath.row];
        [YaokanSDK requestSetboxCarrierWithYKCId:@"" areaId:city.areaId completion:^(NSArray<YKSetboxCarrier *> * _Nonnull setboxCarriers, NSError * _Nonnull error) {
            _carrierArray = setboxCarriers;
            [carrierTableView reloadData];
        }];
    }else if (tableView == carrierTableView) {
        //        return _providerArray.count;
    }
}


- (IBAction)nextStep:(id)sender{
    YKSetboxCarrier *carrier = _carrierArray[carrierTableView.indexPathForSelectedRow.row];
    YKMatchDeviceTableViewController *vc = [[UIStoryboard storyboardWithName:@"Remote" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([YKMatchDeviceTableViewController class])];
    
    YKRemoteDeviceType *type = [YKRemoteDeviceType new];
    type.tid = @(kDeviceAVType);
    YKRemoteDeviceBrand *brand = [YKRemoteDeviceBrand new];
    brand.bid = carrier.bid;

    vc.deviceType = type;
    vc.deviceBrand = brand;
    [self.navigationController pushViewController:vc animated:NO];
}

@end

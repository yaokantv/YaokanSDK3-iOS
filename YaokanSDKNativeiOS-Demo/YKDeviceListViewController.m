//
//  YKViewController.m
//  YaoSDKNativeiOS-Demo
//
//  Created by Don on 2017/1/12.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKDeviceListViewController.h"
#import <YaokanSDK/YaokanSDK.h>
#import <YaokanSDK/YKDevice.h>
#import "MBProgressHUD.h"
#import "YKDeviceListCell.h"

#import "YKCenterCommon.h"

@interface YKDeviceListViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *deviceListArray;

@end

@implementation YKDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getBoundDevice];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NotificationDeviceListUpdate
    __weak __typeof(self)weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:NotificationDeviceListUpdate object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf refreshBtnPressed:nil];
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NotificationDeviceListUpdate
                                                      object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshBtnPressed:(id)sender {
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self getBoundDevice];
}

- (IBAction)actionSheet:(id)sender {
    UIActionSheet *actionSheet = nil;
    NSString *appVersion = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Program Version", nil), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *sdkVersion = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"SDK Version", nil), [YaokanSDK sdkVersion]];
    

        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:[appVersion stringByAppendingFormat:@"-%@", sdkVersion]
                       delegate:self
                       cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                       destructiveButtonTitle:nil
                       otherButtonTitles:
                       NSLocalizedString(@"Add Device", nil),
                       NSLocalizedString(@"Export Devce List", nil)
                       , nil];
    
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}


- (void)getBoundDevice {
    __weak __typeof(self)weakSelf = self;
    [YaokanSDK fetchBoundYKC:^(NSArray<YKDevice *> * _Nonnull devices, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.navigationController.view animated:YES];
        if (error) {
            NSLog(@"error:%@", error.localizedDescription);
            return;
        }

        strongSelf.deviceListArray = devices;
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger offset = 0;
    //    if (![GizCommon sharedInstance].isLogin) {
    //        offset = -1;
    //    }
    if (buttonIndex == offset) {
         [self toAirLink:nil];
    }
    else if (buttonIndex == offset+1) {
        NSString *json =  [YaokanSDK exportYKDevice];
        NSLog(@"%@",json);
    }
}

- (IBAction)toAirLink:(id)sender {
    if (YKGetCurrentSSID().length > 0) {
        [self performSegueWithIdentifier:@"toAirLink" sender:nil];
    } else {
        SHOW_ALERT_CANCEL(NSLocalizedString(@"Please switch to Wifi environment", nil), nil);
    }
}

- (void)showAbout {
//    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"GosSettings" bundle:nil] instantiateInitialViewController];
//    GosSettingsViewController *settingsVC = nav.viewControllers.firstObject;
//    [self.navigationController pushViewController:settingsVC animated:YES];
}

#pragma mark - table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([[self.deviceListArray objectAtIndex:indexPath.section] count] == 0) {
//        return 60;
//    }
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceListArray.count;
}

//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) return NSLocalizedString(@"Bound devices", nil);
//    else if (section == 1) return NSLocalizedString(@"Discovery of new devices", nil);
//    else return NSLocalizedString(@"Offline devices", nil);
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YKDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YKDeviceListCell" owner:self options:nil] lastObject];
                UILabel *lanLabel = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 110, 0, 74, 80)];
                lanLabel.textAlignment = NSTextAlignmentRight;
                lanLabel.tag = 99;
                [cell addSubview:lanLabel];
    }
    
    NSArray *devArr = self.deviceListArray;
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    if ([devArr count] > 0) {
        YKDevice *dev = [devArr objectAtIndex:indexPath.row];
//        NSString *devName = dev.alias;
//        if (devName == nil || devName.length == 0) {
//            devName = dev.productName;
//        }
        cell.title.text = dev.productName;
        [self customCell:cell device:dev];
        cell.imageView.hidden = NO;
        cell.textLabel.text = @"";
    }
    else {
        cell.textLabel.text = NSLocalizedString(@"No device", nil);
        cell.mac.text = @"";
        cell.lan.text = @"";
        [cell.imageView setImage:nil];
    }
    return cell;
}

- (void)customCell:(YKDeviceListCell *)cell device:(YKDevice *)dev {
    // 添加左边的图片
    UIGraphicsBeginImageContext(CGSizeMake(60, 60));
    UIImage *blankImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *subImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"08-icon-Device"]];
    CGRect frame = subImageView.frame;
    
    //将图片居中
    frame.origin = CGPointMake(4, 9);
    subImageView.frame = frame;
    
    [cell.imageView addSubview:subImageView];
    cell.imageView.image = blankImage;
    cell.imageView.layer.cornerRadius = 10;
    
    cell.mac.text = dev.macAddress;
    
    if (dev.netStatus == 1 || dev.netStatus == 2) {
        cell.imageView.backgroundColor = [UIColor brownColor];
        
        cell.lan.text = @"在线";
    }
    else {
        cell.imageView.backgroundColor = [UIColor lightGrayColor];
        cell.lan.text = @"离线";
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    YKDevice *dev = self.deviceListArray[indexPath.row];
    [YaokanSDK toogleLEDWithYKCId:dev.macAddress];
//    [YaokanSDK firmwareCheckWithYKCId:dev.macAddress];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YKDevice *dev = self.deviceListArray[indexPath.row];
    [YKCenterCommon sharedInstance].currentYKCId = dev.macAddress;
    
    [self performSegueWithIdentifier:@"YKRemoteList" sender:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YKDevice *dev = self.deviceListArray[indexPath.row];
        __weak __typeof(self)weakSelf = self;
//        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [YaokanSDK restoreWithYKCId:dev.macAddress];
        [weakSelf refreshBtnPressed:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"Reset", nil);
}


@end

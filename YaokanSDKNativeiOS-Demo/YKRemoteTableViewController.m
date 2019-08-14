//
//  YKRemoteTableViewController.m
//  YaoSDKNativeiOS-Demo
//
//  Created by Don on 2017/1/18.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKRemoteTableViewController.h"
#import <YaokanSDK/YaokanSDK.h>
#import "YKRemoteViewController.h"
#import "YKRemoteACViewController.h"
#import "YKCenterCommon.h"
#import "YKDeviceTypeViewController.h"
#import "MBProgressHUD.h"

@interface YKRemoteTableViewController () <NSFetchedResultsControllerDelegate,UIActionSheetDelegate>

@property (nonatomic) NSArray<YKRemoteDevice *> *remotes;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YKRemoteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadRemoteList];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController == nil) {
        _fetchedResultsController = [YKRemoteDevice fetchedResultsController];
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}

// 当数据库的数据有变化时更新Views
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSArray *items = [controller fetchedObjects];
    //[self setupSubViewsWithItems:items];
    self.remotes = items;
    //    [self updateEditingVisible];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.tableView reloadData];
    });
    
    NSLog(@"%s - items=%lu", __PRETTY_FUNCTION__, (unsigned long)items.count);
}

- (void)loadRemoteList {
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        //exit(-1);  // Fail
    }

    NSArray *items = [_fetchedResultsController fetchedObjects];
    self.remotes = [YKRemoteDevice modelsWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId]];
    
    //    [self updateEditingVisible];
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.remotes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YKRemotesCellIdentifier"
                                                            forIndexPath:indexPath];
    
    YKRemoteDevice *device = self.remotes[indexPath.row];
    NSString *displayName = device.showName;
    if (displayName.length == 0) {
        displayName = device.name;
    }
    cell.textLabel.text = displayName;
    cell.detailTextLabel.text = device.controllerModel;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YKRemoteDevice *device = self.remotes[indexPath.row];
        [YaokanSDK removeRemoteDeivceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remote:device completion:^(NSError * _Nonnull error) {
            
        }];
        [device remove];
//        if ([device remove]) {
//
//            NSLog(@"删除成功");
//        } else {
//            NSLog(@"删除失败");
//        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    YKRemoteDevice *device = self.remotes[indexPath.row];
    NSDictionary *json = [device toJsonObject];
    NSLog(@"%@",json);
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"请输入名称"
                                                                message:@""
                                                         preferredStyle:(UIAlertControllerStyleAlert)];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSString *displayName = device.name;
        textField.placeholder = displayName;
    }];

    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *showNameField = ac.textFields.firstObject;
                                   device.name = showNameField.text;
                                   [device save];
                               }];
    [ac addAction:cancelAction];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (segue.identifier != nil) {
        if ([segue.identifier isEqualToString:@"LearnSegue"]) {
//            YKLearnTableViewController *vc = segue.destinationViewController;
//            YKLearnType learnType = [sender integerValue];
//            vc.learnType = learnType;
        }
        else {
            UITableViewCell *cell = sender;
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            YKRemoteDevice *remote = self.remotes[indexPath.row];
//            NSLog(@"%@",[remote toJsonObject]); //导出Json
            if ([segue.destinationViewController isKindOfClass:[YKRemoteViewController class]]) {
                YKRemoteViewController *vc = segue.destinationViewController;
                vc.remote = remote;
            } else {
                YKRemoteACViewController *vc = segue.destinationViewController;
                vc.remote = remote;
            }
        }
    }
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (identifier != nil) {
        if (![identifier isEqualToString:@"LearnSegue"]) {
            UITableViewCell *cell = sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            YKRemoteDevice *remote = self.remotes[indexPath.row];
            
            if (remote.typeId == kDeviceACType) {
                if ([identifier isEqualToString:@"normal"]) {
                    [self performSegueWithIdentifier:@"ac" sender:sender];
                    return NO;
                }
            }
        }
    }
    
    return YES;
}


- (IBAction)actionSheet:(id)sender {
    UIActionSheet *actionSheet = nil;
//    NSString *appVersion = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Program Version", nil), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
//    NSString *sdkVersion = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"SDK Version", nil), [YaokanSDK sdkVersion]];
//
    
    actionSheet = [[UIActionSheet alloc]
                   initWithTitle:@"选择操作"
                   delegate:self
                   cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                   destructiveButtonTitle:nil
                   otherButtonTitles:
                   NSLocalizedString(@"添加遥控", nil),
                   NSLocalizedString(@"检查升级", nil),
                   NSLocalizedString(@"升级固件", nil)
                   , nil];
    
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger offset = 0;
    //    if (![GizCommon sharedInstance].isLogin) {
    //        offset = -1;
    //    }
    if (buttonIndex == offset) {
//        [self performSegueWithIdentifier:@"AddYK" sender:nil];
        YKDeviceTypeViewController *vc = [[UIStoryboard storyboardWithName:@"Remote" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([YKDeviceTypeViewController class])];
        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController showViewController:navc sender:nil];
    }
    else if (buttonIndex == offset+1) {
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [YaokanSDK checkDeviceVersion:[[YKCenterCommon sharedInstance] currentYKCId] completion:^(NSString * _Nonnull version, NSString * _Nonnull otaVersion, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            NSString *message = [NSString stringWithFormat:@"当前版本:%@ 最新版本:%@",version,otaVersion];
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"检查升级" message:message delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [av show];
        }];
    }else if (buttonIndex == offset+2) {
//        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.detailsLabel.text = @"开始升级...";
        hud.removeFromSuperViewOnHide = YES;
        [hud showAnimated:YES];
        
        [YaokanSDK  updateDeviceVersion:[[YKCenterCommon sharedInstance] currentYKCId] progress:^(float progressNum) {
            NSString *pText = [NSString stringWithFormat:@"%.0f%%",progressNum];
            hud.detailsLabel.text = pText;
            NSLog(@"%@",pText);
        } completion:^(BOOL flag, NSError * _Nonnull error) {
            [hud hideAnimated:YES];
            NSString *message = @"升级失败";
            if (flag) {
                message = @"升级成功,小苹果将自动重启";
            }
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"检查升级" message:message delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [av show];
        }];
        
    }
}


@end

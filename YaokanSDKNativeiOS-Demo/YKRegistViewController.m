//
//  YKLoginViewController.m
//  YaoSDKNativeiOS-Demo
//
//  Created by Don on 2017/3/9.
//  Copyright © 2017年 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKRegistViewController.h"
#import "YKCenterCommon.h"
#import "YKTextCell.h"
#import "YKPasswordCell.h"
#import "YKDeviceListViewController.h"
#import "MBProgressHUD.h"
#import <YaokanSDK/YaokanSDK.h>

// 请将 APP_ID 和YK_APP_SEC 更改为自己的
static NSString *const YK_APP_ID = @"";
static NSString *const YK_APP_SEC = @"";


@interface YKRegistViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) IBOutlet UIView *loginBtnsBar;
@property (assign, nonatomic) IBOutlet UIView *loginQQBtn;
@property (assign, nonatomic) IBOutlet UIView *loginWechatBtn;
@property (assign, nonatomic) IBOutlet UIView *loginWeiboBtn;
@property (assign, nonatomic) IBOutlet UIView *loginSkipBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) YKTextCell *textCell;
@property (strong, nonatomic) YKPasswordCell *passwordCell;
@property (assign, nonatomic) CGFloat top;

@end

@implementation YKRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.view.bounds];
    [shapeLayer setPosition:self.view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0f] CGColor]];
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:2],nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, self.view.frame.size.width,0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [[self.loginBtnsBar layer] addSublayer:shapeLayer];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self sdkRegist];
}

#pragma mark - table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            if (nil == self.textCell) {
                self.textCell = YKGetControllerWithClass([YKTextCell class], tableView, @"textCell");
                self.textCell.textInput.delegate = self;
                self.textCell.textInput.returnKeyType = UIReturnKeyNext;
            }
            return self.textCell;
        case 1:
            if (nil == self.passwordCell) {
                self.passwordCell = YKGetControllerWithClass([YKPasswordCell class], tableView, @"passwordCell");
                self.passwordCell.textPassword.delegate = self;
                self.passwordCell.textPassword.returnKeyType = UIReturnKeyDone;
                [self.passwordCell.btnShowText addTarget:self action:@selector(onShowText) forControlEvents:UIControlEventTouchUpInside];
            }
            return self.passwordCell;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - view animation
- (void)setViewY:(CGFloat)y {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationsEnabled:YES];
    CGRect rc = self.view.frame;
    rc.origin.y = y;
    self.view.frame = rc;
    [UIView commitAnimations];
}

- (void)setShowText:(BOOL)isShow {
    UITextField *textPassword = self.passwordCell.textPassword;
    textPassword.secureTextEntry = !isShow;
    self.passwordCell.btnShowText.selected = isShow;
}


#pragma mark - Event
- (void)onClearPassword {
    self.passwordCell.textPassword.text = @"";
}

- (void)onShowText {
    [self onTap];
    [self setShowText:self.passwordCell.textPassword.secureTextEntry];
}

- (IBAction)onTap {
    [self setViewY:self.top];
    [self.passwordCell.textPassword resignFirstResponder];
}

- (IBAction)sdkRegist{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [YaokanSDK registApp:YK_APP_ID secret:YK_APP_SEC completion:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        });
        if (error) {
            NSLog(@"注册失败 %@",error.description);
            SHOW_ALERT(error.description);
        }else{
            NSLog(@"注册成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UINavigationController *navCtrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
                YKDeviceListViewController *devListCtrl = navCtrl.viewControllers.firstObject;
                devListCtrl.parent = strongSelf;
                //        devListCtrl.needRefresh = YES;
                [strongSelf.navigationController pushViewController:devListCtrl animated:YES];
            });
        }
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textCell.textInput) {
        [self.passwordCell.textPassword becomeFirstResponder];
    } else {
        [self.passwordCell.textPassword resignFirstResponder];
        [self setViewY:self.top];
    }
    return NO;
}
@end

//
//  YKMatchACViewController.m
//  YaokanSDKNativeiOS-Demo
//
//  Created by biu on 29/7/2019.
//  Copyright © 2019 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKMatchACViewController.h"

#import <YaokanSDK/YaokanSDK.h>
#import "YKCenterCommon.h"
#import "MBProgressHUD.h"

@interface YKMatchACViewController ()
{
    NSArray *matchList;
    NSInteger curIdx;
}
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *sweepUDLabel;
@property (weak, nonatomic) IBOutlet UILabel *sweepLRLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@property (nonatomic, strong) NSArray *modelKeys;
@property (nonatomic, strong) NSArray *modelKeyNames;

@property (nonatomic, copy) NSString *currentModel;
@property (nonatomic, assign) NSUInteger temperature;   // 16~30
@property (nonatomic, assign) NSUInteger currentSpeed;  // 0~3
@property (nonatomic, assign) NSUInteger currentWindU;  // 0~1
@property (nonatomic, assign) NSUInteger currentWindL;  // 0~1

@property (nonatomic, strong) NSDictionary *rc_command;  //  支持指令集合

@end

@implementation YKMatchACViewController

- (NSString *)currentModel {
    if (!_currentModel || _currentModel.length == 0) {
        _currentModel = ACModelCool; // cool
    }
    
    return _currentModel;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [YaokanSDK fetchMatchRemoteDeviceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDeviceTypeId:_deviceType.tid.integerValue remoteDeviceBrandId:_deviceBrand.bid completion:^(NSArray<YKRemoteMatchDevice *> * _Nonnull mathes, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (mathes.count > 0) {
            matchList = mathes;
            [strongSelf requestACDetail:mathes[0]];
            _lb.text = [NSString stringWithFormat:@"%ld/%ld",curIdx+1,matchList.count];
        }
    }];
    
//    self.title = self.matchDevice.name;
    
    self.modelKeys = @[ACModelAuto, ACModelCool, ACModelDry, ACModelWind, ACModelHot];
    self.modelKeyNames = @[NSLocalizedString(@"自动", ACModelAuto),
                           NSLocalizedString(@"制冷", ACModelCool),
                           NSLocalizedString(@"抽湿", ACModelDry),
                           NSLocalizedString(@"送风", ACModelWind),
                           NSLocalizedString(@"制热", ACModelHot)];
    self.temperature = 23;
    
    _currentWindL = 0;
    _currentWindU = 0;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateStatusView];
}

- (void)requestACDetail:(YKRemoteMatchDevice *)matchDevice{
     [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    __weak __typeof(self)weakSelf = self;
    [YaokanSDK requestACDetailWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDeviceTypeId:matchDevice.typeId remoteDeviceId:matchDevice.rid completion:^(YKRemoteMatchDevice * _Nonnull remote, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        _matchDevice = remote;
        _rc_command = remote.rc_command;
    }];
}

- (IBAction)modelAction:(id)sender {
    NSInteger modelIndex = [self.modelKeys indexOfObject:_currentModel];
    if (modelIndex + 1 >= self.modelKeys.count) {
        modelIndex = 0;
    } else {
        modelIndex++;
    }
    _currentModel = [self.modelKeys objectAtIndex:modelIndex];
    
    [self remoteControl];
    [self updateStatusView];
}

/**
 风量调整
 
 A 表示自动档
 
 @param sender 消息发送的对象
 */
- (IBAction)windAction:(id)sender {
    NSArray *speeds = _rc_command[@"attributes"][_currentModel][@"speed"];
    NSInteger min = [[speeds objectAtIndex:0] integerValue];
    NSInteger max = [[speeds objectAtIndex:speeds.count-1] integerValue];
    
    if (_currentSpeed < max) {
        _currentSpeed++;
    } else  {
        _currentSpeed = min;
    }
    
    
    [self remoteControl];
    [self updateStatusView];
}


/**
 切换上下扫风
 
 目前仅支持关和自动
 
 @param sender 消息发送的对象
 */
- (IBAction)sweepUDAction:(id)sender {
    if (_currentWindU < 1) {
        _currentWindU++;
    } else if (_currentWindU != INT_MAX) {
        _currentWindU = 0;
    }
    
    [self windUpDown];
    [self updateStatusView];
}

/**
 切换左右扫风
 
 目前仅支持关和自动
 
 @param sender 消息发送的对象
 */
- (IBAction)sweepLRAction:(id)sender {
    if (_currentWindL < 1) {
        _currentWindL++;
    } else if (_currentWindU != INT_MAX) {
        _currentWindL = 0;
    }
    
    [self windLeftRight];
    [self updateStatusView];
}

- (IBAction)tempAction:(UIStepper *)sender {
    _temperature = sender.value;
    [self remoteControl];
    [self updateStatusView];
}

- (IBAction)powerOnAction:(id)sender {
    [YaokanSDK sendRemoteWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId] remoteId:self.matchDevice.rid remoteDeviceTypeId:_matchDevice.typeId cmdkey:KeyPowerOn completion:^(BOOL result, NSError * _Nonnull error) {
        
    }];
    //    [self remoteControl];
    //    [self updateStatusView];
}

- (IBAction)powerOffAction:(id)sender {
    
    [YaokanSDK sendRemoteWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId] remoteId:self.matchDevice.rid remoteDeviceTypeId:_matchDevice.typeId cmdkey:KeyPowerOff completion:^(BOOL result, NSError * _Nonnull error) {
        
    }];
}

- (void)remoteControl {
    NSLog(@"%@",_matchDevice.rc_command);
    [YaokanSDK sendMatchACWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDevice:_matchDevice withMode:self.currentModel temp:self.temperature speed:self.currentSpeed windU:self.currentWindU windL:self.currentWindL completion:^(BOOL result, NSError * _Nonnull error) {
        
    }];
}

- (void)windUpDown {
    [YaokanSDK sendMatchAcWindUDWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDevice:_matchDevice withMode:self.currentModel temp:self.temperature speed:self.currentSpeed windU:self.currentWindU windL:self.currentWindL completion:^(BOOL result, NSError * _Nonnull error) {
        
    }];
}

- (void)windLeftRight {
    [YaokanSDK sendMatchAcWindLRWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] remoteDevice:_matchDevice withMode:self.currentModel temp:self.temperature speed:self.currentSpeed windU:self.currentWindU windL:self.currentWindL completion:^(BOOL result, NSError * _Nonnull error) {
        
    }];
}


- (void)updateStatusView {
    
    NSArray *temperatures = _rc_command[@"attributes"][_currentModel][@"temperature"];
    if (temperatures && temperatures.count > 0)
    {
        _tempLabel.text = [NSString stringWithFormat:@"%ld", (long)_temperature];
    }
    else {
        _tempLabel.text = @"--";
    }
    
    self.modelLabel.text = [self.modelKeyNames objectAtIndex:[self.modelKeys indexOfObject:self.currentModel]];
    
    if (_currentSpeed != INT_MAX) {
        self.windLabel.text = _currentSpeed==0?@"A":[NSString stringWithFormat:@"%lu", (unsigned long)_currentSpeed];
    }
    else {
        self.windLabel.text = @"";
    }
    
    if (_currentWindU != INT_MAX) {
        if (_currentWindU>1) {
            // +1个区间-(关闭和自动)，(u2是一档)
            self.sweepUDLabel.text = [NSString stringWithFormat:@"%ld 档", _currentWindU-1];
        } else if (_currentWindU == 1) {
            // auto mode
            self.sweepUDLabel.text = @"自动";
        } else {
            self.sweepUDLabel.text = @"--";
        }
    }
    else {
        self.sweepUDLabel.text = @"--";
    }
    
    if (_currentWindL != INT_MAX) {
        if (_currentWindL>1) {
            // +1个区间-(关闭和自动)，(l2是一档)
            self.sweepLRLabel.text = [NSString stringWithFormat:@"%ld 档", _currentWindL-1];
        } else if (_currentWindL == 1) {
            // auto mode
            self.sweepLRLabel.text = @"自动";
        } else {
            self.sweepLRLabel.text = @"--";
        }
    }
    else {
        self.sweepLRLabel.text = @"--";
    }
}


- (IBAction)pre:(id)sender{
    if (curIdx > 0) {
        curIdx--;
    }
    YKRemoteMatchDevice *matchDevice = matchList[curIdx];
    [self requestACDetail:matchDevice];
    _lb.text = [NSString stringWithFormat:@"%ld/%ld",curIdx+1,matchList.count];
}

- (IBAction)next:(id)sender{
    if (curIdx < matchList.count-1) {
        curIdx++;
    }
    YKRemoteMatchDevice *matchDevice = matchList[curIdx];
    [self requestACDetail:matchDevice];
    _lb.text = [NSString stringWithFormat:@"%ld/%ld",curIdx+1,matchList.count];
}

- (IBAction)save:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    YKRemoteMatchDevice *matchDevice = matchList[curIdx];
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

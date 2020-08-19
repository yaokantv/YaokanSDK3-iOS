//
//  YKRemoteMatchDevice.h
//  Pods
//
//  Created by Don on 2017/1/18.
//
//

#import <Foundation/Foundation.h>

@class YKRemoteMatchDeviceKey;

@interface YKRemoteMatchDevice : NSObject

@property (nonatomic, copy)     NSString *cmd;              // 一级匹配命令
@property (nonatomic, copy)     NSString *model;            // be_rmodel 被遥控型号
@property (nonatomic, copy)     NSString *bid;              // bid
@property (nonatomic, copy)     NSString *rid;              // rid
@property (nonatomic, copy)     NSString *rmodel;           // rmodel 遥控型号
@property (nonatomic, copy)     NSString *name;             // name
@property (nonatomic, copy)     NSString *desc;             // 描述
@property (nonatomic, assign)   NSInteger gid;              // 一级匹配id
@property (nonatomic, assign)   NSInteger order;            // order
@property (nonatomic, assign)   NSInteger v;                // 遥控码版本
@property (nonatomic, assign)   NSInteger typeId;           // 设备类型 id
@property (nonatomic, copy)   NSString *ykcId;              // 硬件 mac地址
@property (nonatomic, copy)   NSDictionary *rc_command;     // 支持指令

@property (nonatomic, copy)   NSString *study_Id;

@property (nonatomic, copy)   NSString *rf_body;

@property (nonatomic, strong)   NSArray<YKRemoteMatchDeviceKey *> *matchKeys;   // 匹配的按键数组

- (YKRemoteMatchDeviceKey *)keyWithName:(NSString *)kn;
- (BOOL)isRF;
@end

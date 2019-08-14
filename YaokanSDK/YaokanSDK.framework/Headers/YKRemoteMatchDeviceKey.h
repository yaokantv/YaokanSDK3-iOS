//
//  YKRemoteMatchDeviceKey.h
//  Pods
//
//  Created by Don on 2017/1/18.
//
//

#import <Foundation/Foundation.h>

@interface YKRemoteMatchDeviceKey : NSObject

@property (nonatomic, copy)     NSString *key;              // 遥控键名
@property (nonatomic, copy)     NSString *shortCMD;         // short 短码
@property (nonatomic, copy)     NSString *src;              // 原始码
@property (nonatomic, copy)     NSString *reverse_src;      // 反码
@property (nonatomic, copy)     NSString *tip;              // 匹配提示
@property (nonatomic, copy)     NSString *kn;               // 国际化键显示名
@property (nonatomic, assign)   NSInteger zip;              // zip
@property (nonatomic, assign)   NSUInteger order;           // 顺序
@property (nonatomic, copy)     NSString *rid;               //
@property (nonatomic, assign)   NSInteger bid;             //品牌Id
@property (nonatomic, assign)   NSInteger tid;             //品牌Id
@property (nonatomic, assign)   NSUInteger kid;             //指令
@property (nonatomic, assign)   BOOL  standard; //是否为标准键

@end

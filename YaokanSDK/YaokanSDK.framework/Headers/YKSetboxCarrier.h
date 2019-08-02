//
//  YKSetboxCarrier.h
//  YaokanSDK
//
//  Created by biu on 29/7/2019.
//  Copyright © 2019 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKSetboxCarrier : NSObject

@property (nonatomic, assign)   NSInteger cId;           // 地区ID
@property (nonatomic, copy)     NSString *cName;         // 运营商名称
@property (nonatomic, assign)   NSInteger bid;              // 运营商拥有的机顶盒遥控器品牌ID，用于获取一级匹配列表接口中的bid参数值

@end

NS_ASSUME_NONNULL_END

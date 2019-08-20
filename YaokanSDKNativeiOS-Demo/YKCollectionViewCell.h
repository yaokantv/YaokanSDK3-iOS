//
//  YKCollectionViewCell.h
//  YaokanSDKNativeiOS-Demo
//
//  Created by dong on 20/8/2019.
//  Copyright © 2019 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;

@end

NS_ASSUME_NONNULL_END

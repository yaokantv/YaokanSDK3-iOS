//
//  YKCollectionViewCell.m
//  YaokanSDKNativeiOS-Demo
//
//  Created by dong on 20/8/2019.
//  Copyright © 2019 Shenzhen Yaokan Technology Co., Ltd. All rights reserved.
//

#import "YKCollectionViewCell.h"

@implementation YKCollectionViewCell

// 设置高亮效果
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    UIColor *preColor = self.backgroundColor;
    self.backgroundColor = [UIColor lightGrayColor];
    [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor = preColor;
    } completion:nil];
}


@end

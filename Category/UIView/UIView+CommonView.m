//
//  UIView+CommonView.m
//  SanCai
//
//  Created by SongChang on 2018/4/10.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "UIView+CommonView.h"

@implementation UIView(CommonView)


-(void)initTagsViewWithColor:(UIColor *)color
{
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = color;
        [label.layer setBorderColor:color.CGColor];
        [label.layer setBorderWidth:1];
        label.clipsToBounds = YES;
        [label.layer setCornerRadius:4];
    } else if ([self isKindOfClass:[UIButton class]]) {
        
        UIButton *button = (UIButton *)self;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:color forState:0];
        [button.layer setBorderColor:color.CGColor];
        [button.layer setBorderWidth:1];
        button.clipsToBounds = YES;
        [button.layer setCornerRadius:4];

    }
    
}

@end

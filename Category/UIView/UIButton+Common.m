//
//  UIButton+Common.m
//  MerryS
//
//  Created by SongChang on 2018/1/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "UIButton+Common.h"

@implementation UIButton(Common)

+ (UIButton *)createTitleActionBarButton:(NSString *)title titleColor:(UIColor *)color ItemWithTarget:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 30);
    
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    return btn;
}


@end

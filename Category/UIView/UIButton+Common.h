//
//  UIButton+Common.h
//  MerryS
//
//  Created by SongChang on 2018/1/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton(Common)

+ (UIButton *)createTitleActionBarButton:(NSString *)title titleColor:(UIColor *)color ItemWithTarget:(id)target action:(SEL)action;


@end

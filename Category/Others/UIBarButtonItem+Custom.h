//
//  UIBarButtonItem+Custom.h
//  SanCai
//
//  Created by SongChang on 2018/4/16.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem(Custom)


+(UIButton *)customButtomWithImageName:(NSString *)imageName action:(SEL)action vc:(id)vc;

+(UIBarButtonItem *)customBarButtonItemWithImageName:(NSString *)imageName action:(SEL)action vc:(id)vc;

@end

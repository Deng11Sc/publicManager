//
//  CCThridLoginView.h
//  NearbyTask
//
//  Created by SongChang on 2018/5/7.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCLoginRequest.h"

@interface CCThridLoginView : UIView


@property (nonatomic,weak)UIViewController *weakController;

@property (nonatomic,strong)void (^thridLoginSuccessBlock)(NSString *username,NSString *password);

@end

//
//  DY_ThridLoginView.h
//  NearbyTask
//
//  Created by SongChang on 2018/5/7.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CC_LoginRequest.h"

@interface DY_ThridLoginView : UIView


@property (nonatomic,weak)UIViewController *weakController;

@property (nonatomic,strong)void (^thridLoginSuccessBlock)(NSString *username,NSString *password);

@end

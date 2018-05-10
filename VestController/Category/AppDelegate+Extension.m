//
//  AppDelegate+Extension.m
//  RoyaleRoulette
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import "AppDelegate+Extension.h"

#define AppDelegateAlertViewHeight                      NaviBarHeight
#define AppDelegateAlertViewDuration                    0.3
#define AppDelegateNetworkAlerTitleFontSize             15.0f
#define AppDelegateNetworkAlertTag                      999
#define AppDelegateNetworkDisconnectedTitle             @"网络连接已断开"
#define AppDelegateNetworkConnectedTitle                @"已连接互联网"
#define AppDelegateNetwork3GConnectedTitle              @"当前为运营商网络"
#define AppDelegateNetworkWifiConnectedTitle            @"已连接到本地WiFi"

#define ColorSixTeen(s,al)  ([UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:al])

#define kScreenWidth        ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight       ([UIScreen mainScreen].bounds.size.height)

@implementation AppDelegate (Extension)


+(AppDelegate*)sharedAppDelegate{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return appDelegate;
}

+(void)show3GNetworkAlert{
    [self showViewWithTitle:AppDelegateNetwork3GConnectedTitle
                  withImage:[UIImage imageNamed:@"networkConnect"]
        withBackgroundColor:ColorSixTeen(0xfc6363, 1)];
}

+(void)showWifiNetworkAlert{
    [self showViewWithTitle:AppDelegateNetworkWifiConnectedTitle
                  withImage:[UIImage imageNamed:@"networkConnect"]
        withBackgroundColor:ColorSixTeen(0xfb7272, 1)];//SYSTEM_DEFAULT_COLOR
}

+(void)showOtherNetworkAlert{
    [self showViewWithTitle:AppDelegateNetworkConnectedTitle
                  withImage:[UIImage imageNamed:@"networkConnect"]
        withBackgroundColor:ColorSixTeen(0xfb7272, 1)];//SYSTEM_DEFAULT_COLOR;
}

+(void)showNoNetworkAlert{
    [self showViewWithTitle:AppDelegateNetworkDisconnectedTitle
                  withImage:[UIImage imageNamed:@"networkDisconnect"]
        withBackgroundColor:ColorSixTeen(0x999999, 1)];
}

+(UIView*)showViewWithTitle:(NSString*)title withImage:(UIImage*)image withBackgroundColor:(UIColor*)color{
    UIView *view = [[AppDelegate sharedAppDelegate].window viewWithTag:AppDelegateNetworkAlertTag];
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, AppDelegateAlertViewHeight)];
        [view setTag:AppDelegateNetworkAlertTag];
        [[AppDelegate sharedAppDelegate].window addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, StatusBarHeight+(NaviBarABXHeight - 25)*0.5, 25, 25)];
        [view addSubview:imageView];
        [imageView setTag:111];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, imageView.frame.origin.y, kScreenWidth - 60, 25)];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:16]];
        [label setTag:222];
        [view addSubview:label];
    }
    
    [view setBackgroundColor:color];
    
    UIImageView *imageView = [view viewWithTag:111];
    if (imageView) {
        [imageView setImage:image];
    }
    
    UILabel *label = [view viewWithTag:222];
    if (label) {
        [label setText:title];
    }
    
    [self showView];
    
    return view;
}


- (void)networkAlerViewDismiss{
    UIView *view = [[AppDelegate sharedAppDelegate].window viewWithTag:AppDelegateNetworkAlertTag];
    if (view) {
        [UIView animateWithDuration:AppDelegateAlertViewDuration
                         animations:^{
                             view.frame = CGRectMake(0, -AppDelegateAlertViewHeight, MainScreenWidth, AppDelegateAlertViewHeight);
                         }
                         completion:^(BOOL finished) {
                             if (view && view.superview) {
                                 [view removeFromSuperview];
                             }
                         }];
    }
}

+ (void)showView{
    UIView *view = [[AppDelegate sharedAppDelegate].window viewWithTag:AppDelegateNetworkAlertTag];
    if (view) {
        view.frame = CGRectMake(0, - AppDelegateAlertViewHeight, kScreenWidth, AppDelegateAlertViewHeight);
        [UIView animateWithDuration:AppDelegateAlertViewDuration
                         animations:^{
                             view.frame = CGRectMake(0, 0, kScreenWidth, AppDelegateAlertViewHeight);
                         }
                         completion:^(BOOL finished) {
                             [[AppDelegate sharedAppDelegate] performSelector:@selector(networkAlerViewDismiss)
                                                                   withObject:nil
                                                                   afterDelay:1.5];
                         }];
    }
}

@end

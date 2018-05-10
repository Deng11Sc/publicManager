//
//  AppDelegate+Extension.h
//  RoyaleRoulette
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Extension)

+(AppDelegate*)sharedAppDelegate;

/**
 *  显示网络连接的提醒
 */
+(void)showOtherNetworkAlert;

/**
 *  显示3G网络连接的提醒
 */
+(void)show3GNetworkAlert;

/**
 *  显示WiFi网络连接的提醒
 */
+(void)showWifiNetworkAlert;
/**
 *  显示无网络连接的提醒
 */
+(void)showNoNetworkAlert;

@end

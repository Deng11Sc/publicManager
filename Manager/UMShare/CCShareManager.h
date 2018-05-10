//
//  CCShareManager.h
//  SanCai
//
//  Created by SongChang on 2018/5/2.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>
#import "CCThirdModel.h"

typedef NS_ENUM(NSInteger,CCShareType) {
    CCShareTypeNormal=0,
    CCShareTypeCherryGirls,
};

@interface CCShareManager : NSObject


//1,初始化,AppDelegate初始化方法调用
+ (void)confitUShareSettings;
+ (void)configUSharePlatforms:(CCShareType)type;

- (instancetype)initWithCurrentController:(id)currentController;


//2,AppDelegate回调,AppDelegate的方法同名，是"-"方法;仅支持iOS9和以上，iOS9以下不回调.
+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

//2,AppDelegate回调,AppDelegate的方法同名，是"-"方法;全支持
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

//3,调用面板
- (void)shareUIWithTitle:(NSString *)title descr:(NSString *)descr image:(id)image linkUrl:(NSString *)linkUrl;

/*
 直接调用支付链接
 */
//分享到QQ
-(void)shareToQQWithTitle:(NSString *)title descr:(NSString *)descr image:(id)image linkUrl:(NSString *)linkUrl;

//分享到微信
-(void)shareToWechatWithTitle:(NSString *)title descr:(NSString *)descr image:(id)image linkUrl:(NSString *)linkUrl;

//分享到微信朋友圈
-(void)shareToWechatTimeLineWithTitle:(NSString *)title descr:(NSString *)descr image:(id)image linkUrl:(NSString *)linkUrl;


//分享到支付宝
-(void)shareToAlipayWithTitle:(NSString *)title descr:(NSString *)descr image:(id)image linkUrl:(NSString *)linkUrl;

//分享到各平台
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType messageObject:(UMSocialMessageObject *)messageObject;


///第三方登录
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType successful:(void (^)(CCThirdModel *thirdModel))successful;


@end

//
//  CCShareManager.m
//  SanCai
//
//  Created by SongChang on 2018/5/2.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCShareManager.h"
#import <UMShare/UMShare.h>

@interface CCShareManager ()

@property (nonatomic,weak)id currentController;

@end

@implementation CCShareManager

- (instancetype)initWithCurrentController:(id)currentController;
{
    self = [super init];
    if (self) {
        self.currentController = currentController;
    }
    return self;
}

+ (void)confitUShareSettings {
    
}

+ (void)configUSharePlatforms:(CCShareType)type {
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5770e54b67e58e1084001d64"];
    
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106875580" appSecret:@"cVkZtbEUAODzqbWC" redirectURL:@"http://mobile.umeng.com/social"];
    /* 支付宝的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2018050202618481" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];

}


//AppDelegate回调,AppDelegate的方法同名，是"-"方法;仅支持iOS9和以上，iOS9以下不回调.
+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    CGFloat version = [[UIDevice currentDevice].systemVersion floatValue];
    
    if (version >= 9.0f) {
        BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
        if (!result) {
            // 其他如支付等SDK的回调
        }
        return result;
    }
    return NO;
}

//AppDelegate回调,AppDelegate的方法同名，是"-"方法;全支持
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    CGFloat version = [[UIDevice currentDevice].systemVersion floatValue];

    if (version < 9.0f) {
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
        if (!result) {
            // 其他如支付等SDK的回调
        }
        return result;
    }
    return NO;
}

//分享面板
- (void)shareUIWithTitle:(NSString *)title descr:(NSString *)descr image:(id)image linkUrl:(NSString *)linkUrl
{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_AlipaySession)
                                               ]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        switch (platformType) {
            case UMSocialPlatformType_QQ: {
                [self shareToQQWithTitle:title descr:descr image:image linkUrl:linkUrl];

            }
                break;
            case UMSocialPlatformType_WechatSession: {
                [self shareToWechatWithTitle:title descr:descr image:image linkUrl:linkUrl];
            }
                break;
            case UMSocialPlatformType_WechatTimeLine: {
                [self shareToWechatTimeLineWithTitle:title descr:descr image:image linkUrl:linkUrl];

            }
                break;
            case UMSocialPlatformType_AlipaySession: {
                [self shareToAlipayWithTitle:title descr:descr image:image linkUrl:linkUrl];
            }
                break;
            default:
                break;
        }
    }];

}

/*
 @param:image 可为NSData，UIImage或者图片URL
 */
//分享到QQ
-(void)shareToQQWithTitle:(NSString *)title descr:(NSString *)descr image:(id)image linkUrl:(NSString *)linkUrl{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:image];
    shareObject.webpageUrl = linkUrl;
    messageObject.shareObject = shareObject;
    [self shareWebPageToPlatformType:UMSocialPlatformType_QQ messageObject:messageObject];;
}

//分享到微信
-(void)shareToWechatWithTitle:(NSString *)title descr:(NSString *)descr image:(id)image linkUrl:(NSString *)linkUrl{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:image];
    shareObject.webpageUrl = linkUrl;
    messageObject.shareObject = shareObject;
    [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession messageObject:messageObject];;
}


//分享到微信朋友圈
-(void)shareToWechatTimeLineWithTitle:(NSString *)title descr:(NSString *)descr image:(id)image linkUrl:(NSString *)linkUrl{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:image];
    shareObject.webpageUrl = linkUrl;
    messageObject.shareObject = shareObject;
    [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine messageObject:messageObject];;
}


//分享到支付宝
-(void)shareToAlipayWithTitle:(NSString *)title descr:(NSString *)descr image:(id)image linkUrl:(NSString *)linkUrl{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:image];
    shareObject.webpageUrl = linkUrl;
    messageObject.shareObject = shareObject;
    [self shareWebPageToPlatformType:UMSocialPlatformType_AlipaySession messageObject:messageObject];;
}

//分享到各平台
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType messageObject:(UMSocialMessageObject *)messageObject
{
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.currentController completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}



@end

//
//  DYHeader.h
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#ifndef DYHeader_h
#define DYHeader_h

#define CC_Height CGRectGetHeight([[UIScreen mainScreen] bounds])
#define CC_Width CGRectGetWidth([[UIScreen mainScreen] bounds])
#define CC_SCREEN_MIN MIN(CC_Height,CC_Width)
#define CC_SCREEN_MAX MAX(CC_Height,CC_Width)

/** 定义版本判定 */
#define iOS7_Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8_Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9_Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1_Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define iOS10_Later ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
#define iOS11_Later ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0)


/*
 *  适配坐标 ， 以（375， 667）为基准
 */
#define selfWidthRate ([UIScreen mainScreen].bounds.size.width / 375.0)
#define selfHeightRate ([UIScreen mainScreen].bounds.size.height / 667.0)
#define DYRate(rect) CGRectMake(rect.origin.x *selfWidthRate, rect.origin.y *selfHeightRate, rect.size.width *selfWidthRate, rect.size.height *selfHeightRate)
#define DYRate_X(x) selfWidthRate *x
#define DYRate_Y(y) selfHeightRate *y
#define DYRate_Width(w) selfWidthRate *w
#define DYRate_height(h) selfHeightRate *h


///颜色，不透明
#define kUIColorFromRGB(rgbValue)                                                                                                                                                  \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

///颜色，加透明度
#define kUIColorFromRGB_Alpa(rgbValue, alpa)                                                                                                                                       \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:alpa]


//当前版本号
#define kCurrentSystemVersion [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]

/** 用户设备的id */
#define nn_udid [[[[UIDevice currentDevice] identifierForVendor] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""]


#define CC_CurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]



#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) ;
#endif

///
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#define AVOSCloudId @"5ac868f54773f7005d7590e3"
#define SELF_USER_ID [NSString isEmptyString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo-uniqueId"]]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo-uniqueId"]
#define SELF_USER_NAME [NSString isEmptyString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo-nickName"]]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo-nickName"]
#define SELF_USER_IMAGEURL [NSString isEmptyString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo-imageUrl"]]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo-imageUrl"]

#define CC_EMPTY(str1) ([NSString isEmptyString:str1]?@"":str1)


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DYUIHeader.h"
#import "UIView+Configure.h"
#import "MBProgressHUD.h"
#import "UIView+Support.h"
#import "NSObject+Warning.h"
#import "UIResponder+Router.h"
#import "NSString+Common.h"

#import "CCUploadManager.h"

//需要pod依赖的全局变量
#import <MJRefresh/MJRefresh.h>
#import <AVOSCloud/AVOSCloud.h>
#import <Masonry/Masonry.h>
#import "UIImageView+WebCache.h"


//需要pod依赖才不会报错的依赖
#import "CC_LeanCloudNet.h"
#import "CCLeanCloudUrl.h"
#import "NSObject+FMDB.h"


#define DYLocalizedString(key, comment) NSLocalizedStringFromTable(key,@"InfoPlist", comment)

/*
 pod 'IQKeyboardManager'
 pod 'SDWebImage', '~>3.8'
 pod 'AFNetworking', '~> 3.0'
 pod 'Masonry'
 pod 'FMDB'
 pod 'MJExtension'
 pod 'MJRefresh'
 pod 'MBProgressHUD', '~> 1.0.0'
 pod 'AVOSCloud'               # 数据存储、短信、云引擎调用等基础服务模块
 pod 'WebViewJavascriptBridge', git: 'https://github.com/HYC192/WebViewJavascriptBridge.git'
 pod 'TOCropViewController', git: 'https://github.com/liu3619376/TOCropViewController.git'
 pod 'JPush'
 pod "Qiniu", "~> 7.1"
 */

#endif /* DYHeader_h */

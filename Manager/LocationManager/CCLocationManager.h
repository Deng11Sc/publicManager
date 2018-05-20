//
//  CCLocationManager.h
//  Fight10
//
//  Created by SongChang on 2018/5/14.
//  Copyright © 2018年 SogYi. All rights reserved.
//

/*
 1，定位服务，需要开启权限，增加NSLocationWhenInUseUsageDescription和NSLocationAlwaysAndWhenInUseUsageDescription，如果要永久使用，需要增加NSLocationAlwaysUsageDescription
 2，允许background Modes，一种是在Xcode -> Targets -> Capabilities打开Background Modes并勾选Location updates选项；一种是设置info.plist:
 
 <key>UIBackgroundModes</key>
 <array>
 <string>location</string>
 </array>
 
 
 */

#import <Foundation/Foundation.h>
//定位功能
#import <BMKLocationKit/BMKLocationComponent.h>
//地图功能 
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface CCLocationManager : NSObject

//一次定位定位成功返回
@property (nonatomic,strong)void (^locationSuccessBlock)(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error);

//调用一次定位
- (void)onceLocationIsReGeocode:(BOOL)isReGeocode;

//连续性定位
-(void)continuousLocationIsReGeocode:(BOOL)isReGeocode;

//关闭连续性定位
-(void)stopLocation;


/******************************************************/
//POI检索
- (void)poiSearchPage:(int)page;

@end

//
//  CCLocationManager.m
//  Fight10
//
//  Created by SongChang on 2018/5/14.
//  Copyright © 2018年 SogYi. All rights reserved.
//

#import "CCLocationManager.h"
#import <BMKLocationKit/BMKLocationAuth.h>

@interface CCLocationManager ()<BMKLocationAuthDelegate,BMKLocationManagerDelegate,BMKPoiSearchDelegate>

@property (nonatomic,strong)BMKLocationManager *locationManager;

@property (nonatomic,strong)BMKPoiSearch *poisearch;

@end

@implementation CCLocationManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setAppKey:@"ptYGnmZUurffvYHI3bGwuWWWS4XsI7dk"];
        [self initManager];
    }
    return self;
}

//设置AK
- (void)setAppKey:(NSString *)appKey {
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:appKey authDelegate:self];
}

- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError {
    NSLog(@"123");
}

//初始化定位manager
- (void)initManager {
    
    //初始化实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    _locationManager.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
}

//调用一次定位
- (void)onceLocationIsReGeocode:(BOOL)isReGeocode {
    
    [self.locationManager requestLocationWithReGeocode:isReGeocode withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (self.locationSuccessBlock) {
            self.locationSuccessBlock(location, state, error);
        }
    }];
}


//连续性定位
-(void)continuousLocationIsReGeocode:(BOOL)isReGeocode {
    [self.locationManager setLocatingWithReGeocode:isReGeocode];
    [self.locationManager startUpdatingLocation];
}

-(void)stopLocation {
    [self.locationManager stopUpdatingHeading];
}

//连续定位返回的delegate
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error

{
    if (self.locationSuccessBlock) {
        self.locationSuccessBlock(location, BMKLocationNetworkStateUnknown, error);
    }
    
    if (error)
    {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    } if (location) {//得到定位信息，添加annotation
        if (location.location) {
            NSLog(@"LOC = %@",location.location);
        }
        if (location.rgcData) {
            NSLog(@"rgc = %@",[location.rgcData description]);
        }
    }
}


/*
 如果需要连续定位，操作：
 1，更改info.plist
 将info.plist的字段改成NSLocationWhenInUseUsageDescription，NSLocationAlwaysUsageDescription，NSLocationAlwaysAndWhenInUseUsageDescription三项。
 具体请参考《开发指南 - 手动部署》章节中的介绍。
 2，配置后台定位
 在左侧目录中选中工程名，开启 TARGETS->Capabilities->Background Modes
 在Background Modes中勾选 Location updates，如下图所示：
 */




/******************************************************/
//POI检索
- (void)poiSearchPage:(int)page {
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = page;
    citySearchOption.pageCapacity = 20;
    citySearchOption.city= @"北京";
    citySearchOption.keyword = @"小吃";
    //发起城市内POI检索
    BOOL flag = [self.poisearch poiSearchInCity:citySearchOption];
    if(flag) {
        NSLog(@"城市内检索发送成功");
    }
    else {
        NSLog(@"城市内检索发送失败");
    }
}


- (BMKPoiSearch *)poisearch {
    if (!_poisearch) {
        _poisearch =[[BMKPoiSearch alloc]init];
        _poisearch.delegate = self;
    }
    return _poisearch;
}


//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}



@end

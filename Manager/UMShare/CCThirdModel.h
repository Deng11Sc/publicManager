//
//  CCThirdModel.h
//  NearbyTask
//
//  Created by SongChang on 2018/5/7.
//  Copyright © 2018年 SongChang. All rights reserved.
//


@interface CCThirdModel : NSObject

// 第三方登录数据(为空表示平台未提供)
// 授权数据
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSString *openid;
@property (nonatomic,strong)NSString *accessToken;
@property (nonatomic,strong)NSString *refreshToken;
@property (nonatomic,strong)NSDate *expiration;

// 用户数据
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *iconurl;
@property (nonatomic,strong)NSString *unionGender;

// 第三方平台SDK原始数据
@property (nonatomic,strong)NSString *originalResponse;

@end

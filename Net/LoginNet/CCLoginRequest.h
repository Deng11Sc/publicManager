//
//  CCLoginRequest.h
//  NearbyTask
//
//  Created by SongChang on 2018/5/7.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CC_LeanCloudNet.h"
#import "CCUserInfoModel.h"

@interface CCLoginRequest : CC_LeanCloudNet

//注册
- (id)initRegistWithUserName:(NSString *)userName password:(NSString *)password UserInfoModel:(CCUserInfoModel *)userInfo ;

//登录
- (id)initLoginWithUserName:(NSString *)userName password:(NSString *)password;


-(void)registRequest;

-(void)loginRequest ;

@end

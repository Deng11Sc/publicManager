//
//  DY_LoginInfoManager.h
//  MerryS
//
//  Created by SongChang on 2018/1/23.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DY_UserInfoModel.h"



@interface DY_LoginInfoManager : NSObject

+(DY_LoginInfoManager *)manager;

//保存用户数据
+ (void)saveUserInfo:(DY_UserInfoModel *)model;

//获取用户数据
+(DY_UserInfoModel *)getUserInfo;

//判断是否已登陆
@property (nonatomic,assign)BOOL isLogin;


//跳转到登录页面
- (void)prensentLoginController ;
//登出
-(void)logout;

@end

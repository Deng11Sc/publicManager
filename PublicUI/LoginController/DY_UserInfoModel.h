//
//  DY_UserInfoModel.h
//  MerryS
//
//  Created by SongChang on 2018/1/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户权限模块，如果不涉及权限，引用直接删除即可
#import "DYUserConfig.h"

@interface DY_UserInfoModel : NSObject

//这个是账号
@property (nonatomic,strong)NSString *userName;

//性别，0为男，1为女
@property (nonatomic,strong)NSString *userSex;

//头像
@property (nonatomic,strong)NSString *imageUrl;

//昵称，可修改
@property (nonatomic,strong)NSString *nickName;

@property (nonatomic,strong)NSString *uniqueId;

@property (nonatomic,strong)NSString *sessionToken;

@property (nonatomic,strong)NSString *email;

//用户配置信息
@property (nonatomic,strong)DYUserConfig *config;

@end

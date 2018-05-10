//
//  DY_UserRequest.h
//  NearbyTask
//
//  Created by SongChang on 2018/4/23.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CC_LeanCloudNet.h"


/// 账号系统模块，以下模块均默认含有账号密码头像模块
typedef NS_ENUM(uint,DYUserMode)
{
    DYUserModeNormal   = 1,            //只包含账号密码头像模块
    DYUserModeInfo     = 1 << 1,       //包含具体信息模块
    DYUserModeWallet   = 1 << 2,       //包含钱包模块
    DYUserModeTask     = 1 << 3,       //包含任务模块
};


@interface DY_UserRequest : CC_LeanCloudNet

@property (nonatomic,assign)DYUserMode mode;


//-(void)getUserInfo;
//
//-(void)test;

@end

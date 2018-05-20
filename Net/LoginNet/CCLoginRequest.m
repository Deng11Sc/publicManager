//
//  CCLoginRequest.m
//  NearbyTask
//
//  Created by SongChang on 2018/5/7.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCLoginRequest.h"
#import "CC_LeanCloudNet+Method.h"
#import "CCLoginInfoManager.h"

#import "DYUserConfig.h"

@interface CCLoginRequest ()

@property (nonatomic,strong)AVUser *user;

@end

@implementation CCLoginRequest



//注册
- (id)initRegistWithUserName:(NSString *)userName password:(NSString *)password UserInfoModel:(CCUserInfoModel *)userInfo {
    self = [super init];
    if (self) {
        AVUser *user = [AVUser user];
        user.username = userName;
        user.password = password;
        userInfo.nickName = userName;
        //
        
        unsigned int count = 0;
        Ivar *ivarList = class_copyIvarList([userInfo class], &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivarList[i];
            
            NSString *key = [self getKeyWithIvar:ivar];
            id value = [userInfo valueForKey:key];
            
            if ([key isEqualToString:@"objectId"] ||
                [key isEqualToString:@"updatedAt"] ||
                [key isEqualToString:@"createdAt"] ||
                [key isEqualToString:self.uniqueId] ||
                [key isEqualToString:@"taskType"]) {
                continue;
            }
            
            if (![NSString isEmptyString:self.userId]) {
                [user setObject:self.userId forKey:@"userId"];
            }
            if (value) {
                [user setObject:value forKey:key];
            }
        }
        free(ivarList);
        _user = user;
    }
    return self;
}

-(void)registRequest {
    [_user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [AVUser logOut];
        
        if (succeeded) {
            // 注册成功
            CCUserInfoModel *model = [[CCUserInfoModel alloc] init];
            model.userName = _user.username;
            model.uniqueId = _user.objectId;
            model.sessionToken = _user.sessionToken;
            model.imageUrl = [_user objectForKey:@"localData"][@"imageUrl"];
            model.userSex = [_user objectForKey:@"localData"][@"userSex"];
            model.nickName = [_user objectForKey:@"localData"][@"nickName"];
            
            if (self.successful) {
                self.successful(nil, 200, nil);
            }
            
        } else {
            
            if (self.failure) {
                
                NSString *code = error.userInfo[@"com.leancloud.restapi.response.error"][@"code"];
                self.failure(@"注册失败", [code integerValue]);
            }            
        }
    }];

}

- (void)saveRequest {
    NSAssert(0, @"登录模块中不能使用saveRequest");
}

//登录
- (id)initLoginWithUserName:(NSString *)userName password:(NSString *)password
{
    self = [super init];
    
    AVUser *user = [AVUser user];
    user.username = userName;
    user.password = password;
    _user = user;
    
    return self;
}

- (void)loginRequest {
    [AVUser logInWithUsernameInBackground:_user.username password:_user.password block:^(AVUser *user, NSError *error) {
        
        if (user != nil) {
            NSLog(@"登录用户");
            
            CCUserInfoModel *model = [[CCUserInfoModel alloc] init];
            model.userName = user.username;
            model.uniqueId = user.objectId;
            model.sessionToken = user.sessionToken;
            model.imageUrl = [user objectForKey:@"localData"][@"imageUrl"];
            model.userSex = [user objectForKey:@"localData"][@"userSex"];
            model.nickName = [user objectForKey:@"localData"][@"nickName"];
            [CCLoginInfoManager saveUserInfo:model];
            
            [DYUserConfig saveConfigWithEndBlock:^(DYUserConfig *config) {
                if (self.successful) {
                    self.successful([NSMutableArray arrayWithArray:@[model]], 200, nil);
                }
            }];
            
            ///登录成功发送的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
        } else {
            
            if (self.failure) {
                self.failure(@"登录失败", [error.userInfo[@"code"] integerValue]);
            }
            
            NSLog(@"未注册用户");
            switch ([error.userInfo[@"code"] integerValue]) {
                case 211: ///该账号未注册
                {
                    [NSObject showMessage:DYLocalizedString(@"Account does not exist", @"账号不存在")];
                }
                    break;
                case 210:
                {
                    ///密码错误
                    [NSObject showMessage:DYLocalizedString(@"Wrong password", @"密码错误")];
                }
                    break;
                default:
                {
                    [NSObject showMessage:DYLocalizedString(@"Login failed", @"登陆失败")];
                }
                    break;
            }
        }
    }];
}


@end

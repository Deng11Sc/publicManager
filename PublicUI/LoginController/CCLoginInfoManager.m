//
//  CCLoginInfoManager.m
//  MerryS
//
//  Created by SongChang on 2018/1/23.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCLoginInfoManager.h"
#import <objc/runtime.h>

@implementation CCLoginInfoManager


+ (CCLoginInfoManager *)manager
{
    static CCLoginInfoManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[CCLoginInfoManager alloc] init];
    });
    return _manager;
}

+ (void)saveUserInfo:(CCUserInfoModel *)model
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([model class], &propertyCount);
    
    for (int i = 0; i < propertyCount; i ++) {
        
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        NSString *key = [NSString stringWithFormat:@"%s",propertyName];
        if (![key isEqualToString:@"config"]) {
            [ud setObject:[model valueForKey:key] forKey:[NSString stringWithFormat:@"userinfo-%s",propertyName]];
        }
    }
    [ud synchronize];
    
    ///释放
    free(propertys);
    
}

///清除用户信息
+(void)clearUserInfo {
    CCUserInfoModel *model = [[CCUserInfoModel alloc] init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([model class], &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);

        NSString *key = [NSString stringWithFormat:@"userinfo-%s",propertyName];
        if ([ud objectForKey:key]) {
            [ud setObject:nil forKey:key];
        }
        
    }
    
    ///释放
    free(propertys);
}


+(CCUserInfoModel *)getUserInfo
{
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {

        CCUserInfoModel *model = [[CCUserInfoModel alloc] init];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        unsigned int propertyCount = 0;
        objc_property_t *propertys = class_copyPropertyList([model class], &propertyCount);
        
        //把属性放到数组中
        for (int i = 0; i < propertyCount; i ++) {
            ///取出第一个属性
            objc_property_t property = propertys[i];
            
            const char * propertyName = property_getName(property);
            
            NSString *key = [NSString stringWithFormat:@"userinfo-%s",propertyName];
            
            if ([key isEqualToString:@"userinfo-config"]) {
                
                [model setValue:[DYUserConfig getConfig] forKey:@"config"];
                
                continue;
            }

            if ([ud objectForKey:key]) {
                [model setValue:[ud objectForKey:key] forKey:[NSString stringWithUTF8String:propertyName]];
            }
            
        }
        
        ///释放
        free(propertys);
        
        return model;

    } else {
        return nil;
    }
}


-(BOOL)isLogin {

    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        // 跳转到首页
        return YES;
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
        return NO;
    }
}


- (void)prensentLoginController {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"presentLoginViewController" object:nil];
}

-(void)logout {
    [AVUser logOut];
    [CCLoginInfoManager clearUserInfo];
    [DYUserConfig clearConfig];
}

@end

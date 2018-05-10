//
//  DYUserConfig.m
//  InitiallyProject
//
//  Created by SongChang on 2018/5/9.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#define User_config @"user_config"

#import "DYUserConfig.h"

#import "DY_LoginInfoManager.h"

@implementation DYUserConfig

- (void)setAppManager:(NSNumber *)appManager {
    _appManager = appManager;
    if ([appManager intValue]== 1) {
        self.liveIsCert = @1;
    }
}


//初始化和读取配置信息
+ (void)saveConfigWithEndBlock:(void (^)(DYUserConfig *config))endBlock {
    
    if ([NSString isEmptyString:SELF_USER_ID]) {
        return;
    }
    
    CC_LeanCloudNet *request = [[CC_LeanCloudNet alloc] init];
    request.className = User_config;
    [request requestWithFatherClass:[DYUserConfig class]];
    [request whereKey:@"userId" equal:SELF_USER_ID];
    request.successful = ^(NSMutableArray *array, NSInteger code, id json) {
        
        DYUserConfig *userConfig = array.firstObject;
        if (array.count == 0 || userConfig.uniqueId == nil) {
            
            DYUserConfig *configModel = [[DYUserConfig alloc] init];
            configModel.userId = SELF_USER_ID;
            
            CC_LeanCloudNet *saveRequest = [[CC_LeanCloudNet alloc] init];
            [saveRequest fatherModelWithClassName:@"_User" arr:@[[DY_LoginInfoManager getUserInfo]]];
            [saveRequest pointerModelsWithClassName:User_config model:configModel subName:@"config"];
            saveRequest.successful = ^(NSMutableArray *array, NSInteger code, id json) {
                NSLog(@"successfully");
                [self saveConfigWithEndBlock:nil];
            };
            saveRequest.failure = ^(NSString *error, NSInteger code) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self saveConfigWithEndBlock:nil];
                });
            };
            [saveRequest saveRequest];            
        } else {
            
            DYUserConfig *model = array.firstObject;
#warning 管理者权限时，所有权限均解决，需要在这里转1，或者后台开启所有权限
            if ([model.appManager intValue] == 1) {
                model.liveIsCert = @1;
            }
            
            [DY_LoginInfoManager getUserInfo].config = model;
            
            if (endBlock) {
                endBlock(model);
            }
            
            //保存到NSUserDefaults
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            
            unsigned int propertyCount = 0;
            objc_property_t *propertys = class_copyPropertyList([model class], &propertyCount);
            
            for (int i = 0; i < propertyCount; i ++) {
                objc_property_t property = propertys[i];
                const char * propertyName = property_getName(property);
                [ud setObject:[model valueForKey:[NSString stringWithFormat:@"%s",propertyName]] forKey:[NSString stringWithFormat:@"config-%s",propertyName]];
            }
            [ud synchronize];
            
            ///释放
            free(propertys);
        }
    };
    request.failure = ^(NSString *error, NSInteger code) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self saveConfigWithEndBlock:nil];
        });
    };
    [request startRequest];
    
}

+ (DYUserConfig *)getConfig {
    DYUserConfig *model = [[DYUserConfig alloc] init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([model class], &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        const char * propertyName = property_getName(property);
        NSString *key = [NSString stringWithFormat:@"config-%s",propertyName];
        if ([ud objectForKey:key]) {
            [model setValue:[ud objectForKey:key] forKey:[NSString stringWithUTF8String:propertyName]];
        }
    }
    
    ///释放
    free(propertys);
    return model;
}


///清除用户配置
+(void)clearConfig {
    DYUserConfig *model = [[DYUserConfig alloc] init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([model class], &propertyCount);

    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        NSString *key = [NSString stringWithFormat:@"config-%s",propertyName];
        if ([ud objectForKey:key]) {
            [ud setObject:nil forKey:key];
        }
        
    }
    
    ///释放
    free(propertys);
}



@end

//
//  DYUserConfig.h
//  InitiallyProject
//
//  Created by SongChang on 2018/5/9.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYUserConfig : NSObject

@property (nonatomic,strong)NSString *uniqueId;

@property (nonatomic,strong)NSString *userId;


//0为没有直播权限，1为有直播权限
@property (nonatomic,strong)NSNumber *liveIsCert;





/*
 注意：添加属性需要写在上面，不宜写到AppManager
 */


//1为是管理者，管理者拥有所有权限
@property (nonatomic,strong)NSNumber *appManager;


//保存配置信息
+ (void)saveConfigWithEndBlock:(void (^)(DYUserConfig *config))endBlock;

///获取配置信息
+ (DYUserConfig *)getConfig;


///清除用户配置
+(void)clearConfig;

@end

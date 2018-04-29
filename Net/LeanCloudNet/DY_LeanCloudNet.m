//
//  DY_LeanCloudNet.m
//  NearbyTask
//
//  Created by SongChang on 2018/4/4.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_LeanCloudNet.h"
#import <objc/runtime.h>


@implementation DY_LeanCloudNet

+(void)_initOSCloudServers
{
    [AVOSCloud setApplicationId:@"fXQM2gI5KH56ulO4lDguPKeR-gzGzoHsz" clientKey:@"mC7ab5s3LjlRTYjo0efQCVh7"];
    [AVOSCloud setAllLogsEnabled:NO];
}


/*
 method:获取列表数据
 className:表名
 skip:第几页
 orderby:排序，传nil为默认orderByDescending的创建时间排序，其他请自行参照leanCloud官网进行修改
 limit:获取个数，传0则默认为20个
 */
+(void)getListWithClassName:(NSString *)className
                       skip:(NSInteger)skip
                    orderby:(NSString *)orderby
                      limit:(NSInteger)limit
                    success:(successful)successful
                    failure:(failure)faliure;
{
    AVQuery *query = (AVQuery *)[AVQuery queryWithClassName:className];
    if (orderby) {
        [query orderByDescending:orderby];
    } else {
        [query orderByDescending:@"createdAt"];
    }
    
    if (limit > 0) {
        query.limit = limit;
    } else {
        query.limit = 20;
    }
    query.skip = query.limit*(skip==0?1:skip)-query.limit;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            for (AVObject *avObj in objects) {
                NSMutableDictionary *dic = [avObj objectForKey:@"localData"];
                dic[@"objId"] = avObj[@"objectId"];
                [dataArray addObject:dic];
            }
            if (successful) {
                successful(dataArray,nil);
            }
            
        } else {
            if (faliure) {
                faliure(DYLeanCloudErrorDefault);
            }
        }
    }];

}

/*
 method:查询自己的数据。条件查询
 步骤:
 1,创建AVQuey --- AVQuery *query = [AVQuery queryWithClassName:表明，相当于url]
 2,设置查询条件 --- [query whereKey:@"userId" equalTo:用户userId具体值]
 */
+(void)findObjectWithQuery:(AVQuery *)query
                      skip:(NSInteger)skip
                     limit:(NSInteger)limit
                   success:(successful)successful
                   failure:(failure)faliure
{
    [query orderByDescending:@"createdAt"];
    if (limit > 0) {
        query.limit = limit;
    } else {
        query.limit = 20;
    }
    query.skip = query.limit*(skip==0?1:skip)-query.limit;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            for (AVObject *avObj in objects) {
                NSMutableDictionary *dic = [avObj objectForKey:@"localData"];
                dic[@"objId"] = avObj[@"objectId"];
                [dataArray addObject:dic];
                
                NSDictionary *relationDic = [avObj objectForKey:@"relationData"];
                if (relationDic.allKeys.count > 0) {
                    for (NSString *key in relationDic.allKeys) {
                        dic[key] = relationDic[key];
                    }
                }
            }
            if (successful) {
                successful(dataArray,nil);
            }
        } else {
            if (faliure) {
                faliure(DYLeanCloudErrorDefault);
            }
        }
    }];
}


/*
 method:修改数据
 model:需要保存的数据，model形式
 objectId:数据唯一id，注意，如果传了objectId并且数据库内有对应的objectId，则只会修改对应数据；如果不传，则生成一条新的数据
 className:需要保存在哪个表中，和常规情况下的url差不多的概念
 relationId:关联Id,一般我默认为关联用户的userId，用处自行探索
 */
+(void)saveObject:(id)model
         objectId:(NSString *)objectId
        className:(NSString *)className
        numberArr:(NSArray *)arr
       relationId:(NSString *)relationId
          success:(successful)successful
          failure:(failure)faliure

{
    AVObject *todoFolder;
    if (!objectId) {
        todoFolder = [[AVObject alloc] initWithClassName:className];// 构建对象

    } else {
        todoFolder = [AVObject objectWithClassName:className objectId:objectId];// 构建对象
    }
    
    if (relationId) {
        [todoFolder setObject:relationId forKey:@"relationId"];// 设置关联id
    }
    [todoFolder setObject:@1 forKey:@"priority"];// 设置优先级
    
    //
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([model class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        
        // 获取key
        NSString *key = [self getKeyWithIvar:ivar];
        
        id value = [model valueForKey:key];
        
        if ([key isEqualToString:@"objectId"] || [key isEqualToString:@"updatedAt"] || [key isEqualToString:@"createdAt"] ||[key isEqualToString:@"objId"] || [key isEqualToString:@"taskType"]) {
            continue;
        }
        BOOL isbool = [arr containsObject:key];
        if (isbool) {
            [todoFolder setObject:@([value integerValue]) forKey:key];
        } else {
            [todoFolder setObject:value forKey:key];
        }
    }
    free(ivarList);

    [todoFolder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            // 存储成功
            NSLog(@"%@",todoFolder.objectId);// 保存成功之后，objectId 会自动从云端加载到本地
            
            if (successful) {
                successful(nil,todoFolder);
            }
            
        } else {
            // 失败的话，请检查网络环境以及 SDK 配置是否正确
            if (faliure) {
                faliure(DYLeanCloudErrorDefault);
            }
        }
    }];

}

//获取model的其中一个key
+(NSString *)getKeyWithIvar:(Ivar)ivar {
    
    NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
    
    // 获取key
    NSString *key = nil;
    if ([[ivarName substringToIndex:1] isEqualToString:@"_"]) {
        key = [ivarName substringFromIndex:1];
    } else {
        key = ivarName;
    }
    return key;
}




@end

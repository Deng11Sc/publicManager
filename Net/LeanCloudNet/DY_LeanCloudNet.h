//
//  DY_LeanCloudNet.h
//  NearbyTask
//
//  Created by SongChang on 2018/4/4.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "DY_LeanCloudUrl.h"
#import "CCModel.h"

typedef NS_ENUM(NSInteger,DYLeanCloudError)
{
    DYLeanCloudErrorDefault = 0,
    DYLeanCloudErrorNotAllKey, //必要参数不足
};

typedef void (^successful)(NSMutableArray *array,AVObject *object);
typedef void (^failure)(DYLeanCloudError error);

@interface DY_LeanCloudNet : NSObject


///初始化leanCloud
+(void)_initOSCloudServers;


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
                   failure:(failure)faliure;


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
          failure:(failure)faliure;


/*
 method:批量上传数据，如果objectId有，则修改；如果没有，则生成新的数据
 */

@end

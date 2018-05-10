//
//  CC_LeanCloudNet.h
//  LiCai
//
//  Created by SongChang on 2018/4/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

#import "CCQuery.h"

///创建网络表
#import "GenerateTableManager.h"

/*
 code == 0      : 请求成功
 code == 404    : 网络错误
 code == 201    : 请求失败，失败原因看error
 code == 500    : 代码错误，具体自行检查
 
 json - 返回原始数据作为参考，建议不使用，如果未
 error - 请求失败时返回的错误提示
 */


typedef void (^dysuccessful) (NSMutableArray *array,NSInteger code,id json);
typedef void (^dyfailure) (NSString *error,NSInteger code);

@interface CC_LeanCloudNet : NSObject

///初始化leanCloud
+(void)_initOSCloudServers;
+(void)_initOSCloudServersAppId:(NSString *)appId clientKey:(NSString *)clientKey;

/*
 0,设置URL
 URL为leanCloud的表名，请单独设立一个头文件定义宏，并引用
 */
@property (nonatomic,strong)NSString *className;

///1,设置请求条件,将增加常用的方法，参考第101条
@property (nonatomic,strong)CCQuery *query;


-(void)requestWithFatherClass:(Class)fatherClass;

-(void)requestWithSubClassArr:(id)classArr urlArr:(id)urlArr;

///开始发送请求
-(void)startRequest;







/*
 *
 *设置需要保存的model
 */
- (void)fatherModelWithClassName:(NSString *)className arr:(id)arr;


//可通过以下方法创建models，多次调用即可,建立Pointers关系,注意，多个关系的model传的subName不能一样
-(void)pointerModelsWithClassName:(NSString *)className model:(id)model subName:(NSString *)subName;

/*
 可通过以下方法创建models,建立AVRelation关系,subName为关系的字段名
 注意，调用此方法时fatherModel的唯一id必须有
 */
-(void)relationModelsWithClassName:(NSString *)className arr:(NSArray *)arr subName:(NSString *)subName;

///3,成功回调
@property (nonatomic,strong)dysuccessful successful;
///4,失败回调
@property (nonatomic,strong)dyfailure failure;
/*
 调用以下方法前请实现3，4的回调方法
 以下方法为调用请求，不同请求，调用的方法不相同，只需要调用一个。
 */
///5,保存数据
-(void)saveRequest;








/*
 *101,更多的条件设置请参考官方文档，或者使用self.query whereKey进行查询
 */

/*
 指定数据唯一id的名字.
 不能为objectId，这是AVObject的保留字段,不指定则默认为"uniqueId"
 */
@property (nonatomic,strong)NSString *uniqueId;

//第几页
@property (nonatomic,assign)NSInteger page;
//一页的条数
@property (nonatomic,assign)NSInteger pageNum;
///不做默认处理，请在创建继承于本类的Manager方法时，自行在不同的请求内初始化，比如在UserInfoManager类中基本都要使用SELF_USER_ID
@property (nonatomic,strong)NSString *userId;

///设置独立的对比值
- (void)whereKey:(NSString *)key equal:(id)value;





#pragma mark ------------  cql语句 -------------
-(void)startWithCql:(NSString *)cql;





@end

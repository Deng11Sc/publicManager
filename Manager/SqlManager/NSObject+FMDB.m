//
//  NSObject+FMDB.m
//  NNLetter
//
//  Created by SongChang on 2017/8/11.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NSObject+FMDB.h"
#import "NNSqliteManager.h"

@implementation NSObject(FMDB)


#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    Class c = NSClassFromString(NSStringFromClass([self class]));
#if __has_feature(objc_arc)
    id obj = [[c alloc] init];
#else
    id obj = [[[c alloc] init] autorelease];
#endif
    
    return [[NNSqliteManager share] initWithDictionary:dict model:obj];
}

+ (void)initSqlite:(NSString *)sqlName {
    //创建表
    sqlName = [self getTableName:sqlName];
    
    [self setTableName:sqlName];
    //检查表的字段并把没有的字段加上去
    
#if DEBUG
    [[NNSqliteManager share] initNewSqlName:sqlName];
#else
    
    [[NNSqliteManager share] initNewSqlName:sqlName];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *version = [ud objectForKey:@"DB_Version"];
    if (![version isEqualToString:NNCurrentVersion]) {
        
        [[NNSqliteManager share] initNewSqlName:sqlName];
        
        [ud setObject:NNCurrentVersion forKey:@"DB_Version"];
        [ud synchronize];
    }
#endif
}

-(NSString *)createDatabase_sqlite_path
{
    return [[NNSqliteManager share] manager_createDatabase_sqlite_path];
}

///获取表名
+(NSString *)getTableName:(NSString *)sqlName
{
    if (sqlName.length > 0) {
        return sqlName;
    }
    return NSStringFromClass(object_getClass(self));
}

+(void)setTableName:(NSString *)sql_tableName
{
    [[NNSqliteManager share] setTableName:[self getTableName:sql_tableName] c:self];
}

///检查表是否存在
+(BOOL)checkSqlName:(NSString *)sqlName {
    return [[NNSqliteManager share] manager_checkName:[self getTableName:sqlName]];
}

/**
 sql:条件查询数据库

 @param sql 例如：WHERE userId = '2896'
 @param sqlName nil则默认model的名字，或者传对应的名字
 @param block 返回结果
 */
+(NSMutableArray *)select_by_sql:(NSString *)sql sqlName:(NSString *)sqlName block:(NNSelectResultsBlock)block
{
    
    return [[NNSqliteManager share] manager_select_by_sql:sql sqlName:[self getTableName:sqlName] c:self block:block];
}

///传一条完整的sql条件的语句查询
+(NSMutableArray *)perfect_select_by_sql:(NSString *)sql sqlName:(NSString *)sqlName block:(NNSelectResultsBlock)block
{
    //这里的sqlName无效，需要在外边写好完整的sql句子
    return [[NNSqliteManager share] manager_select_by_sql:sql sqlName:[self getTableName:sqlName] c:self block:block];
}

///删除一条数据
+(void)delete_one_sql:(NSString *)sql sqlName:(NSString *)sqlName
{
    [[NNSqliteManager share] manager_delete_one_sql:sql sqlName:[self getTableName:sqlName]];
}

///删除表
+(void)delete_table_sqlName:(NSString *)sqlName
{
    [[NNSqliteManager share] manager_delete_table_sqlName:[self getTableName:sqlName]];
}

///删除表内的所有数据
+(void)delete_all_sqlName:(NSString *)sqlName
{
    [[NNSqliteManager share] manager_delete_all_sqlName:[self getTableName:sqlName]];
}

//查询表的数据总个数
+(NSInteger)select_count_sqlName:(NSString *)sqlName
{
    return [[NNSqliteManager share] manager_select_count_sqlName:[self getTableName:sqlName]];
}

///修改键值
+(void)replace_condition:(NSString *)condition sqlName:(NSString *)sqlName
{
    [[NNSqliteManager share] manager_replace_condition:condition sqlName:[self getTableName:sqlName]];
}

///添加到数据库
+ (void)insert_by_sql:(NSString *)sql sqlName:(NSString *)sqlName dataArray:(id)dataArray
{
    sql = nil;
    if (dataArray == nil) return;
    [[NNSqliteManager share] manager_insert_by_sql:sql sqlName:[self getTableName:sqlName] dataArray:dataArray];
}

///升级数据
+ (void)update_by_sql:(NSString *)sql sqlName:(NSString *)sqlName dataArray:(id)dataArray
{
    if (dataArray == nil) return;
    [[NNSqliteManager share] manager_update_by_sql:sql sqlName:[self getTableName:sqlName] dataArray:dataArray];
}

+ (void)update_by_keys:(NSArray *)keys sqlName:(NSString *)sqlName dataArray:(id)dataArray
{
    if (dataArray == nil) return;
    [[NNSqliteManager share] manager_update_by_keys:keys sqlName:[self getTableName:sqlName] dataArray:dataArray];
}


///有则更新，无则添加
+ (void)update_or_insert_by_sql:(NSString *)sql sqlName:(NSString *)sqlName dataArray:(id)dataArray
{
    if (dataArray == nil) return;
    
    [[NNSqliteManager share] manager_update_or_insert_by_sql:sql sqlName:[self getTableName:sqlName] dataArray:dataArray];
}

///模糊搜索
+ (void)search_byStr:(NSString *)str Key:(NSArray *)keyArr sqlName:(NSString *)sqlName block:(NNSelectResultsBlock)block
{
    [[NNSqliteManager share] manager_search_byStr:str Key:keyArr sqlName:[self getTableName:sqlName] block:block];
}




@end

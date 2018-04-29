//
//  NSObject+FMDB.h
//  NNLetter
//
//  Created by SongChang on 2017/8/11.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NNSelectResultsBlock)(NSMutableArray *results);

@interface NSObject(FMDB)


#pragma mark ----------------------  解析数据 -------------------------
- (instancetype)initWithDictionary:(NSDictionary *)dict;


+ (void)initSqlite:(NSString *)sqlName;

//创建表
+(void)setTableName:(NSString *)sql_tableName;


///检查表是否存在
+(BOOL)checkSqlName:(NSString *)sqlName;


-(NSString *)createDatabase_sqlite_path;

/**
 sql:条件查询数据库
 
 @param sql 例如：WHERE userId = '2896'
 @param sqlName nil则默认model的名字，或者传对应的名字
 @param block 返回结果
 */
+(NSMutableArray *)select_by_sql:(NSString *)sql sqlName:(NSString *)sqlName block:(NNSelectResultsBlock)block;

///传一条完整的sql条件的语句查询
+(NSMutableArray *)perfect_select_by_sql:(NSString *)sql sqlName:(NSString *)sqlName block:(NNSelectResultsBlock)block;

///删除一条数据
+(void)delete_one_sql:(NSString *)sql sqlName:(NSString *)sqlName;

///删除表
+(void)delete_table_sqlName:(NSString *)sqlName;

///删除表内的所有数据
+(void)delete_all_sqlName:(NSString *)sqlName;

//查询表的数据总个数
+(NSInteger)select_count_sqlName:(NSString *)sqlName;

///修改键值
+(void)replace_condition:(NSString *)condition sqlName:(NSString *)sqlName;


///添加到数据库
+ (void)insert_by_sql:(NSString *)sql sqlName:(NSString *)sqlName dataArray:(id)dataArray;

///升级数据
+ (void)update_by_sql:(NSString *)sql sqlName:(NSString *)sqlName dataArray:(id)dataArray;
///传多个关键key即可
+ (void)update_by_keys:(NSArray *)key sqlName:(NSString *)sqlName dataArray:(id)dataArray;

///有则更新，无则添加
+ (void)update_or_insert_by_sql:(NSString *)sql sqlName:(NSString *)sqlName dataArray:(id)dataArray;

///模糊搜索
+ (void)search_byStr:(NSString *)str Key:(NSArray *)keyArr sqlName:(NSString *)sqlName block:(NNSelectResultsBlock)block __attribute__((deprecated("无效,未实现功能")));

@end

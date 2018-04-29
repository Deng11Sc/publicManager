//
//  NNSqliteManager.h
//  NNLetter
//
//  Created by SongChang on 2017/8/11.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+FMDB.h"
#import <objc/runtime.h>

@interface NNSqliteManager : NSObject


+(NNSqliteManager *)share;

- (instancetype)initWithDictionary:(NSDictionary *)dict model:(id)model;


///创建sql路径
- (NSString *)manager_createDatabase_sqlite_path;

///路径置空，因为可能需要获取新的路径
-(void)sqlite_path_dealloc;

///检查表是否存在
-(BOOL)manager_checkName:(NSString *)name;


///初始化最新的数据库方法
- (void)initNewSqlName:(NSString *)sqlName;

///创建表
-(void)setTableName:(NSString *)sql_tableName c:(Class)c;

///基本类型数据判断
-(BOOL)isCommonType:(NSString *)type;

///系统当前时间
-(NSString *)currentTime;

///获取model的key;
-(NSString *)getKeyWithIvar:(Ivar)ivar;

#pragma mark ---------------- 注册保存数据的sql语句 ----------------------
-(NSString *)setSqlStr:(id)arrayModel withSqlName:(NSString *)sqlName;




#pragma mark ---------------- 开始操作数据库 ----------------
///查询数据库数据
- (NSMutableArray *)manager_select_by_sql:(NSString *)sql sqlName:(NSString *)sqlName c:(Class)c block:(NNSelectResultsBlock)block;

///删除一条数据
-(void)manager_delete_one_sql:(NSString *)sql sqlName:(NSString *)sqlName;

///删除表
-(void)manager_delete_table_sqlName:(NSString *)sqlName;

///删除表内的所有数据
-(void)manager_delete_all_sqlName:(NSString *)sqlName;

///查询表的数据总个数
-(NSInteger)manager_select_count_sqlName:(NSString *)sqlName;

///修改键值
-(void)manager_replace_condition:(NSString *)condition sqlName:(NSString *)sqlName;

///添加到数据库
-(void)manager_insert_by_sql:(NSString *)sql sqlName:(NSString *)sqlName dataArray:(id)dataArray;

///升级数据
- (void)manager_update_by_sql:(NSString *)sql sqlName:(NSString *)sqlName dataArray:(id)dataArray;
- (void)manager_update_by_keys:(NSArray *)keys sqlName:(NSString *)sqlName dataArray:(id)dataArray;

- (void)manager_update_or_insert_by_sql:(NSString *)sql sqlName:(NSString *)sqlName dataArray:(id)dataArray;

///模糊搜索
- (void)manager_search_byStr:(NSString *)str Key:(NSArray *)keyArr sqlName:(NSString *)sqlName block:(NNSelectResultsBlock)block;


@end

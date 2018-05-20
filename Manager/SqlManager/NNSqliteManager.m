//
//  NNSqliteManager.m
//  NNLetter
//
//  Created by SongChang on 2017/8/11.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNSqliteManager.h"
#import "FMDB.h"
#import "NSString+Common.h"

#define db_version @"1.0.0"


@interface NNSqliteManager ()

///正常的队列
@property (nonatomic,strong)FMDatabaseQueue *dataBaseQueue;

///用户数据队列
@property (nonatomic,strong)FMDatabaseQueue *userInfoQueue;

@property (nonatomic,strong)NSMutableDictionary *cDic;

@end

@implementation NNSqliteManager

- (NSMutableDictionary *)cDic {
    if (!_cDic) {
        _cDic = [[NSMutableDictionary alloc] init];
    }
    return _cDic;
}

+ (NNSqliteManager *)share {
    static NNSqliteManager *_share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[NNSqliteManager alloc] init];
    });
    return _share;
}



- (instancetype)initWithDictionary:(NSDictionary *)dict model:(id)model
{
    if (model && ([dict isKindOfClass:[NSDictionary class]]||[dict isKindOfClass:[NSMutableDictionary class]])) {
        // count:成员变量个数
        unsigned int count = 0;
        // 获取成员变量数组
        Ivar *ivarList = class_copyIvarList([model class], &count);
        
        // 遍历所有成员变量
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivarList[i];
            
            // 获取key
            NSString *key = [self getKeyWithIvar:ivar];
            
            // 去字典中查找对应value
            // key:user  value:NSDictionary
            
            id value = dict[key];
            
            // 二级转换:判断下value是否是字典,如果是,字典转换层对应的模型
            // 并且是自定义对象才需要转换
            NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            // @\"User\" -> User
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
            
            if ([value isKindOfClass:[NSDictionary class]] && ![ivarType hasPrefix:@"NS"]) {
                
            }
            
            else if ([ivarType hasPrefix:@"NSMutableArray"] ||[ivarType hasPrefix:@"NSArray"]) {
                /*
                 如果是数组..那啥也不干,在对应model再调用
                 */
            } else {
                if (value) {
                    if ([value isKindOfClass:[NSNumber class]]) {
                        [model setValue:value forKey:key];
                    } else if ([value isKindOfClass:[NSString class]]) {
                        [model setValue:value forKey:key];
                    } else {
                        [model setValue:value forKey:key];
                    }

                }
            }
        }
        free(ivarList);
    }
    return model;
}

- (void)initNewSqlName:(NSString *)sqlName {
    
    if (![self.cDic objectForKey:sqlName]) {
        [self addNewColumn:sqlName];
    }
    [self.cDic setObject:sqlName forKey:sqlName];
    
}

#pragma mark ----------------------  数据库路径 -------------------------
-(NSString *)manager_createDatabase_sqlite_path {
    
    return [NSString getSqlPath];
}

//路径置空，因为可能需要获取新的路径
-(void)sqlite_path_dealloc {
    _userInfoQueue = nil;
    _dataBaseQueue = nil;
    ///这里重置路径
//    [NNFMDataBaseManager shareManager].databasePath = nil;
}


-(FMDatabaseQueue *)dataBaseQueue
{
    if (!_dataBaseQueue) {
        _dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self manager_createDatabase_sqlite_path]];
    }
    return _dataBaseQueue;
}

-(FMDatabaseQueue *)userInfoQueue
{
    if (!_dataBaseQueue) {
        _dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self manager_createDatabase_sqlite_path]];
    }
    return _dataBaseQueue;
}



////特别注意！！！！如果用户数据模块的数据表变了，判断条件必须对应变化！
-(FMDatabaseQueue *)getQueue:(NSString *)sqlName
{
    if ([sqlName isEqualToString:@"NNUserInfoModel"] ||
        [sqlName isEqualToString:@"NNUserInfoModel"] ||
        [sqlName isEqualToString:@"MyUserInfo"] ||
        [sqlName isEqualToString:@"MyUserExtend"]) {
        return self.userInfoQueue;
    } else {
        return self.dataBaseQueue;
    }
}

-(void)shareDatabase:(void (^)(FMDatabase *db))block transcation:(BOOL)transcation
{
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        if ([db open])  {
            
            if (transcation) {
                [db beginTransaction];
                
                BOOL isRollBack = NO;
                @try {
                    if (block) {
                        block(db);
                    }
                }
                @catch (NSException *exception) {
                    isRollBack = YES;
                    [db rollback];
                }
                @finally {
                    if (!isRollBack) {
                        [db commit];
                    }
                }
            } else {
                if (block) {
                    block(db);
                }
            }
            
            [db close];
            
        }
    }];
}

//dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    if ([db open]) {
//        [db close];
//    }
//});


-(void)setTableName:(NSString *)sql_tableName c:(Class)c {
    
    
    [[self getQueue:sql_tableName] inDatabase:^(FMDatabase * _Nonnull db) {
        
        NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ('Sort' INTEGER PRIMARY KEY AUTOINCREMENT , 'Version' TEXT , 'SaveTime' INTEGER ",sql_tableName];
        
        unsigned int count = 0;
        Ivar *ivarList = class_copyIvarList(c, &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivarList[i];
            
            NSString *key = [self getKeyWithIvar:ivar];
            if (key == nil) continue;
            
            NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            if ([self isCommonType:ivarType]) {
                createTable = [createTable stringByAppendingFormat:@", '%@' INTEGER",key];
            } else {
                createTable = [createTable stringByAppendingFormat:@", '%@' TEXT",key];
            }
            
        }
        free(ivarList);
        createTable = [createTable stringByAppendingFormat:@")"];
        
        //createTable为构建创建数据的语句, executeUpdate为创建数据库
        BOOL res = [db executeUpdate:createTable];
        if (!res) {
            NSLog( @"error when creating db table");
        }

    }];
}


#pragma mark ---------------- 注册保存数据的sql语句 ----------------------
-(NSString *)setSqlStr:(id)arrayModel withSqlName:(NSString *)sqlName
{
    NSString *sqlStr = @"";
    
    NSString *property_insert = @"('Version','SaveTime',";
    NSString *value_insert = [NSString stringWithFormat:@"VALUES ('%@','%@',",db_version,[self currentTime]];
    
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([arrayModel class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        
        NSString *key = [self getKeyWithIvar:ivar];
        if (key == nil) continue;
        
        //获取属性值
        id property_var = [arrayModel valueForKey:key];
        
        // 二级转换:判断下value是否是model,如果是,则向新的表增加数据
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        if (![ivarType hasPrefix:@"NS"] && ![self isCommonType:ivarType] ) {
            property_insert = [property_insert stringByAppendingFormat:@"'%@',",key];
            value_insert = [value_insert stringByAppendingFormat:@"'model_%@',",ivarType];
        }
        else if ([ivarType hasPrefix:@"NSMutableArray"] || [ivarType hasPrefix:@"NSArray"]) {
            property_insert = [property_insert stringByAppendingFormat:@"'%@',",key];
            
            id arrayClass = [[property_var firstObject] class];
            value_insert = [value_insert stringByAppendingFormat:@"'array_%@',",arrayClass];
        }
        else {
            property_insert = [property_insert stringByAppendingFormat:@"'%@',",key];
            value_insert = [value_insert stringByAppendingFormat:@"'%@',",property_var];
        }
        
    }
    free(ivarList);
    value_insert = [value_insert substringToIndex:value_insert.length-1];
    value_insert = [value_insert stringByAppendingString:@")"];
    
    sqlStr = [NSString stringWithFormat:@" %@ %@",property_insert,value_insert];
    
    return sqlStr;
}

#pragma mark ----------------------  条件查询表  ----------------------
- (NSMutableArray *)manager_select_by_sql:(NSString *)sql sqlName:(NSString *)sqlName c:(Class)c block:(NNSelectResultsBlock)block
{
    __block NSMutableArray *results;
    FMDatabaseQueue *queue = [self getQueue:sqlName];
    [queue inDatabase:^(FMDatabase * _Nonnull db) {
        
        results = [self res_select_result:db sql:sql sqlName:sqlName c:c];
        
    }];
    if (block) {
        block(results);
    }
    return results;
}

//查询结果整理
-(NSMutableArray *)res_select_result:(FMDatabase *)db sql:(NSString *)sql sqlName:(NSString *)sqlName  c:(Class)c
{
    if (sql == nil) {
        sql = @"";
    }
    sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@",sqlName,sql];

    
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    
    FMResultSet * rs = [db executeQuery:sql];
    while ([rs next]) {
        id model_value = [[c alloc] init];
        
        unsigned int count = 0;
        Ivar *ivarList = class_copyIvarList(c, &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivarList[i];
            
            NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
            NSString *key = [ivarName substringFromIndex:1];
            
            id value = [rs stringForColumn:key];
            
            // 给模型中属性赋值
            if (![NSString isEmptyString:value]) {
                
                if ([value hasPrefix:@"model_"]) {
                    
                } else if ([value hasPrefix:@"array_"]) {
                    [model_value setValue:[NSArray new] forKey:key];
                } else {
                    [model_value setValue:value forKey:key];
                }
            }
        }
        free(ivarList);
        [resultsArray addObject:model_value];
    }
    return resultsArray;
}

///删除一条数据
-(void)manager_delete_one_sql:(NSString *)sql sqlName:(NSString *)sqlName
{
    
    [[self getQueue:sqlName] inDatabase:^(FMDatabase * _Nonnull db) {
        
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@ ", sqlName];
        
        if (sql) {
            sqlstr = [sqlstr stringByAppendingString:sql];
        }
        
        if ([db open]) {
            BOOL res = [db executeUpdate:sqlstr];
            if (!res) {
                NSLog(@"DSConnect delete failure");
            }
        }
        
    }];

}

///删除表
-(void)manager_delete_table_sqlName:(NSString *)sqlName
{
    [[self getQueue:sqlName] inDatabase:^(FMDatabase * _Nonnull db) {
        
        NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", sqlName];
        if (![db executeUpdate:sqlstr])
        {
            NSLog(@"Delete table error!");
        }
        
    }];
}


///删除表内的所有数据
-(void)manager_delete_all_sqlName:(NSString *)sqlName {
    
    [[self getQueue:sqlName] inDatabase:^(FMDatabase * _Nonnull db) {
        
        NSString *sql_delete_all = [NSString stringWithFormat:@"DELETE FROM %@",sqlName];
        BOOL success = [db executeUpdate:sql_delete_all];
        if (!success) {
            NSLog(@"delete all is error");
        }
        
    }];

}

//查询表的数据总个数
-(NSInteger)manager_select_count_sqlName:(NSString *)sqlName
{
    __block int count = 0;
    
    [[self getQueue:sqlName] inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [NSString stringWithFormat:@"select count(*) from %@",sqlName];
        count = [db intForQuery:sql];
    }];
//    FMDatabase *db = [FMDatabase databaseWithPath:[self createDatabase_sqlite_path]];
//    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@",sqlName];
//    count = [db intForQuery:sql];
    
    return count;
}


///  修改键值
-(void)manager_replace_condition:(NSString *)condition sqlName:(NSString *)sqlName
{
    
    [[self getQueue:sqlName] inDatabase:^(FMDatabase * _Nonnull db) {
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET ",sqlName];
        if (condition) {
            sql = [sql stringByAppendingString:condition];
        }
        
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"DSConnect update failure");
        }
        
    }];

    
}




-(NSString *)insert:(id)arrayModel withSqlName:(NSString *)sqlName
{
    NSString *sqlStr = nil;

//    NSString *sqlStr = [self.sqlDic objectForKey:sqlName];
    
//    if (sqlStr) return sqlStr;
    
    NSString *property_insert = @"('Version','SaveTime',";
    NSString *value_insert = [NSString stringWithFormat:@"VALUES ('%@','%@',",db_version,[self currentTime]];
    
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([arrayModel class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        
        NSString *key = [self getKeyWithIvar:ivar];
        if (key == nil) continue;
        
        //获取属性值
        id property_var = [arrayModel valueForKey:key];
        
        // 二级转换:判断下value是否是model,如果是,则向新的表增加数据
        // 获取成员变量类型
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // @\"User\" -> User
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        if (![ivarType hasPrefix:@"NS"] && ![self isCommonType:ivarType] ) {
            property_insert = [property_insert stringByAppendingFormat:@"'%@',",key];
            value_insert = [value_insert stringByAppendingFormat:@"'model_%@',",ivarType];
        }
        else if ([ivarType hasPrefix:@"NSMutableArray"] || [ivarType hasPrefix:@"NSArray"]) {
            property_insert = [property_insert stringByAppendingFormat:@"'%@',",key];
            
            id arrayClass = [[property_var firstObject] class];
            value_insert = [value_insert stringByAppendingFormat:@"'array_%@',",arrayClass];
        }
        else {
            property_insert = [property_insert stringByAppendingFormat:@"'%@',",key];
            value_insert = [value_insert stringByAppendingFormat:@"'%@',",property_var];
        }
        
    }
    free(ivarList);
    
    property_insert = [property_insert substringToIndex:property_insert.length-1];
    property_insert = [property_insert stringByAppendingString:@")"];

    value_insert = [value_insert substringToIndex:value_insert.length-1];
    value_insert = [value_insert stringByAppendingString:@")"];
    
    sqlStr = [NSString stringWithFormat:@" %@ %@",property_insert,value_insert];
//    [self.sqlDic setObject:sqlStr forKey:sqlName];
    
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ %@ ",sqlName,sqlStr];
    return sql;
}

-(NSString *)update:(id)arrayModel withSqlName:(NSString *)sqlName
{
    
    NSString *sqlite_update = [NSString stringWithFormat:@"UPDATE %@ SET ",sqlName];
    
    NSString *saveTime = [self currentTime];
    sqlite_update = [sqlite_update stringByAppendingFormat:@"Version = '%@' , SaveTime = '%@'",db_version,saveTime];
    
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([arrayModel class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        NSString *key = [self getKeyWithIvar:ivar];
        
        if (key == nil) continue;
        //获取属性值
        id property_var = [arrayModel valueForKey:key];
        
        // 获取成员变量类型
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // @\"User\" -> User
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        
        // 二级转换:判断下value是否是model,如果是,则向新的表增加数据
        if (![ivarType hasPrefix:@"NS"] && ![self isCommonType:ivarType] ) {
            sqlite_update = [sqlite_update stringByAppendingFormat:@" , %@ = 'model_%@'",key,ivarType];
            
            //去除更新子model,因为子model内可能并没有property_key 和property_value的对应关系,所以无法自动更新对应的表,需额外调用子model更新
            //                    [[property_var class] database_update_all_data_with_array:property_var key:@"Data_type" value:data_type tpye:data_type];
            
        } else {
            
            if ([NSString isEmptyString:property_var]) {
                property_var = @"";
            }
            
            sqlite_update = [sqlite_update stringByAppendingFormat:@" , %@ = '%@'",key,property_var];
        }
    }
    free(ivarList);
    
    
    return sqlite_update;
}


///添加到数据库
-(void)manager_insert_by_sql:(NSString *)sql sqlName:(NSString *)sqlName dataArray:(id)dataArray
{
    [[self getQueue:sqlName] inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        [self res_insert_db:db sql:sql sqlName:sqlName dataArray:dataArray];

    }];
}


-(void)res_insert_db:(FMDatabase *)db sql:(NSString *)sql sqlName:(NSString *)sqlName dataArray:(id)dataArray
{
    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id arrayModel = obj;
        
        NSString *sqlite_insert = [self insert:arrayModel withSqlName:sqlName];
//            if (sql) {
//                sqlite_insert = [sqlite_insert stringByAppendingString:sql];
//            }
        BOOL res = [db executeUpdate:sqlite_insert];
        if (!res) {
            //如果写入失败,则可认为之前的属性发生了变化,进行一次字段更新
            NSLog(@"inser_res");
        }
    }];
}


///升级数据
- (void)manager_update_by_sql:(NSString *)sql sqlName:(NSString *)sqlName dataArray:(id)dataArray
{
    
    [[self getQueue:sqlName] inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        [self res_update_db:db sql:sql sqlName:sqlName dataArray:dataArray];
        
    }];

}

- (void)res_update_db:(FMDatabase *)db sql:(NSString *)sql sqlName:(NSString *)sqlName dataArray:(id)dataArray
{
    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id arrayModel = obj;
        
        NSString *sqlite_update = [self update:arrayModel withSqlName:sqlName];
        if (sql) {
            sqlite_update = [sqlite_update stringByAppendingFormat:@" %@",sql];
        }
        BOOL res = [db executeUpdate:sqlite_update];
        if (!res) {
            //如果写入失败,则可认为之前的属性发生了变化,进行一次字段更新
            NSLog(@"update_res");
        }
    }];
}

//    NSString *sql = [NSString stringWithFormat:@"WHERE %@ = '%@'",key,]
- (void)manager_update_by_keys:(NSArray *)keys sqlName:(NSString *)sqlName dataArray:(id)dataArray
{
    
    [[self getQueue:sqlName] inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            
            //获取条件语句
            NSString *sql = @" WHERE ";
            for (int i = 0; i < keys.count; i++) {
                NSString *key = keys[i];
                if (i != keys.count-1) {
                    sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ = '%@' AND ",key,[obj valueForKey:key]]];
                } else {
                    sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ = '%@'",key,[obj valueForKey:key]]];
                }
            }
            
            //进行查询
            NSMutableArray *results = [self res_select_result:db sql:sql sqlName:sqlName c:[obj class]];
            
            if (results.count == 0) {
                [self res_insert_db:db sql:sql sqlName:sqlName dataArray:@[obj]];
            } else {
                [self res_update_db:db sql:sql sqlName:sqlName dataArray:@[obj]];
            }

        }];
        
    }];
    
}

///
- (void)manager_update_or_insert_by_sql:(NSString *)sql sqlName:(NSString *)sqlName dataArray:(id)dataArray
{
    
    [[self getQueue:sqlName] inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray *results = [self res_select_result:db sql:sql sqlName:sqlName c:[obj class]];
            
            if (results.count == 0) {
                [self res_insert_db:db sql:sql sqlName:sqlName dataArray:@[obj]];
            } else {
                [self res_update_db:db sql:sql sqlName:sqlName dataArray:@[obj]];
            }

        }];

    }];

}



///模糊搜索
- (void)manager_search_byStr:(NSString *)str Key:(NSArray *)keyArr sqlName:(NSString *)sqlName block:(NNSelectResultsBlock)block {
    
    [[self getQueue:sqlName] inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ",sqlName];
        
        NSString *where = nil;
        for (NSString *key in keyArr) {
            if (!where) {
                where = [NSString stringWithFormat:@" WHERE %@ like '%%%@%%'",key,str];
            } else {
                where = [NSString stringWithFormat:@" OR %@ like '%%%@%%' ",key,str];
            }
        }
        sql = [NSString stringWithFormat:@"%@%@",sql,where];
        
    }];

    
}













#pragma mark ------------- 一些公用方法 ---------------



///检查最新的数据库字段
-(void)addNewColumn:(NSString *)sqlName
{
    //    alter table A add B
    
    //获取表名
    
    [[self getQueue:sqlName] inDatabase:^(FMDatabase * _Nonnull db) {
        
        unsigned int count = 0;
        Ivar *ivarList = class_copyIvarList(NSClassFromString(sqlName), &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivarList[i];
            
            NSString *key = [self getKeyWithIvar:ivar];
            if (key == nil) continue;
            
            NSString *sql = [NSString stringWithFormat:@"alter table %@ add %@",sqlName,key];
            
            if (![db columnExists:key inTableWithName:sqlName]) {
                
                BOOL res = [db executeUpdate:sql];
                if (!res) {
                    NSLog( @"error table %@ when add %@ ",sqlName,key);
                }
            }
        }
        free(ivarList);
    }];


    
    
}



-(BOOL)manager_checkName:(NSString *)name
{
    __block BOOL isExsit = NO;
    
    [[self getQueue:name] inDatabase:^(FMDatabase * _Nonnull db) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@ where type ='table' AND name = %@",name,name];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next])
        {
            // just print out what we've got in a number of formats.
            NSInteger count = [rs intForColumn:@"count"];
            
            if (count > 0) {
                isExsit = YES;
            } else {
                isExsit = NO;
            }
        }

        
//        NSString *sql = [NSString stringWithFormat:@"SELECT count(*) FROM %@",name];
//        int count = [db intForQuery:sql];
//        if (count > 0) {
//            isExsit = YES;
//        } else {
//            isExsit = NO;
//        }
    }];

    return isExsit;
}



//基本类型数据判断
-(BOOL)isCommonType:(NSString *)type
{
    if ([type isEqualToString:@"B"]||
        [type isEqualToString:@"i"]||
        [type isEqualToString:@"q"]||
        [type isEqualToString:@"d"]||
        [type isEqualToString:@"f"]) {
        return YES;
    }
    
    return NO;
}

//系统当前时间
-(NSString *)currentTime
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] ;
    
    return [NSString stringWithFormat:@"%.f",interval];
}


-(NSString *)getKeyWithIvar:(Ivar)ivar {
    
    NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
    
    // 获取key
    NSString *key = nil;
    if ([[ivarName substringToIndex:1] isEqualToString:@"_"]) {
        key = [ivarName substringFromIndex:1];
    } else {
        key = ivarName;
    }
    
    if ([key isEqualToString:@"Sort"] ||
        [key isEqualToString:@"Version"] ||
        [key isEqualToString:@"cDic"] ||
        [key isEqualToString:@"dataBaseQueue"] ||
        [key isEqualToString:@"updatedAt"] ||
        [key isEqualToString:@"createdAt"] ||
        [key isEqualToString:@"__type"] ) {
        return nil;
    }
    
    return key;
}


@end

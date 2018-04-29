//
//  NNSqliteHeader.m
//  NNLetter
//
//  Created by SongChang on 2017/8/18.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNSqliteHeader.h"
#import "NNSqliteManager.h"

#import "DY_OcrRecordModel.h"

@implementation NNSqliteHeader

+(void)init_sql
{
    [DY_OcrRecordModel initSqlite:nil];
    
}

+(void)clear
{
    [DY_OcrRecordModel delete_all_sqlName:nil];
}

@end

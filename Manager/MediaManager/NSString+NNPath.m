//
//  NSString+NNPath.m
//  NNLetter
//
//  Created by gavin.tangwei on 2017/6/29.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NSString+NNPath.h"

@implementation NSString (NNPath)

#pragma mark - 获得根目录路径
+ (NSString *)documentPath { return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]; }
+ (NSString *)cachePath { return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]; }
+ (NSString *)tempPath { return NSTemporaryDirectory(); }
#pragma mark - 根据自定义路径获得绝对路径
- (NSString *)documentPath { return [[NSString documentPath] stringByAppendingPathComponent:self]; }
- (NSString *)cachePath { return [[NSString cachePath] stringByAppendingPathComponent:self]; }
- (NSString *)tempPath { return [[NSString tempPath] stringByAppendingPathComponent:self]; }
#pragma mark - 创建文件夹
- (BOOL)createFolder { return [[NSFileManager defaultManager] createDirectoryAtPath:self withIntermediateDirectories:YES attributes:nil error:nil]; }
- (BOOL)createDocumentFolder
{
    NSString *path = [self documentPath];
    return [path createFolder];
}
- (BOOL)createCacheFolder
{
    NSString *path = [self cachePath];
    return [path createFolder];
}
- (BOOL)createTempFolder
{
    NSString *path = [self tempPath];
    return [path createFolder];
}

//#pragma mark - 创建文件
//- (BOOL)createFile { return [[NSFileManager defaultManager] createFileAtPath:self contents:nil attributes:nil]; }
//- (BOOL)createDocumentFile
//{
//    NSString *path = [self documentPath];
//    return [path createFile];
//}
//- (BOOL)createCacheFile
//{
//    NSString *path = [self cachePath];
//    return [path createFile];
//}
//- (BOOL)createTempFile
//{
//    NSString *path = [self tempPath];
//    return [path createFile];
//}

#pragma mark - 念念自有

+ (NSString *)nn_userFolder { return [[NSString nn_userID] documentPath]; }
+ (NSString *)nn_userInfoFolder { return [@"UserInfo" documentPath]; }
+ (NSString *)nn_databasePath
{
    NSString *uid = [NSString nn_userID];
//    NSAssert(([uid length] > 0), @"uid 为空");
    return [[NSString stringWithFormat:@"%@/broon_%@.sqlite", uid, uid] documentPath];
}

+ (NSString *)nn_userInfoDatabasePath
{
    NSString *databasePath = [NSString nn_userInfoFolder];
    return [databasePath stringByAppendingPathComponent:@"broon_userInfo.sqlite"];
}

+ (NSString *)nn_userID
{
    NSString *userID = SELF_USER_ID;
    if ([userID isKindOfClass:[NSString class]]) {
        return userID;
    }
    else if ([userID isKindOfClass:[NSNumber class]]) {
        return  ((NSNumber*)userID).stringValue;
    }
    return nil;
}
@end

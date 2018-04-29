//
//  NSString+NNPath.h
//  NNLetter
//
//  Created by gavin.tangwei on 2017/6/29.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NNPath)

+ (NSString *)documentPath;
+ (NSString *)cachePath;
+ (NSString *)tempPath;

- (NSString *)documentPath;
- (NSString *)cachePath;
- (NSString *)tempPath;

- (BOOL)createFolder;
- (BOOL)createDocumentFolder;
- (BOOL)createCacheFolder;
- (BOOL)createTempFolder;

//- (BOOL)createFile;
//- (BOOL)createDocumentFile;
//- (BOOL)createCacheFile;
//- (BOOL)createTempFile;

/// eg: documents/12314
+ (NSString *)nn_userFolder;
/// eg:documents/12314/UserInfo
+ (NSString *)nn_userInfoFolder;
/// eg:documents/12314/broon_12314.sqlite
+ (NSString *)nn_databasePath;
/// eg:documents/12314/UserInfo/broon_userInfo.sqlite
+ (NSString *)nn_userInfoDatabasePath;
/// eg:12314
+ (NSString *)nn_userID;

@end

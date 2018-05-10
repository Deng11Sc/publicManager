//
//  NSDate+CCExtension.h
//  InitiallyProject
//
//  Created by SongChang on 2018/5/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

//获取当前时间，标准格式
+(NSString *)getCurrentTimes;
//获取当前时间，自定义格式
+(NSString *)getCurrentTimesWithFormat:(NSString *)format ;



//获取当前时间戳
+(NSNumber *)getNowTimeTimestamp;



//时间戳转时间，结果为标准格式
+ (NSString *)toTimeWithRawTime:(NSNumber *)rawTime;

//时间戳转时间，需要传format格式
+ (NSString *)toTimeWithRawTime:(NSNumber *)rawTime format:(NSString *)format ;



//时间转时间戳，标准格式
+(NSNumber *)toTimestamp:(NSString *)time ;
//时间转时间戳，需要传format格式
+(NSNumber *)toTimestamp:(NSString *)time format:(NSString *)format;

@end

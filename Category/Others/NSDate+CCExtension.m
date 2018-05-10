//
//  NSDate+CCExtension.m
//  InitiallyProject
//
//  Created by SongChang on 2018/5/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "NSDate+CCExtension.h"

#define CCDefineFormat @"YYYY-MM-dd HH:mm"

@implementation NSDate (Extension)




//获取当前时间，标准格式
+(NSString *)getCurrentTimes {
    return [self getCurrentTimesWithFormat:CCDefineFormat];
}

+(NSString *)getCurrentTimesWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return [NSString stringWithFormat:@"%.f",[currentTimeString doubleValue]];
}



//获取当前时间戳
+(NSNumber *)getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString *timeStr= [NSString stringWithFormat:@"%.f",a];
    
    NSNumber *timeNumber = [NSNumber numberWithInteger:[timeStr integerValue]];
    return timeNumber;
    
}

//时间戳转时间，结果为标准格式
+ (NSString *)toTimeWithRawTime:(NSNumber *)rawTime {
    return [self toTimeWithRawTime:rawTime format:CCDefineFormat];
}

//时间戳转时间，需要传format格式
+ (NSString *)toTimeWithRawTime:(NSNumber *)rawTime format:(NSString *)format {
    
    // iOS 生成的时间戳是10位
    
    
    NSTimeInterval interval    = [rawTime doubleValue] >10000000000 ? [rawTime doubleValue]/1000.0 : [rawTime doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dateString       = [formatter stringFromDate: date];
    
    return dateString;
}

//时间转时间戳，标准格式
+(NSNumber *)toTimestamp:(NSString *)time {
    return [self toTimestamp:time format:CCDefineFormat];
}

//时间转时间戳，需要传format格式
+(NSNumber *)toTimestamp:(NSString *)time format:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    NSDate *date = [formatter dateFromString:time];
    NSNumber *timeNumber = [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    
    return timeNumber;
    
}




@end

//
//  NSObject+Extension.m
//  RoyaleRoulette
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import "NSObject+Extension.h"
#import "NSString+Extention.h"

@implementation NSObject (Extension)

+(BOOL)isOrientationPortrait{
    UIInterfaceOrientation interface = [UIApplication sharedApplication].statusBarOrientation;
    if (interface == UIInterfaceOrientationLandscapeLeft || interface == UIInterfaceOrientationLandscapeRight) {// 横屏
        return NO;
    }
    
    return YES;
}

+ (NSString *)getStringFromDict:(NSDictionary*)dict withKey:(id)key{
    
    NSString *string = @"";
    if (dict && [dict objectForKey:key]) {
        string = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
    }
    
    if (string == nil || [string isBlankString]) {
        string = @"";
    }
    
    return string;
}

@end

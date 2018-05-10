//
//  NSString+Extention.m
//  RoyaleRoulette
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import "NSString+Extention.h"

@implementation NSString (Extention)

- (BOOL)isBlankString{
    if (self == NULL || [self isEqual:nil] || [self isEqual:Nil] || self == nil)
        return  YES;
    if ([self isEqual:[NSNull null]])
        return  YES;
    if (![self isKindOfClass:[NSString class]] )
        return  YES;
    if (0 == [self length] || 0 == [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
        return  YES;
    if([self isEqualToString:@"(null)"])
        return  YES;
    if([self isEqualToString:@"<null>"])
        return  YES;
    return NO;
}

@end

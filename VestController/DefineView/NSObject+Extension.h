//
//  NSObject+Extension.h
//  RoyaleRoulette
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

+(BOOL)isOrientationPortrait;

+ (NSString *)getStringFromDict:(NSDictionary*)dict withKey:(id)key;

@end

//
//  GenerateTableManager.m
//  NearbyTask
//
//  Created by SongChang on 2018/4/27.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "GenerateTableManager.h"
#import "CC_LeanCloudNet.h"
#import "CC_LeanCloudNet+Method.h"

#import <objc/message.h>
#import <objc/runtime.h>

@implementation GenerateTableManager

+ (void)generateTableWithModel:(id)model tableName:(NSString *)tableName;
{
    CC_LeanCloudNet *request = [[CC_LeanCloudNet alloc] init];
    request.className = tableName;
    [request requestWithFatherClass:[model class]];
    request.successful = ^(NSMutableArray *array, NSInteger code, id json) {
//        if (!array.count) {
//            [self save:model name:tableName];
//        }
        [self save:model name:tableName];

    };
    request.failure = ^(NSString *error, NSInteger code) {
        [self save:model name:tableName];
    };
    [request startRequest];
    
}

+(void)save:(id)model name:(NSString *)tableName
{
    unsigned int count;
    objc_property_t* props = class_copyPropertyList([model class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = props[i];
        const char * name = property_getName(property);
        NSString * nameType = [NSString stringWithUTF8String:name];
        const char * type = property_getAttributes(property);
        NSString * typeString = [NSString stringWithUTF8String:type];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        NSString * propertyType = [typeAttribute substringFromIndex:1];
        const char * rawPropertyType = [propertyType UTF8String];
        
        if (strcmp(rawPropertyType, @encode(float)) == 0) {
            //it's a float
        } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
            //it's an int
        } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
            //it's some sort of object
        } else {
            
        }
        
        if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
            NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];  //turns @"NSDate" into NSDate
            if (typeClassName != nil) {
                // Here is the corresponding class even for nil values
                
                if (![model valueForKey:nameType]) {
                    if ([typeClassName isEqualToString:@"NSString"]) {
                        [model setValue:@"" forKey:nameType];
                    } else if ([typeClassName isEqualToString:@"NSNumber"]) {
                        [model setValue:@(0) forKey:nameType];
                    }
                }
                
            }
        }
    }
    free(props);
    
    CC_LeanCloudNet *net = [[CC_LeanCloudNet alloc] init];
    [net fatherModelWithClassName:tableName arr:@[model]];
    net.successful = ^(NSMutableArray *array, NSInteger code, id json) {
        id model = array.firstObject;
        NSString *cql = [NSString stringWithFormat:@"delete from %@ where objectId='%@'", tableName,[model valueForKey:@"uniqueId"]];
        CC_LeanCloudNet *requestCql = [[CC_LeanCloudNet alloc] init];
        [requestCql startWithCql:cql];
    };
    [net saveRequest];
}

//获取model的其中一个key
+(NSString *)getKeyWithIvar:(Ivar)ivar {
    
    NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
    
    // 获取key
    NSString *key = nil;
    if ([[ivarName substringToIndex:1] isEqualToString:@"_"]) {
        key = [ivarName substringFromIndex:1];
    } else {
        key = ivarName;
    }
    return key;
}


@end

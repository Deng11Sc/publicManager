//
//  CC_LeanCloudNet+Method.m
//  NearbyTask
//
//  Created by SongChang on 2018/4/27.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CC_LeanCloudNet+Method.h"

@implementation CC_LeanCloudNet(Method)

///构成todo数据
-(AVObject *)todoWithClassName:(NSString *)className model:(id)model
{
    NSString *objectId = [model valueForKey:self.uniqueId];
    
    AVObject *todo;
    if ([NSString isEmptyString:objectId]) {
        todo = [[AVObject alloc] initWithClassName:className];// 构建对象
        
    } else {
        todo = [AVObject objectWithClassName:className objectId:objectId];// 构建对象
    }
    
    //
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([model class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        
        NSString *key = [self getKeyWithIvar:ivar];
        id value = [model valueForKey:key];
        
        if ([key isEqualToString:@"objectId"] || [key isEqualToString:@"updatedAt"] || [key isEqualToString:@"createdAt"] ||[key isEqualToString:self.uniqueId] || [key isEqualToString:@"taskType"]) {
            continue;
        }
        //        BOOL isbool = [arr containsObject:key];
        
        if (![NSString isEmptyString:self.userId]) {
            [todo setObject:self.userId forKey:@"userId"];
        }
        
        BOOL isbool = NO;
        if (isbool) {
            [todo setObject:@([value integerValue]) forKey:key];
        } else {
            [todo setObject:value forKey:key];
        }
    }
    free(ivarList);
    
    return todo;
}

//获取model的其中一个key
-(NSString *)getKeyWithIvar:(Ivar)ivar {
    
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

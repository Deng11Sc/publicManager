//
//  NSObject+Warning.h
//  NNLetter
//
//  Created by niannian on 17/5/17.
//  Copyright © 2017年 niannian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Warning)
+(void)showError:(NSString *)desprition;



+(void)hideTip;


////torast提示
+(void)showMessage:(NSString *)message;

+(void)showTorast:(NSString *)torast;


@end

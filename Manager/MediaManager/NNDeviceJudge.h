//
//  NNDeviceJudge.h
//  NNLetter
//
//  Created by mac on 2017/6/8.
//  Copyright © 2017年 niannian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNDeviceJudge : NSObject

/**
 iPhone设备是否单核心
 
 @return YES：单核  NO：多核
 */
+ (BOOL)isSingleCore;

/**
 获取设备型号然后手动转化为对应名称
 
 @return 对应名称
 */
+ (NSString *)getDeviceName;
@end

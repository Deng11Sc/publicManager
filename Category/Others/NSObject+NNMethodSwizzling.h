//
//  NSObject+NNMethodSwizzling.h
//  NNLetter
//
//  Created by shizhi on 2017/6/6.
//  Copyright © 2017年 niannian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NNMethodSwizzling)
+ (void)nn_methodSwizzling:(SEL) aOrgSel descSel:(SEL)aDestSel;
@end

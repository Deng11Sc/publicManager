//
//  NSObject+NNMethodSwizzling.m
//  NNLetter
//
//  Created by shizhi on 2017/6/6.
//  Copyright © 2017年 niannian. All rights reserved.
//

#import "NSObject+NNMethodSwizzling.h"
#import <objc/runtime.h>

@implementation NSObject (NNMethodSwizzling)

+ (void)nn_methodSwizzling:(SEL) aOrgSel descSel:(SEL)aDestSel {
    SEL originalSelector = aOrgSel;
    SEL swizzledSelector = aDestSel;
    
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(self,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(self,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end

//
//  NNImageChooseObject.h
//  NNLetter
//
//  Created by gavin.tangwei on 2017/8/23.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NNImageChooseCompleteBlock)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto);

@interface NNImageChooseObject : NSObject

//只能选一张
+ (void)gotoChooseImageFrom:(UIViewController  *)from complete:(NNImageChooseCompleteBlock)blk;
- (void)gotoChooseImageFrom:(UIViewController  *)from complete:(NNImageChooseCompleteBlock)blk;

//自定义选多张
+ (void)gotoChooseImageFrom:(UIViewController  *)from maxCount:(NSInteger)count complete:(NNImageChooseCompleteBlock)blk;
- (void)gotoChooseImageFrom:(UIViewController  *)from maxCount:(NSInteger)count complete:(NNImageChooseCompleteBlock)blk;

@end

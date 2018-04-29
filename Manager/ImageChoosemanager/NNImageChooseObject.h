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

+ (void)gotoChooseImageFrom:(UIViewController  *)from complete:(NNImageChooseCompleteBlock)blk;
- (void)gotoChooseImageFrom:(UIViewController  *)from complete:(NNImageChooseCompleteBlock)blk;


+ (void)gotoChooseQRCodeImageFrom:(UIViewController *)from  complete:(NNImageChooseCompleteBlock)blk;
- (void)gotoChooseQRCodeImageFrom:(UIViewController *)from  complete:(NNImageChooseCompleteBlock)blk;

+ (void)gotoCustomerServiceImageFrom:(UIViewController *)from left:(NSInteger)left complete:(NNImageChooseCompleteBlock)blk;
- (void)gotoCustomerServiceImageFrom:(UIViewController *)from left:(NSInteger)left complete:(NNImageChooseCompleteBlock)blk;

+ (void)gotoChatRoomChooseImageFrom:(UIViewController  *)from complete:(NNImageChooseCompleteBlock)blk;
- (void)gotoChatRoomChooseImageFrom:(UIViewController  *)from complete:(NNImageChooseCompleteBlock)blk;
@end

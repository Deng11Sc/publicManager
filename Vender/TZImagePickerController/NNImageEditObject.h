//
//  NNImageEditObject.h
//  NNLetter
//
//  Created by gavin.tangwei on 2017/8/15.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^NNImageEditCompleteBlock)(UIImage *image);
@interface NNImageEditObject : NSObject

+ (void)gotoEditImageWithImage:(UIImage *)aImage from:(UIViewController  *)from complete:(NNImageEditCompleteBlock)blk;
- (void)gotoEditImageWithImage:(UIImage *)aImage from:(UIViewController  *)from complete:(NNImageEditCompleteBlock)blk;

+ (void)gotoEditChatRoomImageWithImage:(UIImage *)aImage from:(UIViewController *)from complete:(NNImageEditCompleteBlock)blk;
- (void)gotoChatRoomEditImageWithImage:(UIImage *)aImage from:(UIViewController *)from complete:(NNImageEditCompleteBlock)blk;

@end

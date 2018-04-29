//
//  UIImage+Common.h
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Common)

///获取一张背景颜色为color，大小为size的图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


/**
 压缩成某个尺寸
 
 @param size size
 @return 处理之后的image
 */
- (UIImage *)scaleImageToSize:(CGSize)size;

/**
 根据网络图片获取尺寸
 
 @param URL 链接地址
 @return 返回尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)URL;


/**
 *  调节图片的方向
 *
 */
+ (UIImage *)ImageFixOrientation:(UIImage *)aImage ;


@end

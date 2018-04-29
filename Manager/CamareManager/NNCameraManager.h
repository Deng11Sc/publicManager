//
//  NNCameraManager.h
//  NNLetter
//
//  Created by mac on 2017/6/29.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNCameraManager : NSObject
#pragma mark -------------相机操作------------------
///相机是否授权
+ (BOOL)isCameraAvailable;

///是否后置摄像头
+ (BOOL)isRearCameraAvailable;
///是否前置摄像头
+ (BOOL)isFrontCameraAvailable;

///是否支持拍照
+ (BOOL)doesCameraSupportTakingPhotos;

#pragma mark -------------相册操作------------------
///相册是否授权
+ (BOOL)isPhotoLibraryAvailable;
///能否选择视频
+ (BOOL)canUserPickVideosFromPhotoLibrary;

/**
 裁剪缩放照片

 @param sourceImage 裁剪素材
 @return 返回图片
 */
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;
@end

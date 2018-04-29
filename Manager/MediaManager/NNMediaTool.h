//
//  NNMediaTool.h
//  NNLetter
//
//  Created by gavin.tangwei on 2017/8/9.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@protocol NNMediaToolDelegate <NSObject>

@optional
- (void)imageWithFilePath:(NSURL *)filePath image:(UIImage *)aImage;
- (void)videoWithFilePath:(NSURL *)filePath;

@end

@interface NNMediaTool : NSObject

@property(nonatomic,weak) id<NNMediaToolDelegate> delegate;
@property (nonatomic, strong, readonly) AVCaptureSession *session;

+ (instancetype)defaultTool;

/**
 拍照
 */
- (void)takePhoto;

/**
 开启摄像头
 */
- (void)startCapture;

/**
 关闭摄像头
 */
- (void)stopCapture;

/**
 开始录视频
 */
- (void)startRecord;

/**
 结束录视频
 */
- (void)stopRecord;

/**
 取消录视频
 */
- (void)cancleRecord;


/**
 自动聚焦
 */
- (void)autoFocuse;

/**
 聚焦到 point
 
 @param focusMode 模式
 @param exposureMode 模式
 @param point 点
 */
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point;

/**
 设置焦距
 
 @param length 焦距 大小
 */
- (void)setFocalength:(CGFloat)length;
- (void)resetFocalength;
- (void)focalLength:(CGFloat)length;

/**
 切换摄像头
 */
- (void)changeToBack;
- (void)changeToFront;
- (void)changeToAnother;
- (BOOL)isFrontCamera;

/**
 闪光灯
 */
- (void)openFlash;
- (void)closeFlash;
- (void)autoFlash;
@end

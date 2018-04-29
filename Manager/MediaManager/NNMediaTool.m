//
//  NNMediaTool.m
//  NNLetter
//
//  Created by gavin.tangwei on 2017/8/9.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNMediaTool.h"
#import "NNDeviceJudge.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+NNPath.h"
#import "UIImage+Common.h"

typedef void (^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface NNMediaTool () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession;                     //负责输入和输入设备之间的数据传递
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;             //负责从captureDevice获得输入数据
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer; //相机拍摄预览图层

@property (nonatomic, strong) dispatch_queue_t videoDataOutputQueue;
@property (nonatomic, strong) dispatch_queue_t audioDataOutputQueue;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput;
@property (nonatomic, strong) AVCaptureConnection *audioConnection;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInput *videoInput;
@property (nonatomic, strong) AVAssetWriterInput *audioInput;

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, assign) BOOL isCanceled; //是否取消录制了
@property (atomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isFirstSample;

@property (nonatomic, strong) NSURL *videoPath;
@property (nonatomic, strong) NSURL *imagePath;

@property (nonatomic, assign) CGFloat widthHeightScale;
@property (nonatomic, assign) CGSize targetSize;
@end

@implementation NNMediaTool

- (AVCaptureSession *)session
{
    return self.captureSession;
}

+ (instancetype)defaultTool
{
    return [NNMediaTool new];
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.videoPath = [NSURL fileURLWithPath:[[NSString tempPath] stringByAppendingPathComponent:@"tempVideo.mp4"]];
    self.imagePath = [NSURL fileURLWithPath:[[NSString tempPath] stringByAppendingPathComponent:@"tempImage.jpg"]];
    _widthHeightScale = (CC_Height) / CC_Width;
    _targetSize = CGSizeMake(CC_Width, CC_Height);
    _isFirstSample = true;

    [self defaultConfigure];
}

- (void)startCapture
{
    [self.captureSession startRunning];
}

- (void)stopCapture
{
    [self.captureSession stopRunning];
}

- (void)takePhoto
{
    printf("拍照\n");

    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection)
    {
        NSLog(@"take photo failed!");
        return;
    }

    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                       completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                         [self stopCapture];

                                                         if (imageDataSampleBuffer == NULL)
                                                         {
                                                             return;
                                                         }
                                                         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                         UIImage *image = [UIImage ImageFixOrientation:[UIImage imageWithData:imageData]];
                                                         [UIImageJPEGRepresentation(image, 0.9) writeToURL:self.imagePath atomically:YES];
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           [self.delegate imageWithFilePath:self.imagePath image:image];
                                                         });
                                                       }];
}

- (void)stopRecord
{
    if (!self.isRecording) {
        return;
    }
    printf("stopRecord 停止拍摄\n");
    self.isRecording = NO;
    self.isFirstSample = true;
    [self.audioInput markAsFinished];
    [self.videoInput markAsFinished];
    [self stopCapture];
    if (self.assetWriter.status != AVAssetWriterStatusCancelled)
    {
        [_assetWriter finishWritingWithCompletionHandler:^{
          @synchronized(self)
          {
              _assetWriter = nil;
              _audioInput = nil;
              _videoInput = nil;
              dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate videoWithFilePath:self.videoPath];
              });
          }
        }];
    }
}

- (void)cancleRecord
{
    printf("cancleRecord 取消拍摄\n");
    self.isFirstSample = true;
    self.isCanceled = YES;
    self.isRecording = NO;
    [_assetWriter cancelWriting];
    _assetWriter = nil;
}

- (void)startRecord
{
    printf("startRecord 开始拍摄\n");
    [[NSFileManager defaultManager] removeItemAtURL:self.videoPath error:nil];

    self.isRecording = YES;

    NSError *error = nil;
    _assetWriter = [[AVAssetWriter alloc] initWithURL:self.videoPath fileType:AVFileTypeMPEG4 error:&error];

    if ([_assetWriter canAddInput:self.videoInput])
    {
        [_assetWriter addInput:self.videoInput];
    }
    if ([_assetWriter canAddInput:self.audioInput])
    {
        [_assetWriter addInput:self.audioInput];
    }
    [_assetWriter startWriting];
}

- (void)autoFocuse
{
    if (self.isRecording)
    {
        return;
    }
    [self _changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
      if ([captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus])
      {
          [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
      }
    }];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point
{
    if (self.isRecording)
    {
        return;
    }
    point = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];

    [self _changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
      if ([captureDevice isFocusModeSupported:focusMode])
      {
          [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
      }
      if ([captureDevice isFocusPointOfInterestSupported])
      {
          [captureDevice setFocusPointOfInterest:point];
      }
      if ([captureDevice isExposureModeSupported:exposureMode])
      {
          [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
      }
      if ([captureDevice isExposurePointOfInterestSupported])
      {
          [captureDevice setExposurePointOfInterest:point];
      }
    }];
}

- (void)setFocalength:(CGFloat)length
{
    [self _changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
      if (captureDevice.videoZoomFactor != length)
      {
          [captureDevice rampToVideoZoomFactor:length withRate:2];
      }
    }];
}

- (void)resetFocalength
{
    [self _changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
      [captureDevice rampToVideoZoomFactor:1.0 withRate:2];
    }];
}

- (void)focalLength:(CGFloat)length
{
    [self _changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
      if (captureDevice.videoZoomFactor == 1)
      {
          [captureDevice rampToVideoZoomFactor:length withRate:2];
      }
      else
      {
          [captureDevice rampToVideoZoomFactor:1 withRate:2];
      }
    }];
}

- (void)changeToBack
{
    _videoInput = nil;
    _audioInput = nil;

    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionBack;
    toChangeDevice = [self _getCameraDeviceWithPositon:toChangePosition];
    AVCaptureDeviceInput *toChangeDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:toChangeDevice error:nil];
    [self _changeCamera:toChangeDeviceInput];
}

- (void)changeToFront
{
    _videoInput = nil;
    _audioInput = nil;
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    toChangeDevice = [self _getCameraDeviceWithPositon:toChangePosition];
    AVCaptureDeviceInput *toChangeDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:toChangeDevice error:nil];
    [self _changeCamera:toChangeDeviceInput];
}

- (void)changeToAnother
{
    if ([self.captureDeviceInput device].position == AVCaptureDevicePositionBack)
    {
        [self changeToFront];
        return;
    }
    [self changeToBack];
}

- (BOOL)isFrontCamera
{
    return ([self.captureDeviceInput device].position == AVCaptureDevicePositionFront);
}

- (void)openFlash
{
    AVCaptureDevice *captureDevice = [self.captureDeviceInput device];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error])
    {
        if ([captureDevice hasFlash]) {
            if ([captureDevice isFlashModeSupported:AVCaptureFlashModeOn])
            {
                captureDevice.flashMode = AVCaptureFlashModeOn;
            }
            if ([captureDevice isTorchModeSupported:AVCaptureTorchModeAuto])
            {
                [captureDevice setTorchMode:AVCaptureTorchModeAuto];
            }
        } else {
            
            NSLog(@"设备不支持闪光灯");
        }
        
        [captureDevice unlockForConfiguration];
        
    }
    else
    {
        // Handle the error appropriately.
    }
}

- (void)closeFlash
{
    AVCaptureDevice *captureDevice = [self.captureDeviceInput device];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error])
    {
        if ([captureDevice hasFlash]) {
            if ([captureDevice isFlashModeSupported:AVCaptureFlashModeOff])
            {
                captureDevice.flashMode = AVCaptureFlashModeOff;
            }
            if ([captureDevice isTorchModeSupported:AVCaptureTorchModeOff])
            {
                [captureDevice setTorchMode:AVCaptureTorchModeOff];
            }
        } else {
            
            NSLog(@"设备不支持闪光灯");
        }
        
        [captureDevice unlockForConfiguration];
    }
    else
    {
    }
}

- (void)autoFlash
{
    AVCaptureDevice *captureDevice = [self.captureDeviceInput device];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error])
    {
        if ([captureDevice hasFlash]) {
            if ([captureDevice isFlashModeSupported:AVCaptureFlashModeAuto])
            {
                captureDevice.flashMode = AVCaptureFlashModeAuto;
            }
            
            if ([captureDevice isTorchModeSupported:AVCaptureTorchModeAuto])
            {
                [captureDevice setTorchMode:AVCaptureTorchModeAuto];
            }
        } else {
            
            NSLog(@"设备不支持闪光灯");
        }
        
        [captureDevice unlockForConfiguration];
    }
}

#pragma mark-- AVCaptureVideoDataOutputSampleBufferDelegate / AVCaptureAudioDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    @synchronized(self)
    {
        if (!self.isRecording)
        {
            return;
        }
        if (_assetWriter.status == AVAssetWriterStatusUnknown)
        {
            return;
        }

        if (connection == self.videoConnection)
        {
            if (_isFirstSample)
            {
                [_assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
                _isFirstSample = NO;
            }

            if (self.videoInput.readyForMoreMediaData)
            {
                [self.videoInput appendSampleBuffer:sampleBuffer];
            }
        }
        // 必须先 startSessionAtSourceTime 才能 appendSampleBuffer
        if (_isFirstSample)
        {
            return;
        }
        if (connection == self.audioConnection)
        {
            if (self.audioInput.readyForMoreMediaData)
            {
                [self.audioInput appendSampleBuffer:sampleBuffer];
            }
        }
    }
}

- (void)defaultConfigure
{
    //初始化会话
    _captureSession = [[AVCaptureSession alloc] init];
    if ([NNDeviceJudge isSingleCore])
    {
        if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480])
        { //设置分辨率
            [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
        }
    }
    else
    {
        if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720])
        { //设置分辨率
            [_captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
        }
    }

    //获取输入设备
    AVCaptureDevice *captureDevice = [self _getCameraDeviceWithPositon:AVCaptureDevicePositionBack]; //后置摄像头
    if (!captureDevice)
    {
        NSLog(@"获取摄像头失败");
        _captureSession = nil;
        return;
    }

    //添加音频输入设备
    AVCaptureDevice *audiocaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    if (!audiocaptureDevice)
    {
        NSLog(@"获取音频设备失败");
        return;
    }

    //初始化输入对象
    NSError *error = nil;
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error)
    {
        NSLog(@"获取设备输入对象失败，error:%@", error.localizedDescription);
        return;
    }

    AVCaptureDeviceInput *audiocaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audiocaptureDevice error:&error];
    if (error)
    {
        NSLog(@"获取音频输入对象失败，error:%@", error.localizedDescription);
        return;
    }

    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput])
    {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audiocaptureDeviceInput];
    }

    [self _initDataOutput];
}

- (void)_changeCamera:(AVCaptureDeviceInput *)toChangeDeviceInput
{
    [self.captureSession beginConfiguration];
    [self.captureSession removeInput:self.captureDeviceInput];
    if ([self.captureSession canAddInput:toChangeDeviceInput])
    {
        [self.captureSession addInput:toChangeDeviceInput];
        self.captureDeviceInput = toChangeDeviceInput;
    }
    [self.captureSession commitConfiguration];
}

//获得指定位置的摄像头
- (AVCaptureDevice *)_getCameraDeviceWithPositon:(AVCaptureDevicePosition)positon
{
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in cameras)
    {
        if (device.position == positon)
        {
            return device;
        }
    }
    return nil;
}

- (void)_changeDeviceProperty:(PropertyChangeBlock)propertyChange
{
    AVCaptureDevice *captureDevice = [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error])
    {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }
    else
    {
        NSLog(@"设置设备属性过程发生错误，错误信息：%@", error.localizedDescription);
    }
}

- (AVCaptureConnection *)videoConnection
{
    return [_videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
}
- (AVCaptureConnection *)audioConnection
{
    return [_audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
}
- (AVAssetWriterInput *)videoInput
{
    if (_videoInput)
    {
        return _videoInput;
    }
    NSInteger numPixels = _targetSize.width * _targetSize.height;
    //每像素比特
    CGFloat bitsPerPixel = 4.05;
    NSInteger bitsPerSecond = numPixels * bitsPerPixel;

    //码率和帧率设置
    NSDictionary *compressionProperties = @{ AVVideoAverageBitRateKey : @(bitsPerSecond), AVVideoExpectedSourceFrameRateKey : @(20), AVVideoMaxKeyFrameIntervalKey : @(30) };
    NSDictionary *videoOutputSetting = @{
        AVVideoCodecKey : AVVideoCodecH264,
        AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
        AVVideoWidthKey : @(_targetSize.height),
        AVVideoHeightKey : @(_targetSize.width),
        AVVideoCompressionPropertiesKey : compressionProperties
    };
    _videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoOutputSetting];
    _videoInput.expectsMediaDataInRealTime = YES;
    _videoInput.transform = CGAffineTransformMakeRotation(M_PI_2);
    return _videoInput;
}

- (AVAssetWriterInput *)audioInput
{
    if (_audioInput)
    {
        return _audioInput;
    }
    NSDictionary *audioOutputSetting = [_audioDataOutput recommendedAudioSettingsForAssetWriterWithOutputFileType:AVFileTypeCoreAudioFormat];
    _audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioOutputSetting];
    _audioInput.expectsMediaDataInRealTime = YES;
    return _audioInput;
}

- (void)_initDataOutput
{
    _videoDataOutputQueue = dispatch_queue_create("com.niannian.videodata", DISPATCH_QUEUE_SERIAL);
    _audioDataOutputQueue = dispatch_queue_create("com.niannian.audiodata", DISPATCH_QUEUE_SERIAL);

    _videoDataOutput = [AVCaptureVideoDataOutput new];
    _videoDataOutput.videoSettings = nil;
    _videoDataOutput.alwaysDiscardsLateVideoFrames = NO;
    [_videoDataOutput setSampleBufferDelegate:self queue:_videoDataOutputQueue];
    if ([_captureSession canAddOutput:_videoDataOutput])
    {
        [_captureSession addOutput:_videoDataOutput];
    }
    _audioDataOutput = [AVCaptureAudioDataOutput new];
    [_audioDataOutput setSampleBufferDelegate:self queue:_audioDataOutputQueue];
    if ([_captureSession canAddOutput:_audioDataOutput])
    {
        [_captureSession addOutput:_audioDataOutput];
    }

    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    [self.stillImageOutput setOutputSettings:outputSettings];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    if ([self.captureSession canAddOutput:self.stillImageOutput] && ![self.captureSession.inputs containsObject:self.stillImageOutput])
    {
        [self.captureSession addOutput:self.stillImageOutput];
    }
#pragma clang diagnostic pop
}
@end

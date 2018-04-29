//
//  NNImageEditObject.m
//  NNLetter
//
//  Created by gavin.tangwei on 2017/8/15.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNImageEditObject.h"
#import <TOCropViewController/TOCropViewController.h>
#import "NSString+Common.h"

@interface NNImageEditObject () <TOCropViewControllerDelegate>
@property (nonatomic, strong) UIImage *orgImage;
@property (nonatomic, copy) NNImageEditCompleteBlock completeBlock;

@end

@implementation NNImageEditObject

+ (void)gotoEditImageWithImage:(UIImage *)aImage from:(UIViewController *)from complete:(NNImageEditCompleteBlock)blk
{
    static NNImageEditObject *obj = nil;
    obj = [[self alloc] init];
    [obj gotoEditImageWithImage:aImage from:from complete:blk];
}

+ (void)gotoEditChatRoomImageWithImage:(UIImage *)aImage from:(UIViewController *)from complete:(NNImageEditCompleteBlock)blk
{
    static NNImageEditObject *obj = nil;
    obj = [[self alloc] init];
    [obj gotoChatRoomEditImageWithImage:aImage from:from complete:blk];
}

- (void)gotoEditImageWithImage:(UIImage *)aImage from:(UIViewController *)from complete:(NNImageEditCompleteBlock)blk
{
    self.orgImage = aImage;
    self.completeBlock = blk;

    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:aImage];
    cropController.delegate = self;
    cropController.aspectRatioPickerButtonHidden = NO;
    cropController.toolbar.backgroundColor = [UIColor whiteColor];
    [cropController.toolbar.doneTextButton setTitleColor:[NSString colorWithHexString:@"69BF30"] forState:UIControlStateNormal];
    [cropController.toolbar.cancelTextButton setTitle:@"" forState:UIControlStateNormal];
    [cropController.toolbar.cancelTextButton setTintColor:[NSString colorWithHexString:@"3B3635"]];
    [cropController.toolbar.cancelTextButton setImage:[UIImage imageNamed:@"ic_camera_edit_back"] forState:UIControlStateNormal];

    [cropController.toolbar.resetButton setImage:[UIImage imageNamed:@"ic_camera_edit_reset_n"] forState:UIControlStateDisabled];
    [cropController.toolbar.resetButton setImage:[UIImage imageNamed:@"ic_camera_edit_reset_h"] forState:UIControlStateNormal];
    [cropController.toolbar.resetButton setTintColor:[NSString colorWithHexString:@"3B3635"]];

    [cropController.toolbar.rotateButton setImage:[UIImage imageNamed:@"ic_camera_edit_roate_h"] forState:UIControlStateNormal];
    [cropController.toolbar.rotateButton setTintColor:[NSString colorWithHexString:@"3B3635"]];
    cropController.toolbar.clampButton.hidden = true;
//    [cropController.toolbar.clampButton setTintColor:[UIColor colorWithHexString:@"3B3635"]];
//    [cropController.toolbar.clampButton setImage:[UIImage imageNamed:@"ic_clamp_edit"] forState:UIControlStateNormal];
   

    [from presentViewController:cropController animated:YES completion:nil];
}

- (void)gotoChatRoomEditImageWithImage:(UIImage *)aImage from:(UIViewController *)from complete:(NNImageEditCompleteBlock)blk
{
    self.orgImage = aImage;
    self.completeBlock = blk;
    
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:aImage];
    cropController.delegate = self;
    cropController.aspectRatioPickerButtonHidden = NO;
    cropController.customAspectRatio = CGSizeMake(2.f, 1.f);
    cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetCustom;
    cropController.toolbar.backgroundColor = [UIColor whiteColor];
    [cropController.toolbar.doneTextButton setTitleColor:[NSString colorWithHexString:@"69BF30"] forState:UIControlStateNormal];
    [cropController.toolbar.cancelTextButton setTitle:@"" forState:UIControlStateNormal];
    [cropController.toolbar.cancelTextButton setTintColor:[NSString colorWithHexString:@"3B3635"]];
    [cropController.toolbar.cancelTextButton setImage:[UIImage imageNamed:@"ic_camera_edit_back"] forState:UIControlStateNormal];
    
    [cropController.toolbar.resetButton setImage:[UIImage imageNamed:@"ic_camera_edit_reset_n"] forState:UIControlStateDisabled];
    [cropController.toolbar.resetButton setImage:[UIImage imageNamed:@"ic_camera_edit_reset_h"] forState:UIControlStateNormal];
    [cropController.toolbar.resetButton setTintColor:[NSString colorWithHexString:@"3B3635"]];
    
    [cropController.toolbar.rotateButton setImage:[UIImage imageNamed:@"ic_camera_edit_roate_h"] forState:UIControlStateNormal];
    [cropController.toolbar.rotateButton setTintColor:[NSString colorWithHexString:@"3B3635"]];
    cropController.toolbar.clampButton.hidden = true;

    [from presentViewController:cropController animated:YES completion:nil];
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didCropToImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissViewControllerAnimated:YES
                                           completion:^{
                                             if (self.completeBlock)
                                             {
                                                 self.completeBlock(image);
                                             }
                                           }];
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled
{
    
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didCropToCircularImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
}

@end

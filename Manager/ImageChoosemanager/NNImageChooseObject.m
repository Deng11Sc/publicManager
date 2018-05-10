//
//  NNImageChooseObject.m
//  NNLetter
//
//  Created by gavin.tangwei on 2017/8/23.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNImageChooseObject.h"
#import "TZImagePickerController.h"

@interface NNImageChooseObject ()

@property (nonatomic, copy) NNImageChooseCompleteBlock completeBlock;

@end

@implementation NNImageChooseObject

+ (void)gotoChooseImageFrom:(UIViewController  *)from complete:(NNImageChooseCompleteBlock)blk {
    static NNImageChooseObject *obj = nil;
    obj = [[self alloc] init];
    [obj gotoChooseImageFrom:from complete:blk];
}
- (void)gotoChooseImageFrom:(UIViewController  *)from complete:(NNImageChooseCompleteBlock)blk {
    self.completeBlock = blk;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
//    imagePickerVc.naviBgColor = NavigationBarBgColor;
//    imagePickerVc.naviTitleColor = NavigationBarTextColor;
//    imagePickerVc.naviTitleFont = NavigationBarTextFont;
//    imagePickerVc.barItemTextColor = mainColor;
//    imagePickerVc.barItemTextFont = NavigationBarTextFont;
//    imagePickerVc.oKButtonTitleColorNormal = mainColor;
    
    imagePickerVc.isStatusBarDefault = YES;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.didFinishPickingPhotosHandle = blk;
    [from presentViewController:imagePickerVc animated:YES completion:nil];
}

+ (void)gotoChooseImageFrom:(UIViewController  *)from maxCount:(NSInteger)maxCount complete:(NNImageChooseCompleteBlock)blk {
    static NNImageChooseObject *obj = nil;
    obj = [[self alloc] init];
    [obj gotoChooseImageFrom:from maxCount:maxCount complete:blk];
}
- (void)gotoChooseImageFrom:(UIViewController  *)from maxCount:(NSInteger)maxCount complete:(NNImageChooseCompleteBlock)blk {
    self.completeBlock = blk;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    //    imagePickerVc.naviBgColor = NavigationBarBgColor;
    //    imagePickerVc.naviTitleColor = NavigationBarTextColor;
    //    imagePickerVc.naviTitleFont = NavigationBarTextFont;
    //    imagePickerVc.barItemTextColor = mainColor;
    //    imagePickerVc.barItemTextFont = NavigationBarTextFont;
    //    imagePickerVc.oKButtonTitleColorNormal = mainColor;
    
    imagePickerVc.isStatusBarDefault = YES;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.didFinishPickingPhotosHandle = blk;
    [from presentViewController:imagePickerVc animated:YES completion:nil];
}





@end

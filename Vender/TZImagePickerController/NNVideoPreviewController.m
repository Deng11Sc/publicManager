//
//  NNMediaPreviewController.m
//  NNLetter
//
//  Created by gavin.tangwei on 2017/8/17.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNVideoPreviewController.h"
#import "NNShortPlayerView.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "NSString+Common.h"

@interface NNVideoPreviewController ()
@property (nonatomic, strong) NNShortPlayerView *playerView;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation NNVideoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _playerView = [[NNShortPlayerView alloc] initWithFrame:CGRectMake(0, 0, CC_Width,CC_Height)];
    [self.view addSubview:_playerView];
    if (self.playerItem) {
        _playerView.playerItem = self.playerItem;
    }
    else {
        _playerView.URL = self.urlPath;
    }
    
    _bottomView = [UIView new];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@70);
    }];
    _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    UIButton *cancle = [UIButton new];
    [_bottomView addSubview:cancle];
    [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(_bottomView);
        make.left.equalTo(@(0));
        make.width.equalTo(@120);
    }];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(actionCancle) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureButton = [UIButton new];
    [_bottomView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(_bottomView);
        make.right.equalTo(@(0));
        make.width.equalTo(@120);
    }];
    [sureButton setTitle:@"选取" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(actionSure) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *play = [UIButton new];
    [_bottomView addSubview:play];
    [play mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_bottomView);
        make.width.equalTo(@120);
        make.center.equalTo(_bottomView);
    }];
    [play setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [play setImage:[UIImage imageNamed:@"ic_video_play"] forState:UIControlStateNormal];
    [play setImage:[UIImage imageNamed:@"ic_video_pause"] forState:UIControlStateSelected];
    [play addTarget:self action:@selector(actionPlay:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)actionPlay:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        [_playerView play];
    }
    else {
        [_playerView pause];
    }
}

- (void)actionSure {
    
    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
    if ([imagePickerVc isKindOfClass:[TZImagePickerController class]]) {
        UIImage *image = [NNShortPlayerView thumbnailImageWithURL:self.urlPath];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
//            if ([imagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingVideo:sourceAssets:)]) {
//                [imagePickerVc.pickerDelegate imagePickerController:imagePickerVc didFinishPickingVideo:image sourceAssets:self.asset];
//            }
            if (imagePickerVc.didFinishPickingVideoHandle) {
                imagePickerVc.didFinishPickingVideoHandle(image,self.asset);
            }
        }];
        return;
    }
    
    if (self.urlPath) {
        if (self.actionBlock) {
            self.actionBlock(self.urlPath);
        }
    }
    else
    {
        [[TZImageManager manager] getVideoOutputPathWithAsset:self.playerItem.asset completion:^(NSString *outputPath) {
            [self outputPathWithLocalString:outputPath];
        }];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)outputPathWithLocalString:(NSString *)outputPath{
    if (![NSString isEmptyString:outputPath]) {
        NSURL *outURL = [NSURL fileURLWithPath:outputPath];
        if (self.actionBlock) {
            self.actionBlock(outURL);
        }
    }
    else
    {
        if (self.actionBlock) {
            self.actionBlock(nil);
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:true];
    [self.navigationController.navigationBar setHidden:true];
    [_playerView pause];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false];
    [self.navigationController.navigationBar setHidden:false];
}

- (void)actionCancle {
    [_playerView pause];
    
    
    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
    if ([imagePickerVc isKindOfClass:[TZImagePickerController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^ {
        if (self.actionBlock) {
            self.actionBlock(nil);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

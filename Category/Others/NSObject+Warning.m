//
//  NSObject+Warning.m
//  NNLetter
//
//  Created by niannian on 17/5/17.
//  Copyright © 2017年 niannian. All rights reserved.
//

#import "NSObject+Warning.h"

@implementation NSObject(Warning)
static UIView *_warningView = nil;
+(UIView *)shareWarningView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _warningView = [[UIView alloc] init];
        _warningView.frame = CGRectMake(0, 0, CC_Width, 64);
        _warningView.backgroundColor = CC_CustomColor_FA5252;
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.frame = CGRectMake(20, 20 , 24, 24);
        icon.image = [UIImage imageNamed:@"emoticons_2s"];
        [_warningView addSubview:icon];
    
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(icon.right+5, 10, CC_Width - icon.right - 30, 44);
        label.numberOfLines = 2;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.tag = 10;
        [_warningView addSubview:label];
        
    });
    return _warningView;
}

+ (void)showError:(NSString *)desprition {
    static int i = 0;
    
    if (i > 0) {
        return;
    }
    
    UILabel *label = [[self shareWarningView] viewWithTag:10];
    label.text = desprition;
    i ++;
    [[self shareWarningView] removeFromSuperview];
    [self shareWarningView].frame = CGRectMake(0, -64, CC_Width, 64);
    
    UIWindow *window = CC_KeyWindow;
    window.windowLevel = UIWindowLevelStatusBar + 1.0;
    window.hidden = NO;
    window.autoresizesSubviews = YES;
    [window addSubview:_warningView];
    
    [UIView animateWithDuration:0.35 animations:^{
        [self shareWarningView].frame = CGRectMake(0, 0, CC_Width, 64);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.35 delay:2 options:UIViewAnimationOptionTransitionNone animations:^{
            [self shareWarningView].frame = CGRectMake(0, -64, CC_Width, 64);
            
        } completion:^(BOOL finished) {
            i = 0;
            window.windowLevel = UIWindowLevelNormal;
            [window makeKeyAndVisible];
        }];
        
    }];
    
}


static UILabel *_shareTip = nil;
+(UILabel *)shareTip {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 2;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.clipsToBounds = YES;
        [label.layer setCornerRadius:2];
        label.backgroundColor = CC_CustomColor_FA5252;
        _shareTip = label;
        
    });
    return _shareTip;
}


static BOOL _isShow = YES;
+(void)showMessage:(NSString *)tip
{
    if (_isShow == NO) {
        return;
    }
    
    _isShow = NO;
    UILabel *tipLabel = [self shareTip];
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.backgroundColor = kUIColorFromRGB_Alpa(0x535353, 0.8);
    tipLabel.text = tip;
    [CC_KeyWindow addSubview:tipLabel];
    
    CGSize size = [tipLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 24)];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(CC_KeyWindow);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(size.width+16);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideTip];
    });
    
    
}

+(void)hideTip
{
    _isShow = YES;
    
    UILabel *tipLabel = [self shareTip];
    [tipLabel removeFromSuperview];
}



+(void)showTorast:(NSString *)torast
{
    if (_isShow == NO) {
        return;
    }
    
    _isShow = NO;
    UILabel *tipLabel = [self shareTip];
    tipLabel.text = torast;
    [CC_KeyWindow addSubview:tipLabel];
    
    CGSize size = [tipLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 24)];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(CC_KeyWindow);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(size.width+16);
    }];
}



@end

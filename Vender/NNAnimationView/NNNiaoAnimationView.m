//
//  NNNiaoAnimationView.m
//  NNLetter
//
//  Created by 谭祥永 on 2016/10/13.
//  Copyright © 2016年 fengxiaofeng. All rights reserved.
//

#import "NNNiaoAnimationView.h"

#define TimeInterval 0.04

@interface NNNiaoAnimationView()

@property (nonatomic, strong) UILabel *promptLabel;//主标题 ，提示文字

@property (nonatomic, strong) UILabel *subtitleLabel;//子标题 ，说明文字

@end

@implementation NNNiaoAnimationView{
    UIVisualEffectView *coverView;                                //小鸟蒙板
    UIImageView *fszAnimationView;
    UIImageView *birdView;
    
    UIView *background_View;
    NSTimer *timer;
    double currentTime;
    BOOL showResultAnimation; //默认显示，回掉结果后，的动画
}

-(instancetype)init
{
    self = [super initWithFrame:CC_KeyWindow.bounds];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _maxAnimationDuration = 2;
        _sendDelayDuration = 2;
        showResultAnimation = YES;
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        coverView = [[UIVisualEffectView alloc] initWithEffect:blur];
        coverView.frame = self.bounds;
        [self addSubview:coverView];
        
        
        
        CGFloat background_ViewW = 260;
        CGFloat background_ViewH = 174;
        CGFloat background_ViewX = self.center.x - background_ViewW / 2;
        CGFloat background_ViewY = self.center.y - background_ViewH / 2;
        
        background_View = [[UIView alloc] init];
        background_View.frame = CGRectMake(background_ViewX, background_ViewY, background_ViewW, background_ViewH);
        background_View.clipsToBounds = YES;
        background_View.layer.cornerRadius = 10;
        background_View.backgroundColor = [UIColor whiteColor];
        [self addSubview:background_View];
        
        //动画视图
        UIImage *cicleImage = [UIImage imageNamed:@"animation_cicle"];
        CGFloat fszAnimationViewW  = 64;
        CGFloat fszAnimationViewH  = 64;
        CGFloat fszAnimationViewY  = 30;
        CGFloat fszAnimationViewX  = background_ViewW / 2 -  fszAnimationViewW/ 2;
        fszAnimationView = [[UIImageView alloc]initWithFrame:CGRectMake(fszAnimationViewX, fszAnimationViewY, fszAnimationViewW, fszAnimationViewH)];
        fszAnimationView.image = cicleImage;
        [background_View addSubview:fszAnimationView];
        
        //小鸟视图
        UIImage *birdImage = [UIImage imageNamed:@"animation_bird"];
        CGFloat birdViewW  = 38;
        CGFloat birdViewH  = 38;
        CGFloat birdViewY  = 43;
        CGFloat birdViewX  = background_ViewW / 2 -  birdViewW/ 2;
        birdView = [[UIImageView alloc]initWithFrame:CGRectMake(birdViewX, birdViewY, birdViewW, birdViewH)];
        birdView.image = birdImage;
        [background_View addSubview:birdView];
        
        // 主标题
        self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(fszAnimationView.frame) + 20, background_ViewW -2*20, 20)];
        
        self.promptLabel.textAlignment = NSTextAlignmentCenter;
        self.promptLabel.font = [UIFont systemFontOfSize:16];
        self.promptLabel.textColor = CC_CustomColor_3A3534;
        
        [background_View addSubview:self.promptLabel];
        
        //副标题
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.promptLabel.frame) + 5, background_ViewW -2*20, 20)];
        self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subtitleLabel.font = [UIFont systemFontOfSize:15];
        self.subtitleLabel.textColor = kUIColorFromRGB(0x666666);
        self.subtitleLabel.hidden = YES;
        
        [background_View addSubview:self.subtitleLabel];
        
    }
    
    return  self;
}

-(void)showAnimationView:(BOOL)animation
{
    showResultAnimation = animation;
    
    [CC_KeyWindow addSubview:self];

    self.promptLabel.text = self.mainTitle;
    
        timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval target:self selector:@selector(fszAnimationViewAnimatiing) userInfo:nil repeats:YES];
        currentTime = 0.0;
    
}

- (void)setMainTitle:(NSString *)mainTitle {
    _mainTitle = mainTitle;
    self.promptLabel.text = mainTitle;
    
}

- (void)hideNiaoAnimationView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1.0f;
    }];
}

-(void)setSendXinJianType:(NNSendXinJianType)SendXinJianType
{
    _SendXinJianType = SendXinJianType;
    
    if (SendXinJianType ==  TextDistinguishType) {
        coverView.hidden = YES;
        self.userInteractionEnabled = NO;
    } else {
        coverView.hidden = NO;
        self.userInteractionEnabled = YES;
        
    }
}

//
//if (self.SendXinJianType == SendXinJianSuccess) {
//    birdView.image = [UIImage imageNamed:@"animation_gou"];
//    self.promptLabel.text = self.mainTitle;
//    self.subtitleLabel.text = self.SubTitle;
//    self.subtitleLabel.hidden = NO;
//}else if (self.SendXinJianType == SendXinJianFailure) {
//    
//    birdView.image = [UIImage imageNamed:@"animation_cha"];
//    self.promptLabel.text = self.mainTitle;
//    self.subtitleLabel.text = self.SubTitle;
//    self.subtitleLabel.hidden = NO;
//}
//
//
//[self performSelector:@selector(removeSelfData) withObject:nil afterDelay:self.sendDelayDuration];
//
//if (self.sendDelayDuration >0.5) {
//    [self resultAnimation];
//}

-(void)fszAnimationViewAnimatiing
{
    currentTime += TimeInterval;
    
    [self xinJianFaSongZhongViewHidden];
    
    [UIView animateWithDuration:TimeInterval animations:^{
        
        fszAnimationView.transform = CGAffineTransformRotate(fszAnimationView.transform, M_PI *0.1);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)xinJianFaSongZhongViewHidden
{
    
    
    
    
    if (currentTime >= _maxAnimationDuration & _SendXinJianType == SendXinJianSuccess) {
        
        [timer invalidate];
        timer = nil;
        //发送成功
        
        
        
        
        if (showResultAnimation)
        {
            
            fszAnimationView.transform = CGAffineTransformMakeRotation(0);
            birdView.image = [UIImage imageNamed:@"animation_gou"];
            self.promptLabel.text = self.mainTitle;
            self.subtitleLabel.text = self.SubTitle;
            self.subtitleLabel.hidden = NO;
            
            [self performSelector:@selector(removeSelfData) withObject:nil afterDelay:self.sendDelayDuration];
            
            if (self.sendDelayDuration >0.5)
            {
                [self resultAnimation];
            }
        }else
        {
            [self removeSelfData];
        }
        
       
        
       
        
        
        
        
    }else if (currentTime >= _maxAnimationDuration & _SendXinJianType == SendXinJianFailure)
    {
        [timer invalidate];
        timer = nil;
        //发送失败
        NSLog(@">>>>>>>>>发送失败<<<<<<<<");
        
        
        if (showResultAnimation) {
            
            fszAnimationView.transform = CGAffineTransformMakeRotation(0);
            
            self.promptLabel.text = self.mainTitle;
            self.subtitleLabel.text = self.SubTitle;
            self.subtitleLabel.hidden = NO;
            birdView.image = [UIImage imageNamed:@"animation_cha"];
            
            [self performSelector:@selector(removeSelfData) withObject:nil afterDelay:self.sendDelayDuration];
            
            if (self.sendDelayDuration >0.5) {
                [self resultAnimation];
            }

        }else
        {
            [self removeSelfData];
        }

        
        
        
        
        
    }
    
    
}

-(void)resultAnimation
{
    __weak typeof(self) weakSelf = self;
    __weak typeof(birdView) weakBirdView = birdView;
    
    birdView.alpha = 0.1;
    self.promptLabel.alpha = 0.1;
    self.subtitleLabel.alpha = 0.1;
    birdView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.5 animations:^{
        birdView.transform = CGAffineTransformIdentity;
        
        weakBirdView.alpha = 1.0;
        weakSelf.promptLabel.alpha = 1.0;
        weakSelf.subtitleLabel.alpha = 1.0;
    }];
    
}

-(void)removeSelfData
{
    
    if (_NiaoAnimationViewClosedNormal) {
        
        if (self.SendXinJianType == SendXinJianSuccess) {
            _NiaoAnimationViewClosedNormal(YES);
        }else
        {
            _NiaoAnimationViewClosedNormal(NO);
        }
        
    }
    
    [self removeFromSuperview];
    currentTime = 0.0;
}


@end

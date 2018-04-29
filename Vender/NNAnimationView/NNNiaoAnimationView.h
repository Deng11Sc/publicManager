//
//  NNNiaoAnimationView.h
//  NNLetter
//
//  Created by 谭祥永 on 2016/10/13.
//  Copyright © 2016年 fengxiaofeng. All rights reserved.
//

typedef enum : NSUInteger {
    
    SendXinJianDefualt,
    SendXinJianSuccess,
    SendXinJianFailure,
    TextDistinguishType
    
} NNSendXinJianType;


#import <UIKit/UIKit.h>

@interface NNNiaoAnimationView : UIView

@property (nonatomic, assign) NNSendXinJianType SendXinJianType;


@property (nonatomic, copy) NSString *mainTitle;
@property (nonatomic, copy) NSString *SubTitle;


@property (nonatomic, assign) CGFloat maxAnimationDuration;//最大动画时间，默认2 s

@property (nonatomic, assign) CGFloat sendDelayDuration;//发送成功后，默认，延迟时间 移除视图， 默认2 s

@property (nonatomic, copy) void(^NiaoAnimationViewClosedNormal)(BOOL ClosedNormal);

-(void)showAnimationView:(BOOL)animation;

- (void)hideNiaoAnimationView;
@end

//
//  CCThridLoginView.m
//  NearbyTask
//
//  Created by SongChang on 2018/5/7.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCThridLoginView.h"
#import <UMShare/UMShare.h>
#import "CCShareManager.h"

@interface CCThridLoginView ()

@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;

@end

@implementation CCThridLoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kUIColorFromRGB_Alpa(0x000000, 0.4);
        [self dy_addSubviews];
    }
    return self;
}

-(void)dy_addSubviews {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.contentMode = UIViewContentModeScaleAspectFill;
    [leftBtn addTarget:self action:@selector(dy_btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.contentMode = UIViewContentModeScaleAspectFill;
    [rightBtn addTarget:self action:@selector(dy_btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setTitle:@"More third-party logins will be added" forState:0];
    moreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:moreBtn];
    
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(30);
//        make.width.mas_equalTo(100);
        make.bottom.equalTo(self);
    }];
    
    
    UIButton *midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    midBtn.contentMode = UIViewContentModeScaleAspectFill;
    [midBtn addTarget:self action:@selector(dy_btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:midBtn];

    if ([NSString isHans]) {
        leftBtn.tag = UMSocialPlatformType_WechatSession;
        [leftBtn setImage:[UIImage imageNamed:@"third_wechat"] forState:0];
        
        midBtn.tag = UMSocialPlatformType_QQ;
        [midBtn setImage:[UIImage imageNamed:@"third_qq"] forState:0];
        
        BOOL isShowWechat = [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession];
        BOOL isShowQQ = [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ];
        NSMutableArray *arr = [NSMutableArray new];
        if (isShowWechat) {
            [arr addObject:leftBtn];
        }
        if (isShowQQ) {
            [arr addObject:midBtn];
        }
        if (arr.count == 1) {
            UIButton *btn = arr.firstObject;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(moreBtn.mas_top);
                make.centerX.equalTo(self);
                make.height.mas_equalTo(leftBtn.imageView.image.size.height);
                make.width.mas_equalTo(leftBtn.imageView.image.size.width);
            }];
        } else if (arr.count == 2) {
            UIButton *btn1 = arr.firstObject;
            UIButton *btn2 = arr.lastObject;
            
            [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(moreBtn.mas_top);
                make.right.equalTo(self.mas_centerX);
                make.height.mas_equalTo(btn1.imageView.image.size.height);
                make.width.mas_equalTo(btn1.imageView.image.size.width);
            }];
            [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(moreBtn.mas_top);
                make.left.equalTo(self.mas_centerX);
                make.height.mas_equalTo(btn2.imageView.image.size.height);
                make.width.mas_equalTo(btn2.imageView.image.size.width);
            }];
        }
        
    } else {
        leftBtn.tag = UMSocialPlatformType_Facebook;
        [leftBtn setImage:[UIImage imageNamed:@"third_facebook"] forState:0];
        
        midBtn.tag = UMSocialPlatformType_WechatSession;
        [midBtn setImage:[UIImage imageNamed:@"third_wechat"] forState:0];

        BOOL isShowWeChat = [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession];
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(moreBtn.mas_top);
            if (isShowWeChat) {
                make.right.equalTo(self.mas_centerX);
            } else {
                make.centerX.equalTo(self.mas_centerX);
            }
            
            make.height.mas_equalTo(leftBtn.imageView.image.size.height);
            make.width.mas_equalTo(leftBtn.imageView.image.size.width);
        }];
        
        if (!isShowWeChat) {
            rightBtn.hidden = YES;
        }
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(moreBtn.mas_top);
            make.left.equalTo(self.mas_centerX);
            make.height.mas_equalTo(rightBtn.imageView.image.size.height);
            make.width.mas_equalTo(rightBtn.imageView.image.size.width);
        }];

    }
    
}


- (void)dy_btnClick:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.weakController.view animated:YES];

    CCShareManager *manager = [[CCShareManager alloc] initWithCurrentController:self.weakController];
    [manager getUserInfoForPlatform:sender.tag successful:^(CCThirdModel *thirdModel) {
        NSLog(@"%@",thirdModel.name);
        
        if (thirdModel) {
            //获取三方成功
            CCUserInfoModel *userModel = [[CCUserInfoModel alloc] init];
            userModel.userSex = [thirdModel.unionGender isEqualToString:@"男"]?@"0":@"1";
            userModel.imageUrl = thirdModel.iconurl;
            userModel.email = nil;
            //显示的名称
            userModel.nickName = thirdModel.name;
            //记录用户名
            userModel.userName = thirdModel.openid;
            CCLoginRequest *request = [[CCLoginRequest alloc] initRegistWithUserName:thirdModel.openid
                                                                              password:thirdModel.uid
                                                                         UserInfoModel:userModel];
            request.successful = ^(NSMutableArray *array, NSInteger code, id json) {
                [MBProgressHUD hideHUDForView:self.weakController.view animated:YES];
                
                if (self.thridLoginSuccessBlock) {
                    self.thridLoginSuccessBlock(thirdModel.openid,thirdModel.uid);
                }
                
            };
            request.failure = ^(NSString *error, NSInteger code) {
                [MBProgressHUD hideHUDForView:self.weakController.view animated:YES];
                
                if (code == 202) {
                    if (self.thridLoginSuccessBlock) {
                        self.thridLoginSuccessBlock(thirdModel.openid,thirdModel.uid);
                    }
                } else {
                    [NSObject showMessage:DYLocalizedString(@"Register failure", @"注册失败")];
                }
            };
            [request registRequest];
            
            
            
        } else {
            //失败
            [NSObject showMessage:DYLocalizedString(@"Authorization failed", @"授权失败")];
            [MBProgressHUD hideHUDForView:self.weakController.view animated:YES];
        }
        
    }];
}


@end

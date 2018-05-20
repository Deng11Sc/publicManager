//
//  CCInputLoginView.m
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCInputLoginView.h"

@interface CCInputLoginView ()

@end

@implementation CCInputLoginView


+ (CGFloat)height {
    return 8+35+12+35+8;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self.layer setCornerRadius:8];
        [self dy_initSubviews];
    }
    return self;
}


-(void)dy_initSubviews {
    CCInputTextField *tf1 = [[CCInputTextField alloc] init];
    tf1.placeholder = DYLocalizedString(@"Please enter account number", @"请输入账号");
    tf1.secureTextEntry = NO;
    tf1.backgroundColor = [UIColor clearColor];
    [tf1.layer setCornerRadius:4];
    tf1.clipsToBounds = YES;
    [self addSubview:tf1];
    _tf1 = tf1;
    
    [tf1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.top.equalTo(@8);
        make.height.equalTo(@35);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = CC_CustomColor_F5F4F3;
    [self addSubview:lineView];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
        make.top.equalTo(tf1.mas_bottom).offset(6);
        make.height.equalTo(@0.5);
    }];
    
    CCInputTextField *tf2 = [[CCInputTextField alloc] init];
    tf2.placeholder = DYLocalizedString(@"Please enter the password", @"请输入密码");
    tf2.secureTextEntry = YES;
    tf2.backgroundColor = [UIColor clearColor];
    [tf2.layer setCornerRadius:4];
    tf2.clipsToBounds = YES;
    [self addSubview:tf2];
    _tf2 = tf2;
    
    [tf2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.top.equalTo(tf1.mas_bottom).offset(12);
        make.height.equalTo(@35);
    }];

    
}

-(void)endEdit {
    [self.tf1 endEditing:YES];
    [self.tf2 endEditing:YES];
}

@end

//
//  CCRegistController.m
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCRegistController.h"

#import "CCInputLoginView.h"

#import "CCLoginRequest.h"

@interface CCRegistController ()

@property (nonatomic,strong)CCInputLoginView *loginView;

@property (nonatomic,strong)UIImageView *baseView;

///注册时的返回按钮
@property (nonatomic,strong)UIButton *backBtn;


@end

@implementation CCRegistController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYLocalizedString(@"Regist", @"注册");

    [self dy_initSubviews];
}

-(void)dy_initSubviews {
    
    UIImageView *baseView = [[UIImageView alloc] init];
    baseView.userInteractionEnabled = YES;
    baseView.contentMode = UIViewContentModeScaleAspectFill;
    baseView.image = [UIImage imageNamed:@"backImage_regist"];
    baseView.backgroundColor = [UIColor blueColor];
    baseView.clipsToBounds = YES;
    [self.view addSubview:baseView];
    _baseView = baseView;
    
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    CCInputLoginView *loginView = [[CCInputLoginView alloc] init];
    loginView.backgroundColor =kUIColorFromRGB_Alpa(0xFFFFFF, 0.8);
    [self.view addSubview:loginView];
    _loginView = loginView;
    
    loginView.tf1.placeholder = DYLocalizedString(@"Please enter new account number", @"请输入新账号");
    
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).multipliedBy(0.8);
        make.left.equalTo(self.view).offset(12);
        make.height.mas_equalTo([CCInputLoginView height]);
    }];
    
    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [trueBtn cc_configure];
    trueBtn.backgroundColor =kUIColorFromRGB_Alpa(0xFFFFFF, 0.8);
    [trueBtn.layer setCornerRadius:4];
    trueBtn.clipsToBounds = YES;
    [trueBtn setTitle:DYLocalizedString(@"Create an account", @"创建新账号") forState:0];
    [trueBtn setTitleColor:kUIColorFromRGB(0x2089ff) forState:0];
    [trueBtn addTarget:self action:@selector(registServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trueBtn];
    
    [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loginView);
        make.width.equalTo(_baseView).multipliedBy(0.66);
        make.top.equalTo(loginView.mas_bottom).offset(12);
        make.height.equalTo(@35);
    }];
    
    ///退出按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"nav_normal_back"] forState:UIControlStateNormal];
    cancelBtn.contentMode = UIViewContentModeScaleAspectFit;
    [cancelBtn addTarget:self action:@selector(dy_actionBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(20);
    }];

}

- (void)registServer {
    [self.loginView endEdit];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CCUserInfoModel *userModel = [[CCUserInfoModel alloc] init];
    userModel.userSex = @"1";
    userModel.imageUrl = [NSString randomHeaderImageUrl];
    userModel.email = nil;
    CCLoginRequest *request = [[CCLoginRequest alloc] initRegistWithUserName:self.loginView.tf1.text password:self.loginView.tf2.text UserInfoModel:userModel];
    request.successful = ^(NSMutableArray *array, NSInteger code, id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [NSObject showMessage:DYLocalizedString(@"Succeeded", @"注册成功")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dy_actionBack];
        });
    };
    request.failure = ^(NSString *error, NSInteger code) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // 失败的原因可能有多种，常见的是用户名已经存在。
        [NSObject showMessage:DYLocalizedString(@"Register failure", @"注册失败")];

    };
    [request registRequest];
    
}

@end

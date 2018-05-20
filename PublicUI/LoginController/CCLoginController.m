//
//  CCLoginController.m
//  MerryS
//
//  Created by SongChang on 2018/1/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCLoginController.h"
#import "CCRegistController.h"

#import "CCInputLoginView.h"

#import "CCThridLoginView.h"

#import "CCLoginRequest.h"

/*
 用户名错误 202
 手机号码错误 214
 邮箱错误 203
 */

@interface CCLoginController ()

@property (nonatomic,strong)CCInputLoginView *loginView;
@property (nonatomic,strong)CCThridLoginView *thirdView;

@property (nonatomic,strong)UIImageView *baseView;

@property (nonatomic,strong)UIButton *trueBtn;
@property (nonatomic,strong)UIButton *registBtn;
///注册时的返回按钮
@property (nonatomic,strong)UIButton *backBtn;


@property (nonatomic,strong)NSString *user;
@property (nonatomic,strong)NSString *password;

@end

@implementation CCLoginController

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.modalPresentationStyle = UIModalPresentationCustom;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor clearColor];
    self.title = DYLocalizedString(@"Login", @"登陆");
    
    [self dy_initSubviews];
    
}

-(void)dy_initSubviews {
    
    UIImageView *baseView = [[UIImageView alloc] init];
    baseView.userInteractionEnabled = YES;
    baseView.contentMode = UIViewContentModeScaleAspectFill;
    baseView.image = [UIImage imageNamed:@"backImage_login"];
    baseView.backgroundColor = [UIColor blueColor];
    baseView.clipsToBounds = YES;
    [self.view addSubview:baseView];
    _baseView = baseView;
    
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    CCInputLoginView *loginView = [[CCInputLoginView alloc] init];
    loginView.backgroundColor =kUIColorFromRGB_Alpa(0xFFFFFF, 0.8);
    [_baseView addSubview:loginView];
    _loginView = loginView;
    
    if (self.isLandscape) {
        [_loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(@44);
            make.left.equalTo(self.view).offset(12);
            make.height.mas_equalTo([CCInputLoginView height]);
        }];
    } else {
        [_loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).multipliedBy(0.8);
            make.left.equalTo(self.view).offset(12);
            make.height.mas_equalTo([CCInputLoginView height]);
        }];
    }
    
    loginView.tf1.placeholder = DYLocalizedString(@"Please enter account number", @"请输入账号");
    loginView.tf2.placeholder = DYLocalizedString(@"Please enter the password", @"请输入密码");
    
    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [trueBtn cc_configure];
    trueBtn.backgroundColor =kUIColorFromRGB_Alpa(0xFFFFFF, 0.8);
    [trueBtn.layer setCornerRadius:4];
    trueBtn.clipsToBounds = YES;
    [trueBtn setTitle:DYLocalizedString(@"Login", @"登陆") forState:0];
    [trueBtn setTitleColor:kUIColorFromRGB(0x2089ff) forState:0];
    [trueBtn addTarget:self action:@selector(dy_trueAction) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:trueBtn];
    _trueBtn = trueBtn;
    
    [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loginView);
        make.width.equalTo(_baseView).multipliedBy(0.66);
        make.top.equalTo(loginView.mas_bottom).offset(16);
        make.height.equalTo(@35);
    }] ;

    
    ///注册
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn cc_configure];
    registBtn.backgroundColor =kUIColorFromRGB_Alpa(0xFFFFFF, 0.8);
    [registBtn.layer setCornerRadius:4];
    registBtn.clipsToBounds = YES;
    [registBtn setTitle:DYLocalizedString(@"Regist", @"注册") forState:0];
    [registBtn setTitleColor:kUIColorFromRGB(0x2089ff) forState:0];
    [registBtn addTarget:self action:@selector(dy_registAction) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:registBtn];
    _registBtn = registBtn;
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loginView);
        make.width.equalTo(_baseView).multipliedBy(0.66);
        make.top.equalTo(_trueBtn.mas_bottom).offset(16);
        make.height.equalTo(@35);
    }];
    
    
    ///退出按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"icon_home_letter_lottery_cancel"] forState:UIControlStateNormal];
    cancelBtn.contentMode = UIViewContentModeScaleAspectFit;
    [cancelBtn addTarget:self action:@selector(dy_actionBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.left.equalTo(baseView.mas_left).offset(10);
        make.top.equalTo(baseView.mas_top).offset(20);
    }];

    CCThridLoginView *thirdView = [[CCThridLoginView alloc] init];
    thirdView.weakController = self;
    @weakify(self)
    thirdView.thridLoginSuccessBlock = ^(NSString *username,NSString *password) {
        @strongify(self)        
        self.user = username;
        self.password = password;
        [self loginInServer];
    };
    [self.view addSubview:thirdView];
    _thirdView = thirdView;
    
    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(CC_Width);
        make.height.mas_equalTo(100);
    }];
    
}

- (void)dy_registAction {
    CCRegistController *registVc = [[CCRegistController alloc] init];
    [self.navigationController pushViewController:registVc animated:YES];
}

-(void)dy_trueAction {
    self.user = self.loginView.tf1.text;
    self.password = self.loginView.tf2.text;
    [self.loginView endEdit];
    
    [self loginInServer];
}

-(void)loginInServer {
    if (([NSString isEmptyString:self.user]) || ([NSString isEmptyString:self.password])) {
        [NSObject showMessage:DYLocalizedString(@"Please enter the complete information", @"请输入完整的信息")];
        return;
    }
    
    if ([CCLoginInfoManager manager].isLogin == YES) {
        [AVUser logOut];
    }
    
    ///登陆
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CCLoginRequest *request = [[CCLoginRequest alloc] initLoginWithUserName:self.user password:self.password];
    request.successful = ^(NSMutableArray *array, NSInteger code, id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.loginSuccessBlk) {
            self.loginSuccessBlk(YES);
        }
        [self dy_actionBack];
    };
    request.failure = ^(NSString *error, NSInteger code) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    };
    [request loginRequest];

}

- (void)dealloc {
    NSLog(@"%@ -dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setIsLandscape:(BOOL)isLandscape {
    [super setIsLandscape:isLandscape];
    
    if (isLandscape) {
        [_loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(@44);
            make.left.equalTo(self.view).offset(12);
            make.height.mas_equalTo([CCInputLoginView height]);
        }];
    } else {
        [_loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).multipliedBy(0.8);
            make.left.equalTo(self.view).offset(12);
            make.height.mas_equalTo([CCInputLoginView height]);
        }];
    }
    
}


@end

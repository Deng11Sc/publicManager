//
//  DY_LoginController.m
//  MerryS
//
//  Created by SongChang on 2018/1/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_LoginController.h"
#import <AVOSCloud/AVOSCloud.h>

#import "DY_RegistController.h"

#import "DY_InputLoginView.h"

/*
 用户名错误 202
 手机号码错误 214
 邮箱错误 203
 */

@interface DY_LoginController ()

@property (nonatomic,strong)DY_InputLoginView *loginView;

@property (nonatomic,strong)UIImageView *baseView;

@property (nonatomic,strong)UIButton *trueBtn;
///注册时的返回按钮
@property (nonatomic,strong)UIButton *backBtn;


@property (nonatomic,strong)NSString *user;
@property (nonatomic,strong)NSString *password;

@end

@implementation DY_LoginController

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
    
    DY_InputLoginView *loginView = [[DY_InputLoginView alloc] init];
    loginView.backgroundColor =kUIColorFromRGB_Alpa(0xFFFFFF, 0.8);
    [self.view addSubview:loginView];
    _loginView = loginView;
    
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).multipliedBy(0.8);
        make.left.equalTo(self.view).offset(12);
        make.height.mas_equalTo([DY_InputLoginView height]);
    }];
    
    
    loginView.tf1.placeholder = DYLocalizedString(@"Please enter account number", @"请输入账号");
    loginView.tf2.placeholder = DYLocalizedString(@"Please enter the password", @"请输入密码");
    
    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [trueBtn dy_configure];
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
    [registBtn dy_configure];
    registBtn.backgroundColor =kUIColorFromRGB_Alpa(0xFFFFFF, 0.8);
    [registBtn.layer setCornerRadius:4];
    registBtn.clipsToBounds = YES;
    [registBtn setTitle:DYLocalizedString(@"Regist", @"注册") forState:0];
    [registBtn setTitleColor:kUIColorFromRGB(0x2089ff) forState:0];
    [registBtn addTarget:self action:@selector(dy_registAction) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:registBtn];
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
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.left.equalTo(baseView.mas_left).offset(10);
        make.top.equalTo(baseView.mas_top).offset(20);
    }];

}

- (void)dy_registAction {
    DY_RegistController *registVc = [[DY_RegistController alloc] init];
    [self.navigationController pushViewController:registVc animated:YES];
}

///退出
- (void)cancelAction {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dy_trueAction {
    self.user = self.loginView.tf1.text;
    self.password = self.loginView.tf2.text;
    [self.loginView endEdit];
    if (([NSString isEmptyString:self.loginView.tf1.text]) || ([NSString isEmptyString:self.loginView.tf2.text])) {
        [NSObject showMessage:DYLocalizedString(@"Please enter the complete information", @"请输入完整的信息")];
        return;
    }
    
    if ([DY_LoginInfoManager manager].isLogin == YES) {
        [AVUser logOut];
    }
    
    ///登陆
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AVUser logInWithUsernameInBackground:self.loginView.tf1.text password:self.loginView.tf2.text block:^(AVUser *user, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (user != nil) {
            NSLog(@"注册用户");
            
            DY_UserInfoModel *model = [[DY_UserInfoModel alloc] init];
            model.nickName = user.username;
            model.objectId = user.objectId;
            model.sessionToken = user.sessionToken;
            model.imageUrl = [user objectForKey:@"localData"][@"imageUrl"];
            [DY_LoginInfoManager saveUserInfo:model];
            
            ///登录成功发送的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
            if (self.loginSuccessBlk) {
                self.loginSuccessBlk(YES);
            }
            
            [self cancelAction];
            
        } else {
            
            NSLog(@"未注册用户");
            switch ([error.userInfo[@"code"] integerValue]) {
                case 211: ///该账号未注册
                {
                    [NSObject showMessage:DYLocalizedString(@"Account does not exist", @"账号不存在")];
                }
                    break;
                case 210:
                {
                    ///密码错误
                    [NSObject showMessage:DYLocalizedString(@"Wrong password", @"密码错误")];
                }
                    break;
                default:
                {
                    [NSObject showMessage:DYLocalizedString(@"Login failed", @"登陆失败")];
                }
                    break;
            }
        }
    }];
    
}


- (void)dealloc {
    NSLog(@"%@ -dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end

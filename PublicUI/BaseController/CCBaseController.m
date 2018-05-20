//
//  DY_BaseController.m
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCBaseController.h"

#import <CoreMotion/CoreMotion.h>

@interface CCBaseController ()

@end

@implementation CCBaseController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CC_CustomColor_F5F4F3;
    self.navigationController.navigationBar.translucent = NO;    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (self.navigationController.viewControllers.count > 1)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    }
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    //界面旋转方向改变 通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleStatusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    UIDeviceOrientation duration = [[UIDevice currentDevice] orientation];
    [self changedOrientationWithToInterfaceOrientation:duration];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hiddenNavigationBar = _hiddenNavigationBar;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIButton *)backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton new];
        _backButton.frame = CGRectMake(0, 0, 44, 44);
        [_backButton setImage:[UIImage imageNamed:@"nav_normal_back"] forState:UIControlStateNormal];
        [_backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_backButton addTarget:self action:@selector(dy_actionBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(void)setBackButtonHide:(BOOL)hide {
    if (hide == YES) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = !hide;
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
        self.navigationController.interactivePopGestureRecognizer.enabled = !hide;
    }
}


- (void)dy_actionBack
{
    if (self.navigationController.viewControllers.count > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UITableView *)tableView
{
    if (!_tableView)
    {
        //  CGRectMake(0, 0, CC_Width, CC_Height - NavHeight)
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CC_Width, CC_Height - NavHeight)
                                                  style:(self.tableViewIsGrouped ? UITableViewStyleGrouped : UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        
        if ([_tableView respondsToSelector:@selector(setSectionIndexColor:)])
        {
            _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
            _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        }
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(void)duinitTableView {
    [self.view addSubview:self.tableView];
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.width.mas_equalTo(CC_Width);
//        make.height.mas_equalTo(CC_Height - NavHeight);
//    }];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)setHiddenNavigationBar:(BOOL)hiddenNavigationBar
{
    _hiddenNavigationBar = hiddenNavigationBar;
    self.navigationController.navigationBar.hidden = _hiddenNavigationBar;
}



//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    [self changedOrientationWithToInterfaceOrientation:toInterfaceOrientation];
//}

-(void)changedOrientationWithToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    BOOL isLandscape = NO;
    switch (toInterfaceOrientation) {
        case UIDeviceOrientationLandscapeRight:
        case UIDeviceOrientationLandscapeLeft:
            isLandscape = YES;
            break;
            
        default:
            
            break;
    }
    
    if (_tableView) {
        if (isLandscape) {
            _tableView.frame = CGRectMake(0, 0, CC_Width, CC_Height - NavHeight-20);
        }else{
            _tableView.frame = CGRectMake(0, 0, CC_Width, CC_Height - NavHeight);
        }
    }
    self.isLandscape = isLandscape;
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if (_tableView) {
        [_tableView reloadData];
    }

}


-(void)handleStatusBarOrientationChange:(NSNotification *)not
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self changedOrientationWithToInterfaceOrientation:interfaceOrientation];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}





@end

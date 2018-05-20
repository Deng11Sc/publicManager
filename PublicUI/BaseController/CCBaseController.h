//
//  DY_BaseController.h
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCBaseController : UIViewController<UITableViewDelegate,UITableViewDataSource>


//返回按钮
@property (nonatomic,strong)UIButton *backButton;

//如果要建立Grouped数组，则要设置此值为YES；
@property(nonatomic,assign)BOOL tableViewIsGrouped;

@property(nonatomic,strong)UITableView *tableView;

-(void)duinitTableView;

@property(nonatomic,strong)NSMutableArray *dataArray;

- (void)dy_actionBack;

/// 隐藏 NavigationBar 默认显示
@property (nonatomic, assign, getter=isHiddenNavigationBar) BOOL hiddenNavigationBar;


//返回按钮现实or隐藏
-(void)setBackButtonHide:(BOOL)hide;

//子类实现set方法，判断横竖屏
@property (nonatomic,assign)BOOL isLandscape;

@end


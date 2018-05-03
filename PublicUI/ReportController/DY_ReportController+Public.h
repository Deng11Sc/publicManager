//
//  DY_ReportController+Public.h
//  NearbyTask
//
//  Created by SongChang on 2018/5/2.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_ReportController.h"
#import "DY_ReportModel.h"

@interface DY_ReportController (Public)

- (void)addTableView;

//当前选择的分类
- (void)setSelectIndex:(NSInteger)selectIndex ;
- (NSInteger)selectIndex ;


//举报按钮
-(void)setReportButton:(UIButton *)button;
-(UIButton *)reportButton;

- (void)addReportButton;

-(void)sendReportToServer;

@end

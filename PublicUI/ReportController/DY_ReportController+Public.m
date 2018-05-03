//
//  DY_ReportController+Public.m
//  NearbyTask
//
//  Created by SongChang on 2018/5/2.
//  Copyright © 2018年 SongChang. All rights reserved.
//


#import "DY_ReportController+Public.h"

@implementation DY_ReportController (Public)

//当前选择的分类
static char *_selectIndex;
- (void)setSelectIndex:(NSInteger)selectIndex {
    objc_setAssociatedObject(self, &_selectIndex, @(selectIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)selectIndex {
    return [objc_getAssociatedObject(self, &_selectIndex) integerValue];
}


//举报按钮
static char *_reportButton;
- (void)setReportButton:(UIButton *)button {
    objc_setAssociatedObject(self, &_reportButton, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)reportButton {
    return objc_getAssociatedObject(self, &_reportButton);
}

- (void)addReportButton {
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CC_Width, 70)];
    self.tableView.tableFooterView = baseView;
    
    self.reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reportButton dy_configure];
    self.reportButton.backgroundColor =CC_CustomColor_2594D2;
    [self.reportButton setTitle:DYLocalizedString(@"Report", @"举报") forState:0];
    [baseView addSubview:self.reportButton];
    
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(baseView);
        make.height.equalTo(@44);
        make.left.equalTo(@30);
    }];
}


- (void)addTableView {
    
    [self.dataArray addObject:DYLocalizedString(@"Yellow gambling", nil)];
    [self.dataArray addObject:DYLocalizedString(@"Personal attack", nil)];
    [self.dataArray addObject:DYLocalizedString(@"Advertising information", nil)];
    [self.dataArray addObject:DYLocalizedString(@"Fraud", nil)];
    [self.dataArray addObject:DYLocalizedString(@"Politically harmful information", nil)];
    [self.dataArray addObject:DYLocalizedString(@"Infringement", nil)];
    [self.dataArray addObject:DYLocalizedString(@"Information that causes user discomfort", nil)];

    [self dy_initTableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSString *text = self.dataArray[indexPath.row];
    cell.textLabel.text = text;
    
    //icon_report_select
    if (indexPath.row == self.selectIndex) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_report_select"]];
    } else {
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndex = indexPath.row;
    [self.tableView reloadData];
    
}



- (void)sendReportToServer {
    
    DY_ReportModel *reportModel = [[DY_ReportModel alloc] init];
    reportModel.reportId = self.reportId;
    reportModel.contentType = self.contentType;
    reportModel.reportType = @(self.selectIndex);
    reportModel.reportText = self.dataArray[self.selectIndex];
    reportModel.reportUserId = SELF_USER_ID;
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CC_LeanCloudNet *request = [[CC_LeanCloudNet alloc] init];
    [request fatherModelWithClassName:@"report_list" arr:@[reportModel]];
    request.successful = ^(NSMutableArray *array, NSInteger code, id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [NSObject showMessage:DYLocalizedString(@"Report success", @"举报成功")];
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    request.failure = ^(NSString *error, NSInteger code) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [NSObject showMessage:DYLocalizedString(@"Network Error", @"网络错误")];
    };
    [request saveRequest];
    
}

@end

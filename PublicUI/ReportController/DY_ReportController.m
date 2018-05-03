//
//  DY_ReportController.m
//  NearbyTask
//
//  Created by SongChang on 2018/5/2.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_ReportController.h"
#import "DY_ReportController+Public.h"

@interface DY_ReportController ()

@end

@implementation DY_ReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYLocalizedString(@"Report", nil);
    
    [self addTableView];
    [self addReportButton];
    
    [self.reportButton addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)reportAction {
    
    [self sendReportToServer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

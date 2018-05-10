//
//  DY_SetUserInfoController.m
//  NearbyTask
//
//  Created by SongChang on 2018/5/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_SetUserInfoController.h"

@interface DY_SetUserInfoController ()

@end

@implementation DY_SetUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self dy_initTableView];
    
    [self dy_addSubviews];
}


-(void)dy_addSubviews {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"setUserInfoCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    }
    
    return cell;
    
}


@end

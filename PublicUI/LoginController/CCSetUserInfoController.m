//
//  CCSetUserInfoController.m
//  NearbyTask
//
//  Created by SongChang on 2018/5/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCSetUserInfoController.h"

@interface CCSetUserInfoController ()

@end

@implementation CCSetUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self duinitTableView];
    
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

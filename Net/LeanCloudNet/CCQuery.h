//
//  CCQuery.h
//  NearbyTask
//
//  Created by SongChang on 2018/4/23.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "AVQuery.h"

@interface CCQuery : AVQuery

/// 1,分页
@property (nonatomic,assign)NSInteger page;

/// 2,每一页的个数,在CC_leanCloudNet设置默认值
@property (nonatomic,assign)NSInteger pageNum;

/*
 3,
 按照指定字段进行排序，目前只支持单字段,建议使用类型为NSNumber的字段
 * 可多次排序，先写的优先级高
 * 如果第一条件相同，则按第二排序排。
 * 多排序基本用不到，可不管这个参数
 
 -(void)orderByAscending:(NSString *)key;       //正序
 -(void)orderByDescending:(NSString *)key;      //反序，默认为反序的创建时间排序 @"createdAt"
 */

@end

//
//  DY_ReportController.h
//  NearbyTask
//
//  Created by SongChang on 2018/5/2.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCBaseController.h"

@interface DY_ReportController : CCBaseController

@property (nonatomic,strong)NSString *reportId;

/*
 contentType
 1,举报的内容为图集
 2,举报的内容为一张图片
 */
@property (nonatomic,strong)NSString *contentType;

@end

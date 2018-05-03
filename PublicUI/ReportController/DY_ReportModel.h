//
//  DY_ReportModel.h
//  NearbyTask
//
//  Created by SongChang on 2018/5/3.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DY_ReportModel : NSObject

@property (nonatomic,strong)NSString *uniqueId;

@property (nonatomic,strong)NSString *reportId;

@property (nonatomic,strong)NSString *contentType;

@property (nonatomic,strong)NSNumber *reportType;

@property (nonatomic,strong)NSString *reportText;
@property (nonatomic,strong)NSString *reportUserId;

@end

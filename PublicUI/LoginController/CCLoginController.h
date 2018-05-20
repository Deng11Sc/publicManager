//
//  CCLoginController.h
//  MerryS
//
//  Created by SongChang on 2018/1/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCBaseController.h"
#import "CCNavigationController.h"
///用户信息界面
#import "CCLoginInfoManager.h"

@interface CCLoginController : CCBaseController

@property (nonatomic,strong)void (^loginSuccessBlk)(BOOL succeeded);

@end

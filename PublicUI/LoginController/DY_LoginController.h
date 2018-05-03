//
//  DY_LoginController.h
//  MerryS
//
//  Created by SongChang on 2018/1/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_BaseController.h"
#import "DY_NavigationController.h"
///用户信息界面
#import "DY_LoginInfoManager.h"

@interface DY_LoginController : DY_BaseController

@property (nonatomic,strong)void (^loginSuccessBlk)(BOOL succeeded);

@end

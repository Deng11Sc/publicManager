//
//  DY_WebTabbarView.h
//  MerryS
//
//  Created by SongChang on 2018/1/15.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DYWebBtnType) {
    DYWebBtnTypeTohome = 1,
    DYWebBtnTypeRefresh,
    DYWebBtnTypeBack,
    DYWebBtnTypeNext,
    DYWebBtnTypeClean,
};


@interface DY_WebTabbarView : UIView

@property (nonatomic,strong)void (^actionBlock)(DYWebBtnType btnType);

@end

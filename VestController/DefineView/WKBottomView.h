//
//  WKBottomView.h
//  RoyaleRoulette
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OperationStyle) {
    OperationStyleGoBack = 1000,
    OperationStyleGoForward,
    OperationStyleRefresh,
    OperationStyleHomePage,
    OperationStyleMenu
};

@protocol WKBottomViewDelegate <NSObject>

@optional

- (void)performOperationWithStyle:(OperationStyle)style;

@end

@interface WKBottomView : UIView

@property (nonatomic,assign) id<WKBottomViewDelegate>delegate;

@end

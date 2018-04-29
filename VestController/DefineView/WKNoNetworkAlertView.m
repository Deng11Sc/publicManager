//
//  WKNoNetworkAlertView.m
//  RoyaleRoulette
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import "WKNoNetworkAlertView.h"
#import "RoyaleHeader.h"

@implementation WKNoNetworkAlertView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    return self;
}


- (void)createSubViews{
    noView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    [noView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:noView];
    
    noNetworkAletIcon = [[UIImageView alloc] initWithFrame:CGRectMake((MainScreenWidth - 42)*0.5, 0, 42, 42)];
    [noNetworkAletIcon setBackgroundColor:[UIColor clearColor]];
    [noNetworkAletIcon setImage:[UIImage imageNamed:@"noNetworkAletIcon"]];
    [noView addSubview:noNetworkAletIcon];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineSpacing:4];
    NSDictionary *dict = @{NSForegroundColorAttributeName:ColorFromSixteen(0x3c3c3c, 1),
                           NSFontAttributeName:[UIFont systemFontOfSize:16.0f],
                           NSParagraphStyleAttributeName:style};
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"WiFi或蜂窝网络已经断开\n请检查您的网络设置" attributes:dict];
    noNetworkAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noNetworkAletIcon.frame)+15, MainScreenWidth, 20)];
    [noNetworkAlertLabel setAttributedText:string];
    [noNetworkAlertLabel setNumberOfLines:0];
    [noNetworkAlertLabel sizeToFit];
    [noNetworkAlertLabel setCenter:CGPointMake(noView.frame.size.width*0.5, noNetworkAlertLabel.center.y)];
    [noView addSubview:noNetworkAlertLabel];
    
    alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noNetworkAlertLabel.frame)+5, MainScreenWidth, 20)];
    [alertLabel setTextAlignment:NSTextAlignmentCenter];
    [alertLabel setTextColor:ColorFromSixteen(0xb4b4b4, 1)];
    [alertLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [noView addSubview:alertLabel];
    
    noView.frame  = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(alertLabel.frame));
    noView.center = CGPointMake(noView.center.x, self.frame.size.height*0.5 - 50);
}

@end

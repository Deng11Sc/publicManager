//
//  WKNoNetworkAlertView.m
//  RoyaleRoulette
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import "WKNoNetworkAlertView.h"
#import <CoreTelephony/CTCellularData.h>

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
    
    noNetworkAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(noNetworkAletIcon.frame)+15, MainScreenWidth-10, 20)];
    [noNetworkAlertLabel setNumberOfLines:0];
    [noNetworkAlertLabel setCenter:CGPointMake(noView.frame.size.width*0.5, noNetworkAlertLabel.center.y)];
    [noView addSubview:noNetworkAlertLabel];
    
    [self reloadCellular];
}

- (void)reloadCellular{
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str1 = @"WiFi或蜂窝网络已经断开";
            NSString *str2 = @"\n请检查您的网络设置";
            NSString *str3 = @"";
            NSString *str4 = @"";
            if (cellularData.restrictedState == kCTCellularDataRestricted) {
                str1 = @"系统已为此应用关闭无线局域网";
                str2 = @"\n您可以在“";
                str3 = @"设置";
                str4 = @"”中为此应用打开无线局域网";
            }
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            [style setAlignment:NSTextAlignmentCenter];
            [style setLineSpacing:4];
            NSDictionary *dict1 = @{NSForegroundColorAttributeName:ColorFromSixteen(0x222222, 1),
                                   NSFontAttributeName:[UIFont systemFontOfSize:17],
                                   NSParagraphStyleAttributeName:style};
            NSAttributedString *string1 = [[NSAttributedString alloc] initWithString:str1 attributes:dict1];
            
            NSDictionary *dict2 = @{NSForegroundColorAttributeName:ColorFromSixteen(0x666666, 1),
                                    NSFontAttributeName:[UIFont systemFontOfSize:14],
                                    NSParagraphStyleAttributeName:style};
            NSAttributedString *string2 = [[NSAttributedString alloc] initWithString:str2 attributes:dict2];
            NSAttributedString *string4 = [[NSAttributedString alloc] initWithString:str4 attributes:dict2];
            
            NSDictionary *dict3 = @{NSForegroundColorAttributeName:ColorFromSixteen(0x175dfc, 1),
                                    NSFontAttributeName:[UIFont systemFontOfSize:14],
                                    NSParagraphStyleAttributeName:style/*,
                                    NSLinkAttributeName:[NSURL URLWithString:@"prefs:root=General&path=Network"],
                                    NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)*/};
            NSAttributedString *string3 = [[NSAttributedString alloc] initWithString:str3 attributes:dict3];
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
            [string appendAttributedString:string1];
            [string appendAttributedString:string2];
            [string appendAttributedString:string3];
            [string appendAttributedString:string4];
            
            [noNetworkAlertLabel setAttributedText:string];
            CGRect frame = [string boundingRectWithSize:CGSizeMake(MainScreenWidth - 10, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            noNetworkAlertLabel.frame = CGRectMake(5, CGRectGetMaxY(noNetworkAletIcon.frame)+15, MainScreenWidth-10, frame.size.height);
            
            noView.frame  = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(noNetworkAlertLabel.frame));
            noView.center = CGPointMake(noView.center.x, self.frame.size.height*0.5 - 50);
        });
    };
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    noNetworkAletIcon.frame = CGRectMake((MainScreenWidth - 42)*0.5, 0, 42, 42);
    noNetworkAlertLabel.frame = CGRectMake(5, CGRectGetMaxY(noNetworkAletIcon.frame)+15, MainScreenWidth-10, noNetworkAlertLabel.frame.size.height);
    noView.frame  = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(noNetworkAlertLabel.frame));
    noView.center = CGPointMake(noView.center.x, self.frame.size.height*0.5 - 20);
}

@end

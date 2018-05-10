//
//  WKNoNetworkAlertView.h
//  RoyaleRoulette
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKNoNetworkAlertView : UIView
{
    UIView *noView;
    UIImageView *noNetworkAletIcon;
    UILabel *noNetworkAlertLabel;
    UILabel *alertLabel;
}

- (void)reloadCellular;

@end

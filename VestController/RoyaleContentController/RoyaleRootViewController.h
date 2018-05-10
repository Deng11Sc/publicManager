//
//  RoyaleRootViewController.h
//  RoyaleRoulette
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoyaleRootViewController : UIViewController

/**
 *  该参数是从接口获取到的站点域名
 *  该类实例化的时候，这个参数必须传值
 */
@property (nonatomic,copy,nonnull) NSString *urlString;

@end

//
//  RoyaleHeader.h
//  SanCai
//
//  Created by SongChang on 2018/4/23.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#ifndef RoyaleHeader_h
#define RoyaleHeader_h

#define ColorFromSixteen(s,al)  ([UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:al])
#define MainScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define MainScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define iPhoneX (CGSizeEqualToSize([UIScreen mainScreen].bounds.size,CGSizeMake(375, 812)) || CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)))

#define iPhoneXSafeArea     24

#define BGNaviBarHeight     44
#define TabBarHeight        ((iPhoneX)?83:49)
#define NaviBarHeight       ((iPhoneX)?88:64)
#define NaviBarItemHeight   49
#define StatusBarHeight     ((iPhoneX)?44:20)
#define NaviBarABXHeight    (NaviBarHeight - StatusBarHeight)

#import "NSString+Extention.h"
#import "NSObject+Extension.h"

#define IsPortrait   [NSObject isOrientationPortrait]

#endif /* RoyaleHeader_h */

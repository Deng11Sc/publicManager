//
//  DYUIHeader.h
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#ifndef DYUIHeader_h
#define DYUIHeader_h

#define CC_KeyWindow [[[UIApplication sharedApplication] delegate] window]

#define kDevice_iPhoneX CGSizeEqualToSize(CGSizeMake(375, 812), [[UIScreen mainScreen] bounds].size)
#define NavHeight (kDevice_iPhoneX?88:64)
#define StatusBarHeight (kDevice_iPhoneX?44:20)
#define NavLandscapeHeight(isLandscape) ((kDevice_iPhoneX?88:64)-(isLandscape?20:0))
#define CC_TabbarHeight (kDevice_iPhoneX?83:49)
#define CC_LandscapeTabbarHeight(isLandscape) ((kDevice_iPhoneX?83:49)-(isLandscape?20:0))


#define mainColor kUIColorFromRGB(0x333333)

#define CC_CustomColor_F5F4F3 kUIColorFromRGB(0xF5F4F3) ///背景色

#define CC_CustomColor_3A3534 kUIColorFromRGB(0x3A3534)
#define CC_CustomColor_595350 kUIColorFromRGB(0x595350)
#define CC_CustomColor_FA5252 kUIColorFromRGB(0xFA5252)
#define CC_CustomColor_BAB2AF kUIColorFromRGB(0xBAB2AF)


///按钮主色调
#define CC_CustomColor_2594D2 kUIColorFromRGB(0x2594D2)



///头像
#define CC_Default_Avatar [UIImage imageNamed:@"default_avatar_round"]


#define CC_PlaceholderImage [UIImage imageNamed:@"icon_defaut_image"]


#endif /* DYUIHeader_h */

//
//  UIView+Configure.m
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "UIView+Configure.h"

@implementation UIView (Configure)

-(void)dy_configure {
    
}

@end



@implementation UILabel (Configure)

-(void)dy_configure {
    self.font = [UIFont systemFontOfSize:14];
    self.textAlignment = NSTextAlignmentLeft;
    self.textColor = mainColor;
}

@end




@implementation UIButton (Configure)

-(void)dy_configure {
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self setTitleColor:[UIColor whiteColor] forState:0];
    self.backgroundColor = [UIColor whiteColor];
    [self.layer setCornerRadius:4];
    self.clipsToBounds = YES;
}

@end


@implementation UIImage (Configure)

-(void)dy_configure {
    
}

@end


@implementation UITextField (Configure)

-(void)dy_configure {
    self.font = [UIFont systemFontOfSize:14];
    self.textColor = mainColor;
    [self setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
}

@end




//
//  UILabel+AttributeLabel.h
//  MerryS
//
//  Created by SongChang on 2018/1/19.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(AttributeLabel)

-(void)setContentText:(NSString *)text lineSpacing:(NSInteger)lineSpacing wordSpacing:(NSNumber *)wordSpacing;

+(void)setContentText:(NSString *)text label:(UILabel *)label lineSpacing:(NSInteger)lineSpacing wordSpacing:(NSNumber *)wordSpacing;

///先设置富文本，再调用此方法
-(CGSize)boundingSizeWithWidth:(CGFloat)width text:(NSString *)string lineSpacing:(NSInteger)lineSpacing wordSpacing:(NSNumber *)wordSpacing;

@end

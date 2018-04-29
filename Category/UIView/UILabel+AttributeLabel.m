//
//  UILabel+AttributeLabel.m
//  MerryS
//
//  Created by SongChang on 2018/1/19.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "UILabel+AttributeLabel.h"

@implementation UILabel(AttributeLabel)


-(void)setContentText:(NSString *)text lineSpacing:(NSInteger)lineSpacing wordSpacing:(NSNumber *)wordSpacing{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    if (self.lineBreakMode == NSLineBreakByTruncatingTail ||
        self.lineBreakMode == NSLineBreakByTruncatingHead ||
        self.lineBreakMode == NSLineBreakByTruncatingMiddle) {
        paraStyle.lineBreakMode = self.lineBreakMode;
    } else {
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        
    }

    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpacing; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:wordSpacing
                          };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
    self.attributedText = attributeStr;
    
    if (self.lineBreakMode == NSLineBreakByTruncatingTail) {
        self.lineBreakMode = NSLineBreakByTruncatingTail;
    }

}


+(void)setContentText:(NSString *)text label:(UILabel *)label lineSpacing:(NSInteger)lineSpacing wordSpacing:(NSNumber *)wordSpacing{
    
    [UILabel setContentText:text label:label lineSpacing:lineSpacing wordSpacing:wordSpacing];
}



-(CGSize)boundingSizeWithWidth:(CGFloat)width text:(NSString *)string lineSpacing:(NSInteger)lineSpacing wordSpacing:(NSNumber *)wordSpacing
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    if (self.lineBreakMode == NSLineBreakByTruncatingTail ||
        self.lineBreakMode == NSLineBreakByTruncatingHead ||
        self.lineBreakMode == NSLineBreakByTruncatingMiddle) {
        paraStyle.lineBreakMode = self.lineBreakMode;
    } else {
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        
    }
    
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpacing; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:wordSpacing
                          };

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string attributes:dic];
    CGSize size = [attStr boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return size;
}

@end

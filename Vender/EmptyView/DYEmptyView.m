//
//  DYEmptyView.m
//  MerryS
//
//  Created by SongChang on 2018/1/19.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYEmptyView.h"

#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SizeScale ((IPHONE_HEIGHT == 568) ? 0.66 : 1)


@implementation DY_EmptyView

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName top:(CGFloat)top width:(CGFloat)width
{
    self = [super init];
    if (self) {
        
        
        UIImage *image = [UIImage imageNamed:imageName];
        CGSize imageSize = image.size;
        self.imageView.frame = CGRectMake((width-imageSize.width*SizeScale)/2, 0, imageSize.width*SizeScale, imageSize.height*SizeScale);
        self.imageView.image = image;
        
        self.defaultLabel.frame = CGRectMake((CC_Width-228)*0.5, self.imageView.bottom + 8, 228, 40);
        self.defaultLabel.text = title;
        self.defaultLabel.numberOfLines = 2;
        
        if (top < 0) {
            top = (300 *CC_Height/675-64) - (imageSize.height+28)/2;
        }
        
        self.frame = CGRectMake(0, top, width?width:CC_Width, imageSize.height+28);
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName rect:(CGRect)rect
{
    self = [super init];
    if (self) {
        
        UIImage *image = [UIImage imageNamed:imageName];
        CGSize imageSize = image.size;
        self.imageView.frame = CGRectMake((rect.size.width-imageSize.width*SizeScale)/2, 10, imageSize.width*SizeScale, rect.size.height-20);
        self.imageView.image = image;
        
        self.defaultLabel.frame = CGRectMake(0, self.imageView.bottom + 8, rect.size.width, 40);
        self.defaultLabel.text = title;
        
        self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width?rect.size.width:CC_Width, rect.size.height);
    }
    return self;
}


-(UIImageView *)imageView {
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
    }
    return _imageView;
}


-(UILabel *)defaultLabel {
    if (!_defaultLabel) {
        _defaultLabel = [[UILabel alloc] init];
        _defaultLabel.textAlignment = NSTextAlignmentCenter;
        _defaultLabel.font = [UIFont systemFontOfSize:14];
        _defaultLabel.textColor = kUIColorFromRGB(0xb2b2b2);
        [self addSubview:_defaultLabel];
    }
    return _defaultLabel;
}

-(void)show {
    self.hidden = NO;
}


-(void)hide {
    self.hidden = YES;
}



@end

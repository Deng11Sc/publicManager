//
//  DYEmptyView.h
//  MerryS
//
//  Created by SongChang on 2018/1/19.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DY_EmptyView : UIView

@property (nonatomic ,strong) UIImageView *imageView;
//没有本地的媒体推送信息时的文案
@property (nonatomic ,strong) UILabel *defaultLabel;


- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName top:(CGFloat)top width:(CGFloat)width;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName rect:(CGRect)rect;

-(void)show;

-(void)hide;


@end

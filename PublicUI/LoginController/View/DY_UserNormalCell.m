//
//  DY_UserNormalCell.m
//  NearbyTask
//
//  Created by SongChang on 2018/5/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_UserNormalCell.h"

@interface DY_UserNormalCell ()

@property (nonatomic,strong)UIImageView *headImageView;

@end

@implementation DY_UserNormalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_right_arrow"]];
        [self dy_initSubviews];
    }
    return self;
}

-(void)dy_initSubviews {
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(48);
        make.right.mas_equalTo(60);
    }];
}


- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.image = CC_Default_Avatar;
        [self addSubview:_headImageView];
    }
    return _headImageView;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:CC_Default_Avatar];
    
}

@end

//
//  DY_WebTabbarView.m
//  MerryS
//
//  Created by SongChang on 2018/1/15.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_WebTabbarView.h"

@implementation DY_WebTabbarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.layer setBorderColor:kUIColorFromRGB(0xDDDDDD).CGColor];
        [self.layer setBorderWidth:0.5];
        
        [self dy_initSubviews];
    }
    return self;
}

-(void)dy_initSubviews
{
    NSMutableArray *arr = [NSMutableArray array];
    
    NSArray *imgArr = @[@{@"img":@"lc_toolbar_clean",@"type":@(DYWebBtnTypeClean)},
                        @{@"img":@"lc_toolbar_tohome",@"type":@(DYWebBtnTypeTohome)},
                        @{@"img":@"lc_toolbar_refresh",@"type":@(DYWebBtnTypeRefresh)},
                        @{@"img":@"lc_edit_toolbar_back",@"type":@(DYWebBtnTypeBack)},
                        @{@"img":@"lc_toolbar_next",@"type":@(DYWebBtnTypeNext)}
                        ];
    for (int i = 0 ; i < imgArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSDictionary *dic = imgArr[i];
        
        UIImage *img = [UIImage imageNamed:dic[@"img"]];
        if (img) {
            [btn setImage:img forState:0];
        } else {
            [btn setTitle:(NSString *)img forState:0];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitleColor:CC_CustomColor_3A3534 forState:0];
        }
        btn.tag = [dic[@"type"] integerValue];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [arr addObject:btn];
    }
    
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:60 leadSpacing:20 tailSpacing:20];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.mas_equalTo(44);
    }];
}


-(void)btnAction:(UIButton *)btn
{
    if (self.actionBlock) {
        self.actionBlock(btn.tag);
    }
}









@end

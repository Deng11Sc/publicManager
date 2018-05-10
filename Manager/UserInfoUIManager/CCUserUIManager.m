//
//  CCUserUIManager.m
//  InitiallyProject
//
//  Created by SongChang on 2018/5/9.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCUserUIManager.h"
#import "NSString+Common.h"

@interface CCUserUIManager ()

@property (nonatomic,strong)NSMutableArray *headUIArray;
@property (nonatomic,strong)UIImageView *baseImageView;

@end

@implementation CCUserUIManager

- (CCUserUIManager *)manager {
    static CCUserUIManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[CCUserUIManager alloc] init];
    });
    return _manager;
}


- (NSMutableArray *)headUIArray {
    if (!_headUIArray) {
        _headUIArray = [NSMutableArray new];
    }
    return _headUIArray;
}


- (UIImageView *)baseImageView {
    if (!_baseImageView) {
        _baseImageView = [[UIImageView alloc] init];
    }
    return _baseImageView;
}


- (void)registerHeadUI:(id)view {
    [self.headUIArray addObject:view];
}

- (void)refreshAllUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *imageUrl = [ud objectForKey:@"userinfo-imageUrl"];
        [self.baseImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrl getSmallImageWithWidth:100 height:100]]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         
                                         for (id view in self.headUIArray) {
                                             if ([view isKindOfClass:[UIImageView class]]) {
                                                 UIImageView *imageView = view;
                                                 imageView.image = image;
                                             } else if ([view isKindOfClass:[UIButton class]]) {
                                                 UIButton *btn = view;
                                                 [btn setImage:image forState:0];
                                             }
                                         }
                                         
                                     }];
        
    });
}

@end

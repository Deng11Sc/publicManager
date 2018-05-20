//
//  CCInputLoginView.h
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCInputTextField.h"


@interface CCInputLoginView : UIView

+ (CGFloat)height;

@property (nonatomic,strong)CCInputTextField *tf1;

@property (nonatomic,strong)CCInputTextField *tf2;

- (void)endEdit ;


@end

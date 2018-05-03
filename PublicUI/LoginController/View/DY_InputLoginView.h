//
//  DY_InputLoginView.h
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_InputTextField.h"


@interface DY_InputLoginView : UIView

+ (CGFloat)height;

@property (nonatomic,strong)DY_InputTextField *tf1;

@property (nonatomic,strong)DY_InputTextField *tf2;

- (void)endEdit ;


@end

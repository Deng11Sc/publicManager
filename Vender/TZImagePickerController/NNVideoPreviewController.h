//
//  NNMediaPreviewController.h
//  NNLetter
//
//  Created by gavin.tangwei on 2017/8/17.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^NNVideoActionBlock)(NSURL *url);

@interface NNVideoPreviewController : UIViewController

@property (nonatomic, strong) NSURL *urlPath;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, copy) NNVideoActionBlock actionBlock;
@property (nonatomic, strong) id asset;

@end

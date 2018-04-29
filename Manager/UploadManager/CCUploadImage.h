//
//  CCUploadImage.h
//  NearbyTask
//
//  Created by SongChang on 2018/4/27.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCUploadImage : NSObject

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) NSString *linkUrl;

@property (nonatomic,assign) BOOL isUpload;

@end

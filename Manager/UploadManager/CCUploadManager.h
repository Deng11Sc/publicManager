//
//  CCUploadManager.h
//  NearbyTask
//
//  Created by SongChang on 2018/4/25.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCUploadImage.h"

@interface CCUploadManager : NSObject

@property (nonatomic,strong)NSArray *images;



@property (nonatomic,strong)NSString *downloadUrl;

-(void)startUpload;

@property (nonatomic,strong)void (^successful)(NSMutableArray <CCUploadImage *>*images,NSInteger total,NSInteger uploadCount);

@property (nonatomic,strong)void (^failure)(int code,NSString *text);

@property (nonatomic,strong)void (^progess)(NSString *key, float percent ,NSInteger index);


-(void)startUploadWithSuccessful:(void (^)(NSMutableArray <CCUploadImage *>*images,NSInteger total,NSInteger uploadCount))successful
                         failure:(void (^)(int code,NSString *text))failure
                        progress:(void (^)(NSString *key, float percent ,NSInteger index))progess;

@end

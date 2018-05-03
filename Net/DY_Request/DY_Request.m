//
//  DY_Request.m
//  NearbyTask
//
//  Created by SongChang on 2018/4/28.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_Request.h"
#import "DY_CollectModel.h"
#import "DY_BrowseModel.h"

@implementation DY_Request

- (id)initForumList
{
    self = [super init];
    if (self) {
        self.className = URL_Gallery_Model;
        self.pageNum = 20;
    }
    return self;
}


//model为DY_FilmReviewModel
- (id)initCollectWithType:(NSInteger)type atlas:(id)subModel status:(NSInteger)status collectId:(NSString *)collectId
{
    self = [super init];
    if (self) {
        
        if (status == 0) {
            DY_CollectModel *model = [[DY_CollectModel alloc] init];
            model.userId = SELF_USER_ID;
            model.collectType = @(type);
            
            [self fatherModelWithClassName:URL_Collect_Model arr:@[model]];
            
            if (type == 1) {
                [self pointerModelsWithClassName:URL_Tuji_model model:subModel subName:@"pointerAtlas"];
            } else if (type == 2) {
                [self pointerModelsWithClassName:URL_Gallery_Model model:subModel subName:@"pointerGallery"];
            }
            
        } else {
            
            NSString *cql = [NSString stringWithFormat:@"delete from %@ where objectId='%@'", URL_Collect_Model,collectId];
            [self startWithCql:cql];
        }
    }
    return self;
}

///查询自己有没有收藏
- (id)initSelectIsCollect:(NSString *)uniqueId
{
    self = [super init];
    if (self) {
        
        self.className = URL_Collect_Model;
        AVObject *object = [AVObject objectWithClassName:URL_Tuji_model objectId:uniqueId];
        [self whereKey:@"pointerAtlas" equal:object];

    }
    return self;
}


/*
 浏览记录,uniqueId是用来查询是否曾经浏览过这条记录的
 */
- (id)initBrowserRecord:(id)subModel uniqueId:(NSString *)uniqueId type:(NSInteger)browseType;
{
    self = [super init];
    if (self) {
        
        DY_BrowseModel *model = [[DY_BrowseModel alloc] init];
        model.userId = SELF_USER_ID;
        model.uniqueId = uniqueId;
        model.browseType = @(browseType);
        [self.query orderByDescending:@"updatedAt"];
        
        [self fatherModelWithClassName:URL_Browse_Model arr:@[model]];
        
        if (browseType == 1) {
            [self pointerModelsWithClassName:URL_Tuji_model model:subModel subName:@"pointerBrowse"];
        } else if (browseType == 2) {
            [self pointerModelsWithClassName:URL_Gallery_Model model:subModel subName:@"pointerBrowseGallery"];
        }
    }
    return self;
}

///查询自己有没有浏览过
- (id)initIsBrowser:(NSString *)uniqueId type:(NSInteger)browseType;
{
    self = [super init];
    if (self) {
        
        self.userId = SELF_USER_ID;
        [self requestWithFatherClass:[DY_BrowseModel class]];
        
        self.className = URL_Browse_Model;
        
        if (browseType == 1) {
            AVObject *object = [AVObject objectWithClassName:URL_Tuji_model objectId:uniqueId];
            [self whereKey:@"pointerBrowse" equal:object];
        } else if (browseType == 2) {
            AVObject *object = [AVObject objectWithClassName:URL_Gallery_Model objectId:uniqueId];
            [self whereKey:@"pointerBrowseGallery" equal:object];
        }
        
        
    }
    return self;
}



@end

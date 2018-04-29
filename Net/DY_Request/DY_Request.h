//
//  DY_Request.h
//  NearbyTask
//
//  Created by SongChang on 2018/4/28.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CC_LeanCloudNet.h"

@interface DY_Request : CC_LeanCloudNet

- (id)initForumList;

/*
 model为DY_FilmReviewModel
 status传0为收藏，status传1为取消收藏,
 注意，status=1时，collectId必传，为收藏表中的uniqueId。
 
 @param:type - 1，收藏图集。2，收藏图片
 
*/
- (id)initCollectWithType:(NSInteger)type atlas:(id)subModel status:(NSInteger)status collectId:(NSString *)collectId;

/*
 查询自己有没有收藏,
 */
- (id)initSelectIsCollect:(NSString *)uniqueId;


/*
 浏览记录
 */
- (id)initBrowserRecord:(id)subModel uniqueId:(NSString *)uniqueId;
///查询自己有没有浏览过
- (id)initIsBrowser:(NSString *)uniqueId;


@end

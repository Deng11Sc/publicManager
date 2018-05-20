//
//  CCModel.h
//  NearbyTask
//
//  Created by SongChang on 2018/3/23.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <AVOSCloud/AVObject.h>

@interface CCModel : AVObject

//因为objectId是AVObject的保留字段，所以用uniqueId作为保存字段保存数据的唯一值
//@property (nonatomic,strong)NSString *uniqueId;

@end

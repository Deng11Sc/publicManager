//
//  CC_LeanCloudNet+Method.h
//  NearbyTask
//
//  Created by SongChang on 2018/3/27.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CC_LeanCloudNet.h"

@interface CC_LeanCloudNet(Method)

///构成todo数据
-(AVObject *)todoWithClassName:(NSString *)className model:(id)model;


//获取model的其中一个key
-(NSString *)getKeyWithIvar:(Ivar)ivar;

@end

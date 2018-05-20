//
//  CCUserRequest.m
//  NearbyTask
//
//  Created by SongChang on 2018/3/23.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCUserRequest.h"

@implementation CCUserRequest

- (void)getUserInfo {
    self.userId = SELF_USER_ID;
    [self startRequest];
}


-(void)test {
    
    [self startRequest];
}

@end

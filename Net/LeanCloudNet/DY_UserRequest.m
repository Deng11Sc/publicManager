//
//  DY_UserRequest.m
//  NearbyTask
//
//  Created by SongChang on 2018/4/23.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_UserRequest.h"

@implementation DY_UserRequest

- (void)getUserInfo {
    self.userId = SELF_USER_ID;
    [self startRequest];
}


-(void)test {
    
    [self startRequest];
}

@end

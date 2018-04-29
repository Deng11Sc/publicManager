//
//  CCQuery.m
//  NearbyTask
//
//  Created by SongChang on 2018/4/23.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCQuery.h"

@implementation CCQuery


- (void)setPage:(NSInteger)page {
    _page = MAX(page, 1);
    
    self.skip = _pageNum  * (_page - 1);
    
}


- (void)setPageNum:(NSInteger)pageNum {
    _pageNum = MAX(pageNum, 1);
    
    self.limit = _pageNum;
    self.page = _page;
    
}

@end

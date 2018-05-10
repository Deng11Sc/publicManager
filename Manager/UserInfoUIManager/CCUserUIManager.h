//
//  CCUserUIManager.h
//  InitiallyProject
//
//  Created by SongChang on 2018/5/9.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCUserUIManager : NSObject

//加入到当改变头像时，对应的数据需要发生变化的数据内
- (void)registerHeadUI:(id)view;


//改变后，调用此方法，改变对应控件的UI
- (void)refreshAllUI;


@end

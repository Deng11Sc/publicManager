//
//  NSString+Common.h
//  MerryS
//
//  Created by SongChang on 2018/1/15.
//  Copyright © 2018年 SongChang. All rights reserved.
//

@interface NSString(Common)


///判断空
+ (BOOL)isEmptyString:(NSString *)text;

///获取sql路径
+ (NSString *)getSqlPath;

///颜色
+ (UIColor *)colorWithHexString:(NSString *)hexStr;

///获得图片的完整链接
- (NSString *)getImageCompleteUrl;

//获取七牛压缩图片
- (NSString *)getSmallImageWithWidth:(CGFloat)width height:(CGFloat)height;
///获取图片完整路径
+ (NSString *)getCommonUrlStr:(NSString *)url;


//分解string，图片文字分离，伪富文本图文显示
- (void)getNewContentWithBlock:(void (^)(NSMutableArray *textArr))blk;

//获取图片
- (NSMutableArray *)filterImage;


///去除content内的标签
-(NSString *)getSubTitle;

///富文本转化
- (void)getMessageRange:(NSString*)message :(NSMutableArray*)array;

+(BOOL)isShowMJBContent;




///随机头像
+(NSString *)randomHeaderImageUrl;


@end


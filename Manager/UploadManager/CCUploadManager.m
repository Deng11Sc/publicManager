//
//  CCUploadManager.m
//  NearbyTask
//
//  Created by SongChang on 2018/4/25.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CCUploadManager.h"
#import <QiniuSDK.h>
#import <NSObject+MJKeyValue.h>
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

static NSString *_key = @"images";
static NSString *_img_host = @"http://p7qx76zj1.bkt.clouddn.com/";
@interface CCUploadManager ()

@property (nonatomic,strong)QNUploadManager *qnManger;

@property (nonatomic,strong)NSString *linkUrl;

@end


@implementation CCUploadManager

- (QNUploadManager *)qnManger {
    if (!_qnManger) {
        _qnManger = [[QNUploadManager alloc] init];
    }
    return _qnManger;
}

- (NSString *)getQNUploadKey:(NSString *)key {
    NSString *upToken = [self makeToken:@"ctFZ0byBYJdF0564HyqdIMjishZgTm8Sks9lSI2c" secretKey:@"QDVCtgfmqeU-EV9Y3Iimh-xmW8i09Fl6dwxsiG1N" bucket:@"scuuuu" key:key];
    return upToken;
}

- (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey bucket:(NSString *)bucket key:(NSString *)key
{
    const char *secretKeyStr = [secretKey UTF8String];
    
    NSString *policy = [self marshal: bucket key:key];
    
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodedPolicy = [GTMBase64 stringByWebSafeEncodingData:policyData padded:TRUE];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    
    NSString *encodedDigest = [GTMBase64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, encodedDigest, encodedPolicy];
    
    return token;//得到了token
}

- (NSString *)marshal:(NSString *)bucket key:(NSString *)key

{
    time_t deadline;
    
    time(&deadline);//返回当前系统时间
    deadline += 3600; // +3600秒,即默认token保存1小时.
    
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    //images是我开辟的公共空间名（即bucket），aaa是文件的key，
    //按七牛“上传策略”的描述：    <bucket>:<key>，表示只允许用户上传指定key的文件。在这种格式下文件默认允许“修改”，若已存在同名资源则会被覆盖。如果只希望上传指定key的文件，并且不允许修改，那么可以将下面的 insertOnly 属性值设为 1。
    //所以如果参数只传users的话，下次上传key还是aaa的文件会提示存在同名文件，不能上传。
    //传images:aaa的话，可以覆盖更新，但实测延迟较长，我上传同名新文件上去，下载下来的还是老文件。
    NSString *value = [NSString stringWithFormat:@"%@:%@", bucket, key];
    [dic setObject:value forKey:@"scope"];//根据

    [dic setObject:deadlineNumber forKey:@"deadline"];
    
    NSString *json = [dic mj_JSONString];

    return json;
    
}

-(void)startUploadWithSuccessful:(void (^)(NSMutableArray <CCUploadImage *>*images,NSInteger total,NSInteger uploadCount))successful
                         failure:(void (^)(int code,NSString *text))failure
                        progress:(void (^)(NSString *key, float percent ,NSInteger index))progess {

    self.successful = successful;
    self.failure = failure;
    self.progess = progess;
    [self startUpload];
}


- (void)startUpload {
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];

    NSMutableArray *keys = [NSMutableArray array];
    [self uploadImages:self.images atIndex:0 uploadManager:upManager keys:keys];
    
}

-(void)uploadImages:(NSArray *)images
            atIndex:(NSInteger)index
      uploadManager:(QNUploadManager *)uploadManager
               keys:(NSMutableArray <CCUploadImage *>*)keys{
    UIImage *image = images[index];
    __block NSInteger imageIndex = index;
    NSData *data = UIImageJPEGRepresentation(image, 0.3);

    
    ///上传进度
    QNUploadOption *option = [[QNUploadOption alloc] initWithProgressHandler:^(NSString *key, float percent) {
        if (self.progess) {
            self.progess(key, percent,imageIndex);
        }
    }];
    
    ///构成上传的文件名，为了区分同名，由三部分构成，1，userId，如果没有userId，则随机生成一段自负；2，时间戳；3，尾缀，当前上传的是这次上传的第几张图
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"-%.f", a];
    
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo-nickName"];
    if ([NSString isEmptyString:nickName]) {
        nickName = [self getRandomStr];
    }
    NSString *link = [nickName stringByAppendingString:timeString];
    link = [link stringByAppendingString:[NSString stringWithFormat:@"%ld",index]];
    
    NSString *token = [self getQNUploadKey:link];
    
    [uploadManager putData:data key:link token:token
                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      if (info.isOK) {
                          
                          CCUploadImage *upImage = [[CCUploadImage alloc] init];
                          upImage.isUpload = YES;
                          upImage.linkUrl = [_img_host stringByAppendingString:key];
                          [keys addObject:upImage];

                          if (self.successful) {
                              self.successful(keys, images.count, imageIndex+1);
                          }

                          NSLog(@"idInex %ld,OK",index);
                          imageIndex++;

                          if (imageIndex >= images.count) {
                              NSLog(@"上传完成");
                              return ;
                          }
                          [self uploadImages:images atIndex:imageIndex uploadManager:uploadManager keys:keys];
                      } else {
                          if (self.failure) {
                              self.failure(info.statusCode, @"图片上传失败,请稍后再试");
                          }   
                      }
                      
                  } option:option];
}


-(NSString *)getRandomStr
{
    char data[6];
    
    for (int x=0;x < 6;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    NSString *randomStr = [[NSString alloc] initWithBytes:data length:6 encoding:NSUTF8StringEncoding];
    NSString *string = [NSString stringWithFormat:@"%@",randomStr];
    
    return string;
    
}

@end

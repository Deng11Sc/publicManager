//
//  CC_LeanCloudNet.m
//  LiCai
//
//  Created by SongChang on 2018/4/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "CC_LeanCloudNet.h"
#import "CC_LeanCloudNet+Method.h"

typedef NS_ENUM(NSInteger,CCResponseStatus)
{
    CCResponseStatusNormal = 0,
    CCResponseStatusSuccessful = 1,
    CCResponseStatusFailure = 2,
};

@interface CC_LeanCloudNet ()

///以下是请求数据用的数据
@property (nonatomic,strong)Class fatherClass;

@property (nonatomic,strong)NSArray *classArr;

@property (nonatomic,strong)NSArray *urlArr;



///以下是保存用的属性
@property (nonatomic,assign)CCResponseStatus pointerStatus;

@property (nonatomic,assign)CCResponseStatus relationStatus;

/*
 *2,
 *设置当前请求返回的model类型,类型为数组.
 */

@property (nonatomic,strong)NSMutableArray *fatherModels;

///建立Pointer关系的数组
@property (nonatomic,strong)NSMutableArray *pointerModels;
///建立Relation关系的数组
@property (nonatomic,strong)NSMutableArray *relationModels;

@property (nonatomic,strong)NSString *fatherClassName;


@end

@implementation CC_LeanCloudNet

+(void)_initOSCloudServers {
    [self _initOSCloudServersAppId:@"fXQM2gI5KH56ulO4lDguPKeR-gzGzoHsz" clientKey:@"mC7ab5s3LjlRTYjo0efQCVh7"];
}


+(void)_initOSCloudServersAppId:(NSString *)appId clientKey:(NSString *)clientKey
{
    [AVOSCloud setApplicationId:appId clientKey:clientKey];
    [AVOSCloud setAllLogsEnabled:NO];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initQuery];
    }
    return self;
}

- (void)setClassName:(NSString *)className
{
    _className = className;
    _fatherClassName = className;
    
    self.query.className = className;
}

-(void)_initQuery {
    self.query.pageNum = 10;
    self.query.page = 1;
    [self.query orderByDescending:@"createdAt"];
    self.uniqueId = @"uniqueId";
}

- (CCQuery *)query {
    if (!_query) {
        _query = [[CCQuery alloc] init];
    }
    return _query;
}

#pragma mark ------------- 以下拉去数据的代码 -------------
- (void)startRequest {
    
    NSAssert(_fatherClassName, @"query没有对应表明，请设置表明，初始化方法调用");
    
    [self.query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            
            NSMutableArray *dataArray = [NSMutableArray new];
            for (AVObject *avObj in objects) {
                NSMutableDictionary *dic = [avObj objectForKey:@"localData"];
                dic[self.uniqueId] = avObj[@"objectId"];
                
                if (self.fatherClass) {
                    id model = [[self.fatherClass alloc] initWithDictionary:dic];
                    [dataArray addObject:model];
                } else {
                    [dataArray addObject:dic];
                }
                
            }
            
            if (_successful) {
                self.successful(dataArray, 0, objects);
            }

        } else {
            if (self.failure) {
                self.failure(nil, 500);
            }
        }
    }];
}


-(void)requestWithFatherClass:(Class)fatherClass
{
    self.fatherClass = fatherClass;
}

-(void)requestWithSubClassArr:(id)classArr urlArr:(id)urlArr
{
    self.classArr = classArr;
    self.urlArr = urlArr;
    
    for (NSString *key in urlArr) {
        [self.query includeKey:key];
    }
    
}



#pragma mark ------------- 以下代码是保存代码 -------------

- (void)saveRequest {
    //Pointers 存储
    NSAssert(self.fatherModels, @"不存在父节点，请设置父节点");

    if (self.fatherModels) {
        
        NSMutableArray *submitArr = [NSMutableArray new];
        for (int i = 0; i <self.fatherModels.count; i++) {
            NSDictionary *dic = self.fatherModels[i];
            NSString *className = dic[@"className"];
            
            NSArray *arr = dic[@"arr"];
            
            for (id subModel in arr) {
                if (![NSString isEmptyString:[subModel valueForKey:self.uniqueId]]) {
                    continue;
                }
                AVObject *object = [self todoWithClassName:className model:subModel];
                [submitArr addObject:object];

            }
            
        }
        
        if (submitArr.count) {
            [AVObject saveAllInBackground:submitArr block:^(BOOL succeeded, NSError * _Nullable error) {
                
                for (int i = 0; i <submitArr.count; i++) {
                    AVObject *object = submitArr[i];
                    
                    NSDictionary *dic = self.fatherModels[i];
                    NSArray *arr = dic[@"arr"];
                    for (id subModel in arr) {
                        [subModel setValue:object[@"objectId"] forKey:self.uniqueId];
                    }
                }
                
                if (self.pointerModels.count) {
                    [self savePointerModels];
                } else {
                    self.pointerStatus = CCResponseStatusSuccessful;
                }
                
                if (self.relationModels.count) {
                    [self saveRelationModels];
                } else {
                    self.relationStatus = CCResponseStatusSuccessful;
                }
                [self saveOut];
            }];
            
        }  else {
            ///如果第一步已经完成，直接下一步，保存关联
            if (self.pointerModels.count) {
                [self savePointerModels];
            } else {
                self.pointerStatus = CCResponseStatusSuccessful;
            }
            
            if (self.relationModels.count) {
                [self saveRelationModels];
            } else {
                self.relationStatus = CCResponseStatusSuccessful;
            }
            [self saveOut];
        }
    } else {

    }

}

-(void)savePointerModels {
//    BOOL isAssert = self.fatherModels.count == 1;
//    NSAssert(isAssert, @"调用pointer时，父object只能是1个");
    
    NSDictionary *fatherDic = self.fatherModels.firstObject;
    NSArray *arr = fatherDic[@"arr"];
    id model = arr.firstObject;
    AVObject *fatherObject = [self todoWithClassName:fatherDic[@"className"] model:model];
    
    
    for (int i = 0; i <self.pointerModels.count; i++) {
        NSDictionary *dic = self.pointerModels[i];
        NSString *className = dic[@"className"] ;
        
        id subModel = dic[@"model"];
        
        AVObject *object;
        if ([subModel isKindOfClass:[AVObject class]]) {
            object = subModel;
        } else {
            object = [self todoWithClassName:className model:subModel];
        }
        [fatherObject setObject:object forKey:dic[@"subName"]];
    }
    
    [fatherObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            self.pointerStatus = CCResponseStatusSuccessful;
        } else {
            self.pointerStatus = CCResponseStatusFailure;
        }
        [self saveOut];
    }];

}

-(void)saveRelationModels {
    
    BOOL isAssert = self.fatherModels.count == 1;
    NSAssert(isAssert, @"调用relation时，父object只能是1个");

    //设置父节点
    NSDictionary *fatherDic = self.fatherModels.firstObject;
    NSArray *arr = fatherDic[@"arr"];
    id model = arr.firstObject;
    AVObject *fatherObject = [self todoWithClassName:fatherDic[@"className"] model:model];
    
    ///计数，一共要提交多少个数据
    int _totalCount = 0;
    
    //查询需要保存到后台的节点
    NSString *subName = nil;
    NSMutableArray *submitArr = [NSMutableArray new];
    for (int i = 0; i <self.relationModels.count; i++) {
        NSDictionary *dic = self.relationModels[i];
        NSString *className = dic[@"className"];
        
        subName = dic[@"subName"];
        
        NSArray *arr = dic[@"arr"];
        
        NSMutableArray *mitArr = [NSMutableArray new];
        for (id subModel in arr) {
//            if ([subModel valueForKey:self.uniqueId]) {
//                continue;
//            }
            AVObject *object = [self todoWithClassName:className model:subModel];
            [mitArr addObject:object];
            _totalCount += 1;
        }
        [submitArr addObject:mitArr];
    }
    if (_totalCount) {
        ///如果有节点未提交，要提交，再进行下一步
        NSMutableArray *finallySubmitArr = [NSMutableArray new];
        for (NSArray *arr in submitArr) {
            [finallySubmitArr addObjectsFromArray:arr];
        }
        
        [AVObject saveAllInBackground:finallySubmitArr block:^(BOOL succeeded, NSError * _Nullable error) {
            
            if (succeeded) {
                for (int i = 0; i <self.relationModels.count; i++) {
                    NSDictionary *dic = self.relationModels[i];
                    NSArray *arr = dic[@"arr"];
                    
                    NSArray *succeedArr = submitArr[i];
                    for (int h = 0; h < succeedArr.count; h++) {
                        AVObject *object = succeedArr[h];
                        id subModel = arr[h];
                        [subModel setValue:object[@"objectId"] forKey:self.uniqueId];
                    }
                    
                }                
                [self nextStepInRelationWithFatherObject:fatherObject];
            } else {
                self.relationStatus = CCResponseStatusFailure;
                [self saveOut];
            }
        
        }];
    } else {
        //所有节点均有objectId，直接下一步
        [self nextStepInRelationWithFatherObject:fatherObject];
    }
    
}

-(void)nextStepInRelationWithFatherObject:(AVObject *)fatherObject {

    for (int i = 0; i <self.relationModels.count; i++) {
        NSDictionary *dic = self.relationModels[i];
        NSString *className = dic[@"className"];
        NSString *subName = dic[@"subName"];
        
        AVRelation *relation = [fatherObject relationForKey:subName];
        
        NSArray *arr = dic[@"arr"];
        for (id subModel in arr) {
            AVObject *object = [self todoWithClassName:className model:subModel];
            [relation addObject:object];
        }
    }
    [fatherObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            self.relationStatus = CCResponseStatusSuccessful;
        } else {
            self.relationStatus = CCResponseStatusFailure;
        }
        [self saveOut];
    }];
}



- (void)saveOut {
    if ((!self.pointerStatus) || (!self.relationStatus)) {
    } else {
        if (self.pointerStatus == CCResponseStatusFailure || self.relationStatus == CCResponseStatusFailure) {
            NSLog(@"保存失败");

            [NSObject showMessage:DYLocalizedString(@"Request failed, please try again later", @"请求失败，请稍后再试")];
            if (self.failure) {
                self.failure(@"AVQuery保存失败", 500);
            }
        } else {
            NSLog(@"保存成功");
            if (self.successful) {
                NSDictionary *dic = self.fatherModels.firstObject;
                self.successful(dic[@"arr"], 0, nil);
            }
        }
        [self.fatherModels removeAllObjects];
        [self.pointerModels removeAllObjects];
        [self.relationModels removeAllObjects];
    }
}



// ************************ 建立表关联结构 ************************ //
- (void)fatherModelWithClassName:(NSString *)className arr:(id)arr
{
    self.fatherClassName = className;
    
    [self.fatherModels removeAllObjects];
    [self.fatherModels addObject:@{@"className":className,@"arr":arr}];
}


/*
 可通过以下方法创建models，多次调用即可,subName为关系的字段名
 */

//Pointer关系
-(void)pointerModelsWithClassName:(NSString *)className model:(id)model subName:(NSString *)subName
{
//    [self.pointerModels removeAllObjects];
    [self.pointerModels addObject:@{@"className":className,@"model":model,@"subName":subName}];
}



//建立AVRelation关系
-(void)relationModelsWithClassName:(NSString *)className arr:(id)arr subName:(NSString *)subName
{
    [self.relationModels removeAllObjects];
    [self.relationModels addObject:@{@"className":className,@"arr":arr,@"subName":subName}];
}

-(NSMutableArray *)fatherModels {
    if (!_fatherModels) {
        _fatherModels = [[NSMutableArray alloc] init];
    }
    return _fatherModels;
}

-(NSMutableArray *)pointerModels {
    if (!_pointerModels) {
        _pointerModels = [[NSMutableArray alloc] init];
    }
    return _pointerModels;
}

-(NSMutableArray *)relationModels {
    if (!_relationModels) {
        _relationModels = [[NSMutableArray alloc] init];
    }
    return _relationModels;
}


// ************************ 设置查询条件 ************************ //
-(void)setUserId:(NSString *)userId {
    _userId = userId;
    
    [self.query whereKey:@"userId" equalTo:userId];
    
}

- (void)setPage:(NSInteger)page {
    _page = page;
    self.query.page = _page;
}

- (void)setPageNum:(NSInteger)pageNum {
    _pageNum = pageNum;
    self.query.pageNum = pageNum;
}

- (void)whereKey:(NSString *)key equal:(id)value {
    [self.query whereKey:key equalTo:value];
}




- (void)startWithCql:(NSString *)cql {

    [AVQuery doCloudQueryInBackgroundWithCQL:cql callback:^(AVCloudQueryResult *result, NSError *error)
     {
         if (!error) {
             if (self.successful) {
                 self.successful(nil, 200, result);
             }
         } else {
             [NSObject showMessage:DYLocalizedString(@"Request failed, please try again later", @"请求失败，请稍后再试")];
             if (self.failure) {
                 self.failure(@"请求失败，请自行查原因", 500);
             }
         }
     }];
}


@end

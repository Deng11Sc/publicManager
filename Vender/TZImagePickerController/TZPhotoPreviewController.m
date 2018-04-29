//
//  TZPhotoPreviewController.m
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "TZPhotoPreviewController.h"
#import "TZPhotoPreviewCell.h"
#import "TZAssetModel.h"
#import "UIView+Layout.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "TZImageCropManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NNImageEditObject.h"

#import "UIView+Support.h"

@interface NNImagePreviewThumbView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *boottomSepView;
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, assign) NSInteger curSelIndex;
@property (nonatomic, assign) BOOL isPreview;
@end

@implementation NNImagePreviewThumbView

- (void)setModels:(NSMutableArray *)models
{
    /// 预览 不做 添加 删除
    if (_models.count > 0 && self.isPreview) {
        return;
    }
    
    self.hidden = !(models.count > 0);
    if ([models isEqual:_models])
    {
        return;
    }

    if (!_models)
    {
        _models = models.mutableCopy;
        [UICollectionView performWithoutAnimation:^{
          [self.collectionView reloadData];
        }];
    }
    else
    {
        NSMutableSet *set1 = [NSMutableSet setWithArray:_models];
        NSMutableSet *set2 = [NSMutableSet setWithArray:models];

        /// 删除
        if (_models.count > models.count)
        {
            [set1 minusSet:set2];

            NSInteger index = [_models indexOfObject:[[set1 allObjects] firstObject]];
            [_models removeObjectAtIndex:index];
            _curSelIndex = -1;
//            [self.collectionView deleteItemsAtIndexPaths:@[ [NSIndexPath indexPathForItem:index inSection:0]]];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            return;
        }
        // 增加
        [set2 minusSet:set1];
        if (set2.allObjects.count > 0) {
            [_models addObject:[[set2 allObjects] firstObject]];
            _curSelIndex = _models.count - 1;
            [self.collectionView insertItemsAtIndexPaths:@[ [NSIndexPath indexPathForItem:_curSelIndex inSection:0] ]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_curSelIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
            });

        }
        return;
    }
}

- (void)setPreviewModel:(TZAssetModel *)model
{
    for (NSInteger i = 0; i < _models.count; i++)
    {
        TZAssetModel *m = _models[i];
        if ([[[TZImageManager manager] getAssetIdentifier:m.asset] isEqual:[[TZImageManager manager] getAssetIdentifier:model.asset]])
        {
            [self updateSelected:i];
            return;
        }
    }

    if (_curSelIndex < 0 || self.models.count <= 0 || _curSelIndex >=_models.count)
    {
        return;
    }
    /// 取消选中
    NSInteger temp = _curSelIndex;
    _curSelIndex = -1;
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:temp inSection:0]]];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];

    UICollectionViewFlowLayout *_layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.itemSize = CGSizeMake(60, 60);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    [self addSubview:_collectionView];
    [_collectionView registerClass:[TZPhotoPreviewCell class] forCellWithReuseIdentifier:@"TZPhotoPreviewCell"];
    [_collectionView registerClass:[TZGifPreviewCell class] forCellWithReuseIdentifier:@"TZGifPreviewCell"];

    _collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);

    _boottomSepView = [UIView new];
    [self addSubview:_boottomSepView];
    _boottomSepView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];

    _curSelIndex = -1;
}

- (void)updateSelected:(NSInteger)curIndex
{
    if (_curSelIndex == curIndex)
    {
        return;
    }
    NSMutableArray<NSIndexPath *> *indexs = @[].mutableCopy;
    if (_curSelIndex >= 0)
    {
        [indexs addObject:[NSIndexPath indexPathForItem:_curSelIndex inSection:0]];
    }
    _curSelIndex = curIndex;
    [indexs addObject:[NSIndexPath indexPathForItem:_curSelIndex inSection:0]];
    [self.collectionView reloadItemsAtIndexPaths:indexs];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self.collectionView scrollToItemAtIndexPath:indexs.lastObject atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    });
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
    _boottomSepView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.viewController.navigationController;
    TZAssetModel *model = _models[indexPath.row];

    TZAssetPreviewCell *cell;
    if (_tzImagePickerVc.allowPickingMultipleVideo && model.type == TZAssetModelMediaTypePhotoGif && _tzImagePickerVc.allowPickingGif)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZGifPreviewCell" forIndexPath:indexPath];
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZPhotoPreviewCell" forIndexPath:indexPath];
        ((TZPhotoPreviewCell *)cell).previewView.isNormalSize = true;
        ((TZPhotoPreviewCell *)cell).previewView.enableDoubleClick = false;
        ((TZPhotoPreviewCell *)cell).previewView.scrollView.scrollEnabled = false;
    }

    cell.model = model;
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (indexPath.item == _curSelIndex)
    {
        cell.coverView.hidden = false;
    }
    else
    {
        cell.coverView.hidden = true;
    }

    @weakify(self);
    cell.singleTapGestureBlock = ^{
        @strongify(self);
        [self routerEventWithName:@"didSelectedModel" userInfo:@{ @"model" : self.models[indexPath.item] }];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[TZPhotoPreviewCell class]])
    {
        [(TZPhotoPreviewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[TZPhotoPreviewCell class]])
    {
        [(TZPhotoPreviewCell *)cell recoverSubviews];
    }
    else if ([cell isKindOfClass:[TZVideoPreviewCell class]])
    {
        [(TZVideoPreviewCell *)cell pausePlayerAndShowNaviBar];
    }
}

@end

@interface TZPhotoPreviewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
{
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
    NSArray *_photosTemp;
    NSArray *_assetsTemp;

    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;

    UIView *_toolBar;

    UIButton *_doneButton;
    UIImageView *_numberImageView;
    UILabel *_numberLabel;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLabel;

    CGFloat _offsetItemCount;

    UIButton *_editButton;
    NNImagePreviewThumbView *_thumbView;
}
@property (nonatomic, assign) BOOL isHideNaviBar;
@property (nonatomic, strong) UIView *cropBgView;
@property (nonatomic, strong) UIView *cropView;

@property (nonatomic, assign) double progress;
@property (strong, nonatomic) id alertView;

/**
 是否是预览
 */
@property (nonatomic, assign) BOOL isPreview;
@end

@implementation TZPhotoPreviewController

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [super routerEventWithName:eventName userInfo:userInfo];

    if ([eventName isEqualToString:@"didSelectedModel"])
    {
        TZAssetModel *model = userInfo[@"model"];
        for (NSInteger i = 0; i < self.models.count; i++)
        {
            if ([self.models[i] isEqual:model])
            {
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                animated:false];
                break;
            }
        }
    }
}

- (void)fetchAssetModels {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [TZImageManager manager].shouldFixOrientation = YES;
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)weakSelf.navigationController;
    
    /// 预览
    if (!self.models.count)
    {
        self.isPreview = YES;
        self.models = [NSMutableArray arrayWithArray:_tzImagePickerVc.selectedModels];
        _assetsTemp = [NSMutableArray arrayWithArray:_tzImagePickerVc.selectedAssets];
        self.isSelectOriginalPhoto = _tzImagePickerVc.isSelectOriginalPhoto;
    }
    /// 查看
    else
    {
        NSMutableArray *temp = self.models.mutableCopy;
        for (NSInteger i = temp.count - 1; i >= 0; i--)
        {
            TZAssetModel *model = temp[i];
            if (!(model.type == TZAssetModelMediaTypePhoto || model.type == TZAssetModelMediaTypePhotoGif))
            {
                [temp removeObject:model];
                if (_currentIndex >= i)
                {
                    _currentIndex -= 1;
                }
                if (_currentIndex < 0)
                {
                    _currentIndex = 0;
                }
            }
        }
        self.models = temp;
    }
    [self configCollectionView];
    [self configCustomNaviBar];
    [self configBottomToolBar];
    [self configThumbView];
    self.view.clipsToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeStatusBarOrientationNotification:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)setPhotos:(NSMutableArray *)photos
{
    _photos = photos;
    _photosTemp = [NSArray arrayWithArray:photos];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (!TZ_isGlobalHideStatusBar)
    {
        if (iOS7Later)
            [UIApplication sharedApplication].statusBarHidden = YES;
    }
    if (_currentIndex)
    {
        [_collectionView setContentOffset:CGPointMake((self.view.tz_width + 20) * _currentIndex, 0) animated:NO];
    }
    else {
        [_collectionView setContentOffset:CGPointMake(1, 0) animated:NO];
        [_collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    [self refreshNaviBarAndBottomBarState];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (!TZ_isGlobalHideStatusBar)
    {
        if (iOS7Later)
            [UIApplication sharedApplication].statusBarHidden = NO;
    }
    [TZImageManager manager].shouldFixOrientation = NO;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)configThumbView
{
    _thumbView = [NNImagePreviewThumbView new];
    [self.view addSubview:_thumbView];
    _thumbView.isPreview = self.isPreview;
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    _thumbView.models = _tzImagePickerVc.selectedModels;
}

- (void)configCustomNaviBar
{
    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;

    _naviBar = [[UIView alloc] initWithFrame:CGRectZero];
    _naviBar.backgroundColor = [UIColor whiteColor];

    _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_backButton setImage:[UIImage imageNamedFromMyBundle:@"navi_back"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];

    _selectButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_selectButton setImage:[UIImage imageNamed:@"ic_picker_nav_n"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"ic_picker_nav_s"] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.hidden = !tzImagePickerVc.showSelectBtn;
    _selectButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);

    [_naviBar addSubview:_selectButton];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}

- (void)configBottomToolBar
{
    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    _toolBar.backgroundColor = [UIColor whiteColor];

    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    if (_tzImagePickerVc.allowPickingOriginalPhoto)
    {
        _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, 43, 0, 0);
        _originalPhotoButton.titleEdgeInsets = UIEdgeInsetsMake(0, -43, 0, 0);

        _originalPhotoButton.backgroundColor = [UIColor clearColor];
        [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_originalPhotoButton setTitle:_tzImagePickerVc.fullImageBtnTitleStr forState:UIControlStateNormal];
        [_originalPhotoButton setTitle:_tzImagePickerVc.fullImageBtnTitleStr forState:UIControlStateSelected];
        [_originalPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_originalPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_originalPhotoButton setImage:[UIImage imageNamed:@"ic_picker_org_n"] forState:UIControlStateNormal];
        [_originalPhotoButton setImage:[UIImage imageNamed:@"ic_picker_org_s"] forState:UIControlStateSelected];

        //        _originalPhotoLabel = [[UILabel alloc] init];
        _originalPhotoLabel.textAlignment = NSTextAlignmentLeft;
        _originalPhotoLabel.font = [UIFont systemFontOfSize:13];
        _originalPhotoLabel.textColor = [UIColor whiteColor];
        _originalPhotoLabel.backgroundColor = [UIColor clearColor];
        if (_isSelectOriginalPhoto)
            [self showPhotoBytes];
    }

    _editButton = [UIButton new];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_editButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_editButton addTarget:self action:@selector(actionEdit) forControlEvents:UIControlEventTouchUpInside];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:_tzImagePickerVc.doneBtnTitleStr forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_doneButton setTitleColor:_tzImagePickerVc.oKButtonTitleColorNormal forState:UIControlStateNormal];

    _numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedFromMyBundle:_tzImagePickerVc.photoNumberIconImageName]];
    _numberImageView.backgroundColor = [UIColor clearColor];
    _numberImageView.hidden = _tzImagePickerVc.selectedModels.count <= 0;

    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:11];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.text = [NSString stringWithFormat:@"%zd", _tzImagePickerVc.selectedModels.count];
    _numberLabel.hidden = _tzImagePickerVc.selectedModels.count <= 0;
    _numberLabel.backgroundColor = [UIColor clearColor];

    [_originalPhotoButton addSubview:_originalPhotoLabel];
    [_toolBar addSubview:_editButton];
    [_toolBar addSubview:_doneButton];
    [_toolBar addSubview:_originalPhotoButton];
    [_toolBar addSubview:_numberImageView];
    [_toolBar addSubview:_numberLabel];
    [self.view addSubview:_toolBar];
}

- (void)configCollectionView
{
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.models.count * (self.view.tz_width + 20), 0);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TZPhotoPreviewCell class] forCellWithReuseIdentifier:@"TZPhotoPreviewCell"];
    [_collectionView registerClass:[TZVideoPreviewCell class] forCellWithReuseIdentifier:@"TZVideoPreviewCell"];
    [_collectionView registerClass:[TZGifPreviewCell class] forCellWithReuseIdentifier:@"TZGifPreviewCell"];
}

- (void)configCropView
{
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    if (!_tzImagePickerVc.showSelectBtn && _tzImagePickerVc.allowCrop)
    {
        [_cropView removeFromSuperview];
        [_cropBgView removeFromSuperview];
        
        _cropBgView = [UIView new];
        _cropBgView.userInteractionEnabled = NO;
        _cropBgView.frame = self.view.bounds;
        _cropBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_cropBgView];
        [TZImageCropManager overlayClippingWithView:_cropBgView cropRect:_tzImagePickerVc.cropRect containerView:self.view needCircleCrop:_tzImagePickerVc.needCircleCrop];

        _cropView = [UIView new];
        _cropView.userInteractionEnabled = NO;
        _cropView.frame = _tzImagePickerVc.cropRect;
        _cropView.backgroundColor = [UIColor clearColor];
        _cropView.layer.borderColor = [UIColor whiteColor].CGColor;
        _cropView.layer.borderWidth = 1.0;
        if (_tzImagePickerVc.needCircleCrop)
        {
            _cropView.layer.cornerRadius = _tzImagePickerVc.cropRect.size.width / 2;
            _cropView.clipsToBounds = YES;
        }
        [self.view addSubview:_cropView];
        if (_tzImagePickerVc.cropViewSettingBlock)
        {
            _tzImagePickerVc.cropViewSettingBlock(_cropView);
        }
        
        [self.view bringSubviewToFront:_naviBar];
        [self.view bringSubviewToFront:_toolBar];
        _editButton.hidden = YES;
    }
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;

    _naviBar.frame = CGRectMake(0, 0, self.view.tz_width, 64);
    _backButton.frame = CGRectMake(10, 20, 44, 44);
    _selectButton.frame = CGRectMake(self.view.tz_width - 54, 20, 42, 42);

    _layout.itemSize = CGSizeMake(self.view.tz_width + 20, self.view.tz_height);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _collectionView.frame = CGRectMake(-10, 0, self.view.tz_width + 20, self.view.tz_height);
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0)
    {
        CGFloat offsetX = _offsetItemCount * _layout.itemSize.width;
        [_collectionView setContentOffset:CGPointMake(offsetX, 0)];
    }
    if (_tzImagePickerVc.allowCrop)
    {
        [_collectionView reloadData];
    }

    _toolBar.frame = CGRectMake(0, self.view.tz_height - 40, self.view.tz_width, 40);
    _thumbView.frame = CGRectMake(0, CGRectGetMinY(_toolBar.frame) - 80, self.view.tz_width, 80);

    if (_tzImagePickerVc.allowPickingOriginalPhoto)
    {
        CGFloat fullImageWidth = [_tzImagePickerVc.fullImageBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                                                     options:NSStringDrawingUsesFontLeading
                                                                                  attributes:@{
                                                                                      NSFontAttributeName : [UIFont systemFontOfSize:13]
                                                                                  }
                                                                                     context:nil]
                                     .size.width;
        _originalPhotoButton.frame = CGRectMake(self.view.tz_centerX - (fullImageWidth + 56) / 2, 0, fullImageWidth + 56, CGRectGetHeight(_toolBar.frame));
        _originalPhotoLabel.frame = CGRectMake(fullImageWidth + 42, 0, 80, CGRectGetHeight(_toolBar.frame));
    }
    _doneButton.frame = CGRectMake(self.view.tz_width - 44 - 12, 0, 44, CGRectGetHeight(_toolBar.frame));
    _numberImageView.frame = CGRectMake(CGRectGetMinX(_doneButton.frame) - 20 + 5, 10, 20, 20);
    _numberLabel.frame = _numberImageView.frame;
    _editButton.frame = CGRectMake(0, 0, 60, CGRectGetHeight(_toolBar.frame));

    [self configCropView];
}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti
{
    _offsetItemCount = _collectionView.contentOffset.x / _layout.itemSize.width;
}

#pragma mark - Click Event


/// 设置当前 图片是否为选中状态
- (void)setSelected:(BOOL)isSel {
    
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    TZAssetModel *model = _models[_currentIndex];
    if (isSel)
    {
        // 1. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
        if (_tzImagePickerVc.selectedModels.count >= _tzImagePickerVc.maxImagesCount)
        {
            NSString *title = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Select a maximum of %zd photos"], _tzImagePickerVc.maxImagesCount];
            [_tzImagePickerVc showAlertWithTitle:title];
            return;
            // 2. if not over the maxImagesCount / 如果没有超过最大个数限制
        }
        else
        {
            if (![_tzImagePickerVc.selectedModels containsObject:model]) {
                [_tzImagePickerVc.selectedModels addObject:model];
                [_tzImagePickerVc.selectedAssets addObject:model.asset];
            }
//            if (self.photos)
//            {
//                [_tzImagePickerVc.selectedAssets addObject:_assetsTemp[_currentIndex]];
//                [self.photos addObject:_photosTemp[_currentIndex]];
//            }
            
            if (model.type == TZAssetModelMediaTypeVideo && !_tzImagePickerVc.allowPickingMultipleVideo)
            {
                if (model.type == TZAssetModelMediaTypeVideo && !_tzImagePickerVc.allowPickingMultipleVideo)
                {
                    if (_tzImagePickerVc.selectedModels.count > 0)
                    {
                        [NSObject showError:@"不可同时选择视频和图片"];
                        return;
                    }
                }
            }
        }
    }
    else
    {
        NSArray *selectedModels = [NSArray arrayWithArray:_tzImagePickerVc.selectedModels];
        for (TZAssetModel *model_item in selectedModels)
        {
            if ([[[TZImageManager manager] getAssetIdentifier:model.asset] isEqualToString:[[TZImageManager manager] getAssetIdentifier:model_item.asset]])
            {
                // 1.6.7版本更新:防止有多个一样的model,一次性被移除了
                NSArray *selectedModelsTmp = [NSArray arrayWithArray:_tzImagePickerVc.selectedModels];
                for (NSInteger i = 0; i < selectedModelsTmp.count; i++)
                {
                    TZAssetModel *model = selectedModelsTmp[i];
                    if ([model isEqual:model_item])
                    {
                        [_tzImagePickerVc.selectedModels removeObjectAtIndex:i];
                        [_tzImagePickerVc.selectedAssets removeObjectAtIndex:i];
                        break;
                    }
                }
                break;
            }
        }
    }
    model.isSelected = isSel;
    [self refreshNaviBarAndBottomBarState];
    
    [UIView showOscillatoryAnimationWithLayer:_numberImageView.layer type:TZOscillatoryAnimationToSmaller];
    [_thumbView setModels:_tzImagePickerVc.selectedModels];
}

- (void)select:(UIButton *)selectButton
{
    [self setSelected:!selectButton.isSelected];
}

- (void)backButtonClick
{
    if (self.navigationController.childViewControllers.count < 2)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:^ {
//            imagePickerControllerDidCancelHandle
            TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
            if (_tzImagePickerVc.imagePickerControllerDidCancelHandle) {
                _tzImagePickerVc.imagePickerControllerDidCancelHandle();
            }
        }];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.backButtonClickBlock)
    {
        self.backButtonClickBlock(_isSelectOriginalPhoto);
    }
}

- (void)actionEdit {
    TZAssetModel *model = _models[_currentIndex];
    [[TZImageManager manager] getOriginalPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info) {
        [NNImageEditObject gotoEditImageWithImage:photo from:self complete:^(UIImage *image) {
//            [self setSelected:YES];
//            [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_currentIndex inSection:0]]];
//            [_thumbView.collectionView reloadData];
            /// 直接打开预览
            if (self.doneButtonClickBlockWithPreviewType) {
                self.doneButtonClickBlockWithPreviewType(@[image], model.asset, self.isSelectOriginalPhoto);
            }
            /// 打开图库
            else {
                TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                   
                    if (_tzImagePickerVc.didFinishPickingPhotosHandle) {
                        _tzImagePickerVc.didFinishPickingPhotosHandle(@[image],model.asset,self.isSelectOriginalPhoto);
                    }
                    
                }];
            }
        }];
    }];
}

- (void)doneButtonClick
{
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    if (_tzImagePickerVc.selectedModels.count <= 0) {
        return;
    }
    
    // 如果图片正在从iCloud同步中,提醒用户
    if (_progress > 0 && _progress < 1 && (_selectButton.isSelected || !_tzImagePickerVc.selectedModels.count))
    {
        _alertView = [_tzImagePickerVc showAlertWithTitle:[NSBundle tz_localizedStringForKey:@"Synchronizing photos from iCloud"]];
        return;
    }
    // 如果没有选中过照片 点击确定时选中当前预览的照片
    if (_tzImagePickerVc.selectedModels.count == 0 && _tzImagePickerVc.minImagesCount <= 0)
    {
        TZAssetModel *model = _models[_currentIndex];
        [_tzImagePickerVc.selectedModels addObject:model];
    }
    if (_tzImagePickerVc.allowCrop)
    { // 裁剪状态
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
        TZPhotoPreviewCell *cell = (TZPhotoPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        UIImage *cropedImage =
            [TZImageCropManager cropImageView:cell.previewView.imageView toRect:_tzImagePickerVc.cropRect zoomScale:cell.previewView.scrollView.zoomScale containerView:self.view];
        if (_tzImagePickerVc.needCircleCrop)
        {
            cropedImage = [TZImageCropManager circularClipImage:cropedImage];
        }
        if (self.doneButtonClickBlockCropMode)
        {
            TZAssetModel *model = _models[_currentIndex];
            self.doneButtonClickBlockCropMode(cropedImage, model.asset);
        }
    }
    else if (self.doneButtonClickBlock)
    { // 非裁剪状态
        self.doneButtonClickBlock(_isSelectOriginalPhoto);
    }
    if (self.doneButtonClickBlockWithPreviewType)
    {
        
        NSMutableArray *rslt = @[].mutableCopy;
        for (id asset in _tzImagePickerVc.selectedAssets) {
            if (self.isSelectOriginalPhoto) {
                [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info) {
                    [rslt addObject:photo];
                    if (rslt.count == _tzImagePickerVc.selectedAssets.count) {
                        self.doneButtonClickBlockWithPreviewType(rslt, _tzImagePickerVc.selectedAssets, self.isSelectOriginalPhoto);
                    }
                }];
            }
            else {
                [[TZImageManager manager] getPhotoWithAsset:asset photoWidth:750 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                    if (!isDegraded) {
                        [rslt addObject:photo];
                        if (rslt.count == _tzImagePickerVc.selectedAssets.count) {
                            self.doneButtonClickBlockWithPreviewType(rslt, _tzImagePickerVc.selectedAssets, self.isSelectOriginalPhoto);
                        }
                    }
                }];
            }
        }
    }
}

- (void)originalPhotoButtonClick
{
    _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
    _isSelectOriginalPhoto = _originalPhotoButton.isSelected;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
    if (_isSelectOriginalPhoto)
    {
        [self showPhotoBytes];
        if (!_selectButton.isSelected)
        {
            // 如果当前已选择照片张数 < 最大可选张数 && 最大可选张数大于1，就选中该张图
            TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
            if (_tzImagePickerVc.selectedModels.count < _tzImagePickerVc.maxImagesCount && _tzImagePickerVc.showSelectBtn)
            {
                [self setSelected:YES];
            }
        }
    }
}

- (void)didTapPreviewCell
{
    self.isHideNaviBar = !self.isHideNaviBar;
    _naviBar.hidden = self.isHideNaviBar;
    _toolBar.hidden = self.isHideNaviBar;
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;

    if (_tzImagePickerVc.selectedModels.count > 0) {
        _thumbView.hidden = self.isHideNaviBar;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth + ((self.view.tz_width + 20) * 0.5);

    NSInteger currentIndex = offSetWidth / (self.view.tz_width + 20);

    if (currentIndex < _models.count && _currentIndex != currentIndex)
    {
        _currentIndex = currentIndex;
        [self refreshNaviBarAndBottomBarState];
    }
    [_thumbView setPreviewModel:self.models[_currentIndex]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoPreviewCollectionViewDidScroll" object:nil];
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    TZAssetModel *model = _models[indexPath.row];

    TZAssetPreviewCell *cell;
    __weak typeof(self) weakSelf = self;
    if (_tzImagePickerVc.allowPickingMultipleVideo && model.type == TZAssetModelMediaTypeVideo)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZVideoPreviewCell" forIndexPath:indexPath];
    }
    else if (_tzImagePickerVc.allowPickingMultipleVideo && model.type == TZAssetModelMediaTypePhotoGif && _tzImagePickerVc.allowPickingGif)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZGifPreviewCell" forIndexPath:indexPath];
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZPhotoPreviewCell" forIndexPath:indexPath];
        TZPhotoPreviewCell *photoPreviewCell = (TZPhotoPreviewCell *)cell;
        photoPreviewCell.cropRect = _tzImagePickerVc.cropRect;
        photoPreviewCell.allowCrop = _tzImagePickerVc.allowCrop;
        __weak typeof(_tzImagePickerVc) weakTzImagePickerVc = _tzImagePickerVc;
        __weak typeof(_collectionView) weakCollectionView = _collectionView;
        __weak typeof(photoPreviewCell) weakCell = photoPreviewCell;
        [photoPreviewCell setImageProgressUpdateBlock:^(double progress) {
          weakSelf.progress = progress;
          if (progress >= 1)
          {
              if (weakSelf.alertView && [weakCollectionView.visibleCells containsObject:weakCell])
              {
                  [weakTzImagePickerVc hideAlertView:weakSelf.alertView];
                  weakSelf.alertView = nil;
                  [weakSelf doneButtonClick];
              }
          }
        }];
    }

    cell.model = model;
    [cell setSingleTapGestureBlock:^{
      [weakSelf didTapPreviewCell];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[TZPhotoPreviewCell class]])
    {
        [(TZPhotoPreviewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[TZPhotoPreviewCell class]])
    {
        [(TZPhotoPreviewCell *)cell recoverSubviews];
    }
    else if ([cell isKindOfClass:[TZVideoPreviewCell class]])
    {
        [(TZVideoPreviewCell *)cell pausePlayerAndShowNaviBar];
    }
}

#pragma mark - Private Method

- (void)dealloc
{
    // NSLog(@"%@ dealloc",NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshNaviBarAndBottomBarState
{
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    TZAssetModel *model = _models[_currentIndex];
    _selectButton.selected = model.isSelected;
    _numberLabel.text = [NSString stringWithFormat:@"%zd", _tzImagePickerVc.selectedModels.count];
    _numberImageView.hidden = (_tzImagePickerVc.selectedModels.count <= 0 || _isHideNaviBar || _isCropImage);
    _numberLabel.hidden = (_tzImagePickerVc.selectedModels.count <= 0 || _isHideNaviBar || _isCropImage);

    _originalPhotoButton.selected = _isSelectOriginalPhoto;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
    if (_isSelectOriginalPhoto)
        [self showPhotoBytes];

    // If is previewing video, hide original photo button
    // 如果正在预览的是视频，隐藏原图按钮
    if (!_isHideNaviBar)
    {
        if (model.type == TZAssetModelMediaTypeVideo)
        {
            _originalPhotoButton.hidden = YES;
            _originalPhotoLabel.hidden = YES;
        }
        else
        {
            _originalPhotoButton.hidden = NO;
            if (_isSelectOriginalPhoto)
                _originalPhotoLabel.hidden = NO;
        }
    }

    _doneButton.hidden = NO;
    _selectButton.hidden = !_tzImagePickerVc.showSelectBtn;
    // 让宽度/高度小于 最小可选照片尺寸 的图片不能选中
    if (![[TZImageManager manager] isPhotoSelectableWithAsset:model.asset])
    {
        _numberLabel.hidden = YES;
        _numberImageView.hidden = YES;
        _selectButton.hidden = YES;
        _originalPhotoButton.hidden = YES;
        _originalPhotoLabel.hidden = YES;
        _doneButton.hidden = YES;
    }
    
    [_doneButton setEnabled:(_tzImagePickerVc.selectedModels.count > 0)];
    
    if (self.isPreview) {
        if (_tzImagePickerVc.selectedModels.count <= 1) {
            if (_tzImagePickerVc.selectedModels.count == 0) {
                [_editButton setEnabled:true];
            }
            else {
                if (model.isSelected) {
                    [_editButton setEnabled:true];
                }
                else {
                    [_editButton setEnabled:false];
                }
            }
        }
        else {
            [_editButton setEnabled:false];
        }
    }
    else {
        if (_tzImagePickerVc.selectedModels.count <= 1) {
            [_editButton setEnabled:true];
        }
        else {
            [_editButton setEnabled:false];
        }
    }
}

- (void)showPhotoBytes {
    [[TZImageManager manager] getPhotosBytesWithArray:@[_models[_currentIndex]] completion:^(NSString *totalBytes) {
        _originalPhotoLabel.text = [NSString stringWithFormat:@"(%@)",totalBytes];
    }];
}

@end

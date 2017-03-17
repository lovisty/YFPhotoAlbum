//
//  YFPhotoKitAlbumViewController.m
//  NicePro
//
//  Created by Yafei on 2017/2/4.
//  Copyright © 2017年 boohee. All rights reserved.
//

#define ColumnCount 3

#import "YFPhotoKitAlbumViewController.h"
#import "YFPhotoAlbumManger.h"
#import "YFPhotoAlbumModel.h"
#import "YFPhotoAlbumCollectionViewCell.h"
#import "YFTargetPhotosPreviewViewController.h"
//#import "UIViewController+PXTableViewEmpty.h"
#import "YFPhotoModel.h"

static CGSize CGSizeScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}

@interface YFPhotoKitAlbumViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) YFPhotoAlbumManger *manger;
@property (nonatomic, strong) YFPhotoAlbumModel *model;
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, assign) BOOL showStatus;

@property (nonatomic, strong) PHAssetCollection *currentGroup;
@property (nonatomic, assign) NSInteger lastIndexItem;
@property (nonatomic, assign) CGRect previousPreheatRect;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@end

@implementation YFPhotoKitAlbumViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadView{
    [super loadView];
    
    self.shadeView = [[UIView alloc] init];
    self.shadeView.backgroundColor = [UIColor blackColor];
    self.shadeView.hidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildNavigationItem];
    
    self.manger = [[YFPhotoAlbumManger alloc]init];
    
    if (!self.selectedAssets) {
        self.selectedAssets = [NSMutableArray array];
    }
    [self.view addSubview:self.shadeView];
    self.shadeView.frame = self.view.frame;
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self requestPhotos];
            }else{
                dispatch_sync(dispatch_get_main_queue(), ^(){
                    self.tipLabel.hidden = NO;
                });
                
            }
        }];
    }else if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied){
        self.tipLabel.hidden = NO;
    }else if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){
        self.tipLabel.hidden = YES;
        [self requestPhotos];
    }
}

- (void)requestPhotos{
    
    [self updateCachedAssets];
    
    __weak __typeof(self) weakSelf = self;
    [self.manger allGroupInfo:^(NSArray *groupArray) {
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.groups = groupArray;
        BOOL isMain = [[NSThread currentThread] isMainThread];
        if (isMain) {
            [strongSelf reloadCollectionView];
        }else{
            [strongSelf performSelector:@selector(reloadCollectionView) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        }
    }];
}

- (void)reloadCollectionView{
    NSLog(@" 当前线程  %@",[NSThread currentThread]);
    self.navigationItem.titleView = self.titleSwitcher;
    self.photoAlbumView.listArray = [[[NSMutableArray alloc] initWithArray:[YFPhotoAlbumModel transformPHAssetCollectionToModelFrom:self.groups]] copy];
    [self.view bringSubviewToFront:self.photoAlbumView];
    [self.photoAlbumView reload];
    if (self.groups.count>0) {
        self.currentGroup = [self.groups firstObject];
        self.fetchResult = [self.manger theFetchResultPhotoInAssetCollection:self.currentGroup];
        [self.titleSwitcher setTitle:self.currentGroup.localizedTitle];
    }else{
        [self.titleSwitcher setTitle:@""];
    }
    [self.photoBottomView configDataWithCount:self.selectedAssets.count];
    [self.collectionView reloadData];
}

- (void)downButtonTouched:(UIButton *)button {
    button.selected = !button.selected;
    if (self.showStatus) {
        [self.photoAlbumView dismissWithView:self.shadeView];
    }else{
        [self.photoAlbumView showWithView:self.shadeView];
    }
    self.showStatus = !self.showStatus;
}
- (void)buildNavigationItem
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:98/255 green:204/255 blue:116/255 alpha:1] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(finished) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fetchResult.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YFPhotoAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YFPhotoAlbumCollectionViewCell class]) forIndexPath:indexPath];
    cell.tag = indexPath.item;
    __block BOOL marked = NO;
    if (indexPath.row == 0) {
        UIImage *camera = [UIImage imageNamed:@"yf_camera"];
        YFPhotoModel *model = [YFPhotoModel new];
        model.image = camera;
        model.isSelected = NO;
        
        cell.photoImageView.image = model.image;
        cell.selectedImageView.hidden = YES;
    }else {
        __weak __typeof(self) weakSelf = self;
        PHAsset *asset = self.fetchResult[self.fetchResult.count-indexPath.item];
        
        [self.manger thePreviewPhotoInPHAsset:asset PHImageInfo:^(UIImage *photo, PHAsset *asset) {
            if (cell.tag == indexPath.item) {
                cell.photoImageView.image = photo;
            }
            cell.selectedImageView.hidden = NO;
            for (PHAsset *tempAssert in weakSelf.selectedAssets) {
                if ([self.manger isSamePhotoBetweenAsset1:tempAssert withAsset2:asset]) {
                    self.lastIndexItem = indexPath.item;
                    marked = YES;
                    break;
                }
            }
            if (marked) {
                cell.selectedImageView.image = [UIImage imageNamed:@"yf_pick_image_selected"];
            }else{
                cell.selectedImageView.image = [UIImage imageNamed:@"yf_pick_image_unselected"];
            }
            
        }];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width - (ColumnCount+1)*3)/ColumnCount, (self.view.frame.size.width - (ColumnCount+1)*3)/ColumnCount);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (![self canContinueSelect] && self.maxCount>1){
            if (self.amountBeyondBlock) {
                self.amountBeyondBlock();
            }
        }else{
            [self openCamera];
        }
        self.lastIndexItem = indexPath.item;
    }else {
        PHAsset *asset = self.fetchResult[self.fetchResult.count-indexPath.item];
        
        BOOL marked = NO;
        for (PHAsset *tempAssert in self.selectedAssets) {
            if ([self.manger isSamePhotoBetweenAsset1:tempAssert withAsset2:asset]) {
                marked = YES;
                break;
            }
        }
        
        if (![self canContinueSelect] && !marked && self.maxCount>1){
            if (self.amountBeyondBlock) {
                self.amountBeyondBlock();
            }
            return;
        }
        
        if (marked) {
            NSInteger index = [self indexOfObject:asset fromArray:self.selectedAssets];
            [self.selectedAssets removeObjectAtIndex:index];
        }else{
            __weak __typeof(self) weakSelf = self;
            [self.manger isICloudPhotoInAsset:asset PHICloudInfo:^(NSNumber *isICloud) {
                __strong __typeof(self) strongSelf = weakSelf;
                if (![isICloud boolValue]) {
                    if (strongSelf.maxCount<=1 && strongSelf.lastIndexItem>0) {
                        YFPhotoAlbumCollectionViewCell *cell = (YFPhotoAlbumCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.lastIndexItem inSection:0]];
                        cell.selectedImageView.image = [UIImage imageNamed:@"yf_pick_image_unselected"];
                        [strongSelf.selectedAssets removeAllObjects];
                    }
                    [strongSelf.selectedAssets addObject:asset];
                    
                    self.lastIndexItem = indexPath.item;
                    
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"图片不可用" message:@"该图片资源在iCloud上，请到手机相册里下载，然后重新进入该页面选择" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        }
        [self.photoBottomView configDataWithCount:self.selectedAssets.count];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}



- (NSInteger)indexOfObject:(PHAsset *)asset fromArray:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        PHAsset *tempAsset = array[i];
        if([tempAsset isKindOfClass:[PHAsset class]]){
            NSString *url1 = tempAsset.localIdentifier;
            NSString *url2 = asset.localIdentifier;
            if ([url1 isEqual:url2]) {
                return i;
            }
        }
    }
    return 0;
}

- (void)openCamera
{
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (self.isIdCard) {
        CGFloat height = ([[UIScreen mainScreen] bounds].size.width-40)*820/1308;
        
        UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height-height)/2-60, [[UIScreen mainScreen] bounds].size.width, height+50)];
        UIImageView *overLayImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, [[UIScreen mainScreen] bounds].size.width-40, height)];
        overLayImg.image = [UIImage imageNamed:@"img_scan"];
        [cardView addSubview:overLayImg];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, overLayImg.frame.origin.y+overLayImg.frame.size.height+20, [[UIScreen mainScreen] bounds].size.height-40, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"请将身份证放入框内拍摄";
        label.textColor = [UIColor colorWithRed:36/255 green:255/255 blue:90/255 alpha:1.0];
        [cardView addSubview:label];
        
        imagePickerVC.cameraOverlayView = cardView;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)switchAssetsGroup:(YFPhotoAlbumModel *)model{
    [self.photoAlbumView dismissWithView:self.shadeView];
    self.showStatus = NO;
    if (self.currentGroup == model.assetCollection) {
        return;
    }
    self.currentGroup = model.assetCollection;
    self.fetchResult = [self.manger theFetchResultPhotoInAssetCollection:self.currentGroup];
    PHAssetCollection *assetCollection = self.currentGroup;
    [self.titleSwitcher setTitle:assetCollection.localizedTitle];
    [self.collectionView reloadData];
}
- (BOOL)canContinueSelect{
    //不设置默认是只能选一张
    if (self.maxCount <= 0) {
        self.maxCount = 1;
    }
    if (self.selectedAssets.count>=self.maxCount) {
        return NO;
    }
    return YES;
}
- (void)finished{
    
    if (self.selectedAssets.count > 0) {
        if (self.assetsResultBlock) {
            //预防bug
            if (self.maxCount == 1 && self.selectedAssets.count>1) {
                NSArray *tempArray = [[NSArray alloc] initWithObjects:[self.selectedAssets lastObject],nil];
                [self.selectedAssets removeAllObjects];
                [self.selectedAssets addObjectsFromArray:tempArray];
                tempArray = nil;
            }
            self.assetsResultBlock(self.selectedAssets);
            [self.selectedAssets removeAllObjects];
            self.selectedAssets = nil;
            self.assetsResultBlock = nil;
        }
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)previewButtonClick{
    
    YFTargetPhotosPreviewViewController *vc = [[YFTargetPhotosPreviewViewController alloc]init];
    vc.assets = self.selectedAssets;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self.selectedAssets addObject:image];
    
    if (self.assetsResultBlock) {
        //预防bug
        if (self.maxCount == 1 && self.selectedAssets.count>1) {
            NSArray *tempArray = [[NSArray alloc] initWithObjects:[self.selectedAssets lastObject],nil];
            [self.selectedAssets removeAllObjects];
            [self.selectedAssets addObjectsFromArray:tempArray];
            tempArray = nil;
        }
        self.assetsResultBlock(self.selectedAssets);
    }
    __weak __typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:NO completion:^{
        __strong __typeof(self) strongSelf = weakSelf;
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (PHCachingImageManager *)imageManager
{
    if (_imageManager == nil) {
        _imageManager = [PHCachingImageManager new];
    }
    
    return _imageManager;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateCachedAssets];
}

- (void)updateCachedAssets{
    BOOL isViewVisible = [self isViewLoaded] && self.view.window != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0, -0.5 * CGRectGetHeight(preheatRect));
    
    // If scrolled by a "reasonable" amount...
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0) {
        // Compute the assets to start caching and to stop caching
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self qb_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        } removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self qb_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        CGSize itemSize = CGSizeMake(([[UIScreen mainScreen] bounds].size.width-15)/3, ([[UIScreen mainScreen] bounds].size.width-15)/3);
        CGSize targetSize = CGSizeScale(itemSize, self.traitCollection.displayScale);
        
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:targetSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:targetSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        self.previousPreheatRect = preheatRect;
    }
    
    
}

- (NSArray *)qb_indexPathsForElementsInRect:(CGRect)rect
{
    NSArray *allLayoutAttributes = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect addedHandler:(void (^)(CGRect addedRect))addedHandler removedHandler:(void (^)(CGRect removedRect))removedHandler
{
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths
{
    if (indexPaths.count == 0) { return nil; }
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.item < self.fetchResult.count && indexPath.item != 0) {
            PHAsset *asset = self.fetchResult[self.fetchResult.count-indexPath.item];
            [assets addObject:asset];
        }
    }
    return assets;
}
@end

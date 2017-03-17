
//
//  YFALAssertLibraryViewController.m
//  NicePro
//
//  Created by Yafei on 2017/2/4.
//  Copyright © 2017年 boohee. All rights reserved.
//

#define ColumnCount 3

#import "YFALAssertLibraryViewController.h"
#import "YFPhotoAlbumManger.h"
#import "YFSelectPhotoAlbumView.h"
#import "YFPhotoAlbumModel.h"
#import "YFPhotoAlbumCollectionViewCell.h"
#import "YFTargetPhotosPreviewViewController.h"
//#import "UIViewController+PXTableViewEmpty.h"
#import "YFPhotoModel.h"

@interface YFALAssertLibraryViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) YFPhotoAlbumManger *manger;
@property (nonatomic, strong) YFPhotoAlbumModel *model;
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) NSMutableArray *assetsImages;
@property (nonatomic, assign) BOOL showStatus;

@property (nonatomic, assign) NSInteger lastIndexItem;
@property (nonatomic, strong) ALAssetsGroup *currentGroup;

@end

@implementation YFALAssertLibraryViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self buildNavigationItem];
    self.manger = [[YFPhotoAlbumManger alloc]init];
    self.assetsImages = [NSMutableArray array];
    
    if (!self.selectedAssets) {
        self.selectedAssets = [NSMutableArray array];
    }
    
    self.tipLabel.hidden = NO;
    
    __weak __typeof(self) weakSelf = self;
    [self.manger allPhotoGroup:ALAssetsGroupAll assetsLibraryInfo:^(NSArray *groupArray) {
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.groups = groupArray;
        strongSelf.navigationItem.titleView = strongSelf.titleSwitcher;
        if (strongSelf.groups.count>0) {
            strongSelf.tipLabel.hidden = YES;
            [strongSelf.titleSwitcher setTitle:@"所有照片"];
        }else{
            [strongSelf.titleSwitcher setTitle:@""];
        }
        strongSelf.photoAlbumView.listArray = [[[NSMutableArray alloc] initWithArray:[YFPhotoAlbumModel transformALAssetsGroupToModelFrom:self.groups]] copy];
        [strongSelf.view bringSubviewToFront:strongSelf.photoAlbumView];
        [strongSelf.photoAlbumView reload];
    } ALAssetsoInfo:^(NSArray *photoArray) {
        __strong __typeof(self) strongSelf = weakSelf;
        UIImage *camera = [UIImage imageNamed:@"yf_camera"];
        YFPhotoModel *model = [YFPhotoModel new];
        model.image = camera;
        [strongSelf.assetsImages addObject:model];
        [photoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
            __strong __typeof(self) strongSelf = weakSelf;
            ALAsset *asset = obj;
            YFPhotoModel *model = [YFPhotoModel new];
            model.asset = asset;
            [strongSelf.assetsImages addObject:model];
        }];
        [strongSelf.collectionView reloadData];
    }];
}

- (void)downButtonTouched:(UIButton *)button {
    
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
    return [self.assetsImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YFPhotoAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YFPhotoAlbumCollectionViewCell class]) forIndexPath:indexPath];
    
    YFPhotoModel *model = [self.assetsImages objectAtIndex:indexPath.row];
    BOOL marked = NO;
    
    for (ALAsset *tempAssert in self.selectedAssets) {
        if (tempAssert && [tempAssert isKindOfClass:[ALAsset class]]) {
            NSString *url = [[tempAssert valueForProperty:ALAssetPropertyAssetURL] absoluteString];
            NSString *url2 = [[model.asset valueForProperty:ALAssetPropertyAssetURL] absoluteString];
            if ([url isEqualToString:url2]) {
                marked = YES;
                self.lastIndexItem = indexPath.item;
            }
        }
    }
    if (indexPath.row == 0) {
        cell.photoImageView.image = model.image;
        cell.selectedImageView.hidden = YES;
    }else {
        cell.photoImageView.image = [UIImage imageWithCGImage:[model.asset thumbnail]];
        cell.selectedImageView.hidden = NO;
    }
    if (marked) {
        cell.selectedImageView.image = [UIImage imageNamed:@"yf_pick_image_selected"];
    }else{
        cell.selectedImageView.image = [UIImage imageNamed:@"yf_pick_image_unselected"];
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
        
    }else {
        BOOL marked = NO;
        YFPhotoModel *model = [self.assetsImages objectAtIndex:indexPath.row];
        for (ALAsset *tempAssert in self.selectedAssets) {
            if ([self.manger isSamePhotoBetweenAsset1:tempAssert withAsset2:model.asset]) {
                marked = YES;
            }
        }
        
        if (![self canContinueSelect] && !marked && self.maxCount>1){
            if (self.amountBeyondBlock) {
                self.amountBeyondBlock();
            }
            return;
        }
        
        ALAsset *asset = model.asset;
        if (marked) {
            NSInteger index = [self indexOfObject:asset fromArray:self.selectedAssets];
            [self.selectedAssets removeObjectAtIndex:index];
        }else{
            ALAssetRepresentation* representation = [asset defaultRepresentation];
            UIImage *image =  [representation fullScreenImage];
            if (image) {
                if (self.maxCount<=1 && self.lastIndexItem>0) {
                    YFPhotoAlbumCollectionViewCell *cell = (YFPhotoAlbumCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.lastIndexItem inSection:0]];
                    cell.selectedImageView.image = [UIImage imageNamed:@"yf_pick_image_unselected"];
                    [self.selectedAssets removeAllObjects];
                }
                [self.selectedAssets addObject:asset];
                
                self.lastIndexItem = indexPath.item;
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"图片不可用" message:@"该图片资源在iCloud上，请到手机相册里下载，然后重新进入该页面选择" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        [self.photoBottomView configDataWithCount:self.selectedAssets.count];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (NSInteger)indexOfObject:(ALAsset *)asset fromArray:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        ALAsset *tempAsset = array[i];
        if ([self.manger isSamePhotoBetweenAsset1:tempAsset withAsset2:asset]) {
            return i;
        }
    }
    return 0;
}

- (void)openCamera
{
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //不支持拍照
        return;
    }
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)switchAssetsGroup:(YFPhotoAlbumModel *)model{
    [self.photoAlbumView dismissWithView:self.shadeView];
    self.showStatus = NO;
    
    ALAssetsGroup *group = model.group;
    
    if (self.currentGroup == group) {
        return;
    }
    [self.titleSwitcher setTitle:[group valueForProperty:ALAssetsGroupPropertyName]];
    self.currentGroup = group ;
    [self.assetsImages removeAllObjects];
    
    __weak __typeof(self) weakSelf = self;
    [self.manger allPhotoInALAssetsGroup:group ALAssetsoInfo:^(NSArray *photoArray) {
        __strong __typeof(self) strongSelf = weakSelf;
        UIImage *camera = [UIImage imageNamed:@"yf_camera"];
        YFPhotoModel *model = [YFPhotoModel new];
        model.image = camera;
        [strongSelf.assetsImages addObject:model];
        
        
        [photoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
            __strong __typeof(self) strongSelf = weakSelf;
            ALAsset *asset = obj;
            YFPhotoModel *model = [YFPhotoModel new];
            model.asset = asset;
            [strongSelf.assetsImages addObject:model];
        }];
        [strongSelf.collectionView reloadData];
    }];
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

@end

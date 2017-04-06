//
//  YFCustomPhotoAlbumViewController.m
//  Phoenix
//
//  Created by YaFei on 16/4/19.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#define ColumnCount 3
#define iOSVersionGreaterThan(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)


#import "YFCustomPhotoAlbumViewController.h"
#import "YFALAssertLibraryViewController.h"
#import "YFPhotoKitAlbumViewController.h"

@interface YFCustomPhotoAlbumViewController ()<YFSelectPhotoAlbumViewDelegate>

@end

@implementation YFCustomPhotoAlbumViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.shadeView = [[UIView alloc] init];
        self.shadeView.backgroundColor = [UIColor blackColor];
        self.shadeView.hidden = YES;
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
     self.navigationItem.titleView = self.titleSwitcher;
    
    YFCHTCollectionViewWaterfallLayout *layout = [YFCHTCollectionViewWaterfallLayout new];
    layout.columnCount = ColumnCount;
    layout.minimumColumnSpacing = 3;
    layout.sectionInset = UIEdgeInsetsMake(3, 3, 0, 1.5);
    layout.minimumInteritemSpacing = 3;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[YFPhotoAlbumCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YFPhotoAlbumCollectionViewCell class])];

    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height-64-50);
    [self.view addSubview:self.collectionView];
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    
    self.photoBottomView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 64 - 50, self.view.frame.size.width, 50);
    
    [self.view addSubview:self.photoBottomView];

    [self.view addSubview:self.photoAlbumView];
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height/2-80, [[UIScreen mainScreen] bounds].size.width-60, 80)];
    self.tipLabel.hidden = YES;
    self.tipLabel.textColor = [UIColor darkGrayColor];
    self.tipLabel.font = [UIFont systemFontOfSize:14.0f];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.text = [NSString stringWithFormat:@"打开设置 -> %@ \n\n 允许使用相册和相机功能",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
    [self.view addSubview:self.tipLabel];

}

-(void)openPhotoAlbumWithNavigationController:(UINavigationController *)navC{
    if (iOSVersionGreaterThan(@"8")) { 
        YFPhotoKitAlbumViewController *vc = [[YFPhotoKitAlbumViewController alloc] init];
        vc.assetsResultBlock = self.assetsResultBlock;
        vc.amountBeyondBlock = self.amountBeyondBlock;
        vc.selectedAssets = [[NSMutableArray alloc] initWithArray:self.selectedAssets];
        vc.isIdCard = self.isIdCard;
        vc.maxCount = self.maxCount;
        [navC pushViewController:vc animated:YES];
    }else{
        YFALAssertLibraryViewController *vc = [[YFALAssertLibraryViewController alloc] init];
        vc.assetsResultBlock = self.assetsResultBlock;
        vc.amountBeyondBlock = self.amountBeyondBlock;
        vc.selectedAssets = [[NSMutableArray alloc] initWithArray:self.selectedAssets];
        vc.isIdCard = self.isIdCard;
        vc.maxCount = self.maxCount;
        [navC pushViewController:vc animated:YES];
    }
}

- (YFPhotoTitleSwitcher *)titleSwitcher{
    if (!_titleSwitcher) {
        _titleSwitcher = [[YFPhotoTitleSwitcher alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, 0, 200, 44)];
        [_titleSwitcher.switchButton addTarget:self action:@selector(downButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleSwitcher;
}

- (void)downButtonTouched:(UIButton *)button{
    //子类重载
}

- (YFSelectPhotoAlbumView *)photoAlbumView{
    if (!_photoAlbumView) {
        _photoAlbumView = [[YFSelectPhotoAlbumView alloc]initWithFrame:CGRectZero];
        _photoAlbumView.delegate = self;
    }
    return _photoAlbumView;
}

- (YFPhotoAlbumBottomView *)photoBottomView{
    if (!_photoBottomView) {
        _photoBottomView = [[YFPhotoAlbumBottomView alloc]initWithFrame:CGRectZero];
        
        [_photoBottomView.previewButton addTarget:self action:@selector(previewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoBottomView;
    
}

- (void)previewButtonClick{
    //子类重载
}

//由子类重载 request
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

//由子类重载 request
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YFPhotoAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YFPhotoAlbumCollectionViewCell class]) forIndexPath:indexPath];
    
     return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width - (ColumnCount+1)*3)/ColumnCount, (self.view.frame.size.width - (ColumnCount+1)*3)/ColumnCount);
}

//由子类重载 optional
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - YFSelectPhotoAlbumViewDelegate
//由子类重载 request
- (void)switchAssetsGroup:(YFPhotoAlbumModel *)model{

}

- (void)dealloc{
    NSLog(@"dealloc-dealloc");
}
@end

//
//  YFCustomPhotoAlbumViewController.h
//  Phoenix
//
//  Created by YaFei on 16/4/19.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//
#import "YFPhotoAlbumBaseViewController.h"
#import "YFPhotoAlbumManger.h"
#import "YFPhotoAlbumCollectionViewCell.h"
#import "YFCHTCollectionViewWaterfallLayout.h"
#import "YFSelectPhotoAlbumView.h"
#import "YFPhotoAlbumBottomView.h"
#import "YFPhotoTitleSwitcher.h"

typedef void(^YFAssetsResultBlock)(NSMutableArray *imageAsset);//选择结果
typedef void(^YFAmountBeyondBlock)(void);//超出限制个数

@interface YFCustomPhotoAlbumViewController : YFPhotoAlbumBaseViewController<UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YFPhotoTitleSwitcher *titleSwitcher;
@property (nonatomic, strong) YFSelectPhotoAlbumView *photoAlbumView;
@property (nonatomic, strong) YFPhotoAlbumBottomView *photoBottomView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, copy) YFAssetsResultBlock assetsResultBlock;
@property (nonatomic, copy) YFAmountBeyondBlock amountBeyondBlock;

@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) BOOL isIdCard;

@property (nonatomic, strong) NSMutableArray *selectedAssets;

-(void)openPhotoAlbumWithNavigationController:(UINavigationController *)navC;
@end

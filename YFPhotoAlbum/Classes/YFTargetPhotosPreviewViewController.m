//
//  YFTargetPhotosPreviewViewController.m
//  Phoenix
//
//  Created by YaFei on 16/4/22.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#import "YFTargetPhotosPreviewViewController.h"
#import "YFPhotoAlbumManger.h"
#import "YFPhotoPreviewCell.h"

@interface YFTargetPhotosPreviewViewController ()<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, strong) UICollectionView *contentCollectionView;

@end

@implementation YFTargetPhotosPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = [NSString stringWithFormat:@"1 / %ld 张",self.assets.count];
    
    [self.view addSubview:self.contentCollectionView];
    
    [self.contentCollectionView reloadData];
}

- (UICollectionView *)contentCollectionView{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 20;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0,10);
        layout.itemSize = self.view.bounds.size;
        
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, [[UIScreen mainScreen] bounds].size.width+20, [[UIScreen mainScreen] bounds].size.height-64) collectionViewLayout:layout];
        _contentCollectionView.dataSource = self;
        _contentCollectionView.delegate = self;
        _contentCollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_contentCollectionView registerClass:[YFPhotoPreviewCell class] forCellWithReuseIdentifier:NSStringFromClass([YFPhotoPreviewCell class])]
        ;
        _contentCollectionView.pagingEnabled = YES;
    }
    return _contentCollectionView;
}

#pragma mark - UICollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YFPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YFPhotoPreviewCell class]) forIndexPath:indexPath];
    id asset = self.assets[indexPath.row];
    [cell theOriginalImageFromAsset:asset];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.contentCollectionView) {
        
        CGFloat page = scrollView.contentOffset.x/([[UIScreen mainScreen] bounds].size.width+20);
        NSString *str = [NSString stringWithFormat:@"%.0f", page];
        self.navigationItem.title = [NSString stringWithFormat:@"%ld / %ld",[str integerValue ] + 1,self.assets.count];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

//
//  YFViewController.m
//  YFPhotoAlbum
//
//  Created by YaFei on 03/14/2017.
//  Copyright (c) 2017 YaFei. All rights reserved.
//

#import "YFViewController.h"
#import "YFCustomPhotoAlbumViewController.h"

@interface YFViewController ()
@property (nonatomic, strong) YFCustomPhotoAlbumViewController *photoAlbumViewController;
@property (nonatomic, strong) NSMutableArray *selectedAssets;//用来记住选中的内容，再次选择的时候可以查看之前选中的照片
@property (nonatomic, assign) BOOL singleSelect;//如果两次选择不一样，情况之前的。（仅为了提现demo的功能）

@end


@implementation YFViewController

- (void)loadView {
    [super loadView];
    
    self.selectedAssets = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@",self.selectedAssets);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%@",self.selectedAssets);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"清空" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:98/255 green:204/255 blue:116/255 alpha:1] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(cleanPhotos) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.photoAlbumViewController = [[YFCustomPhotoAlbumViewController alloc] init];
    
    CGFloat width = (self.view.frame.size.width-20)/3;
    for (int i = 0; i < 9; i++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((5+width)*(i%3)+5, (5+width)*(i/3)+5, width, width)];
        imageV.tag = 100+i;
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        [self.contentView addSubview:imageV];
    }
    
}
- (IBAction)singleselectionButtonClick:(id)sender {
    self.photoAlbumViewController.maxCount = 1;
    self.photoAlbumViewController.selectedAssets = self.selectedAssets;
    __weak __typeof(self) weakSelf = self;
    self.photoAlbumViewController.amountBeyondBlock = ^(){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能超过1张" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil , nil];
        [alert show];

    };
    self.photoAlbumViewController.assetsResultBlock = ^(NSMutableArray *assets){
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf configImageVWithDatas:assets];
        
    };
    if (!self.singleSelect) {
        [self cleanPhotos];
    }
    self.singleSelect = YES;
    [self.photoAlbumViewController openPhotoAlbumWithNavigationController:self.navigationController];
    
}
- (IBAction)multiselectButtonClick:(id)sender {
    
    self.photoAlbumViewController.maxCount = 9;
    self.photoAlbumViewController.selectedAssets = self.selectedAssets;
    __weak __typeof(self) weakSelf = self;
    self.photoAlbumViewController.amountBeyondBlock = ^(){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能超过9张" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil , nil];
        [alert show];
    };
    self.photoAlbumViewController.assetsResultBlock = ^(NSMutableArray *assets){
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf configImageVWithDatas:assets];
        
    };
    if (self.singleSelect) {
        [self cleanPhotos];
    }
    self.singleSelect = NO;
    [self.photoAlbumViewController openPhotoAlbumWithNavigationController:self.navigationController];
}

- (void)configImageVWithDatas:(NSArray *)assets{
    
    [self.selectedAssets removeAllObjects];
    [self.selectedAssets addObjectsFromArray:assets];
    for (UIImageView *imageView in self.contentView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            imageView.image = nil;
        }
    }
    
    for (int i = 0; i < assets.count; i++) {
        UIImageView *imageV = (UIImageView *)[self.contentView viewWithTag:100+i];
        id objc = assets[i];
        if ([objc isKindOfClass:[UIImage class]]) {
            imageV.image = objc;
        }else if ([objc isKindOfClass:[PHAsset class]]){
            PHAsset *asset = objc;
            PHImageManager *imageManger = [PHImageManager defaultManager];
            [imageManger requestImageForAsset:asset targetSize:CGSizeMake(80*2, 80*2) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                imageV.image = result;
            }];
        }else if ([objc isKindOfClass:[ALAsset class]]){
            ALAsset *asset = objc;
            imageV.image = [UIImage imageWithCGImage:asset.thumbnail];
            
        }
    }
    
}

- (void)cleanPhotos{
    [self.selectedAssets removeAllObjects];
    for (UIImageView *imageView in self.contentView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            imageView.image = nil;
        }
    }
}

@end

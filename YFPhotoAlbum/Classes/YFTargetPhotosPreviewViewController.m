//
//  YFTargetPhotosPreviewViewController.m
//  Phoenix
//
//  Created by YaFei on 16/4/22.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#import "YFTargetPhotosPreviewViewController.h"
#import "YFPhotoAlbumManger.h"
@interface YFTargetPhotosPreviewViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation YFTargetPhotosPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = [NSString stringWithFormat:@"1/%ld 张",self.assets.count];
    
    for (int i = 0; i < self.assets.count; i++) {
        id asset = self.assets[i];
        if ([asset isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)asset;
            CGSize newSize = [self handelSizeWithImageSize:image.size];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*[[UIScreen mainScreen] bounds].size.width + ([[UIScreen mainScreen] bounds].size.width - newSize.width)/2, ([[UIScreen mainScreen] bounds].size.height-64-newSize.height)/2, newSize.width, newSize.height)];
            imageView.image = image;
            [self.contentScrollView addSubview:imageView];
        }else if ([asset isKindOfClass:[PHAsset class]]){
            YFPhotoAlbumManger *manger = [[YFPhotoAlbumManger alloc] init];
            [manger thePhotoDataInPHAsset:asset PHImageInfo:^(UIImage *image, PHAsset *asset) {
                CGSize newSize = [self handelSizeWithImageSize:image.size];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*[[UIScreen mainScreen] bounds].size.width + ([[UIScreen mainScreen] bounds].size.width - newSize.width)/2, ([[UIScreen mainScreen] bounds].size.height-64-newSize.height)/2, newSize.width, newSize.height)];
                imageView.image = image;
                [self.contentScrollView addSubview:imageView];
            }];
            
        }else if ([asset isKindOfClass:[ALAsset class]]){
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            CGImageRef imageReference = [representation fullScreenImage];
            UIImage *image = [UIImage imageWithCGImage:imageReference];
            CGSize newSize = [self handelSizeWithImageSize:image.size];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*[[UIScreen mainScreen] bounds].size.width + ([[UIScreen mainScreen] bounds].size.width - newSize.width)/2, ([[UIScreen mainScreen] bounds].size.height-64-newSize.height)/2, newSize.width, newSize.height)];
            imageView.image = image;
            [self.contentScrollView addSubview:imageView];
        }
    }
    
    [self.view addSubview:self.contentScrollView];
}

- (UIScrollView *)contentScrollView{
    
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        _contentScrollView.delegate = self;
        _contentScrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width*self.assets.count, [[UIScreen mainScreen] bounds].size.height);
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
    }
    return _contentScrollView;
}

- (CGSize)handelSizeWithImageSize:(CGSize)imageSize{
    
    CGFloat scale = imageSize.height/imageSize.width;
    
    while (imageSize.width > [[UIScreen mainScreen] bounds].size.width || imageSize.height > [[UIScreen mainScreen] bounds].size.height-64) {
        if (imageSize.width>[[UIScreen mainScreen] bounds].size.width) {
            imageSize.width = [[UIScreen mainScreen] bounds].size.width;
            imageSize.height = imageSize.width*scale;
            if (imageSize.height > [[UIScreen mainScreen] bounds].size.height - 64) {
                imageSize.height = [[UIScreen mainScreen] bounds].size.height-64;
            }
        }
    }
    return imageSize;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger num = scrollView.contentOffset.x/[[UIScreen mainScreen] bounds].size.width+1;
    self.title =  [NSString stringWithFormat:@"%ld/%ld 张",num,self.assets.count];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

//
//  YFPhotoPreviewCell.m
//  Pods
//
//  Created by YaFei on 2017/3/17.
//
//

#define MaxImageWidth 500

#import "YFPhotoPreviewCell.h"
#import "YFPhotoAlbumManger.h"

@interface YFPhotoPreviewCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) YFPhotoAlbumManger *manger;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGSize targetSize;
@end


@implementation YFPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.scrollView];
        self.manger = [[YFPhotoAlbumManger alloc] init];
        self.imageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.contentMode = UIViewContentModeScaleAspectFit;
            view;
        });
        [self.scrollView addSubview:self.imageView];
        
    }
    return self;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        
        UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClickAction:)];
        doubleClick.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleClick];
        
    }
    return _scrollView;
}

- (void)theOriginalImageFromAsset:(id)asset{
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = MIN([[UIScreen mainScreen] bounds].size.width, MaxImageWidth);
    
    if ([asset isKindOfClass:[UIImage class]]) {
        UIImage *image = (UIImage *)asset;
        CGSize size = CGSizeMake(width*scale, width*scale*image.size.height/image.size.width);
        self.imageView.image = [self  imageCompressWithSimple:asset scaledToSize:size];
        [self calculateImageViewSize];
    }else if ([asset isKindOfClass:[ALAsset class]]){
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGImageRef imageReference = [representation fullScreenImage];
        UIImage *image = [UIImage imageWithCGImage:imageReference];
        CGSize size = CGSizeMake(width*scale, width*scale*image.size.height/image.size.width);
        self.imageView.image = [self imageCompressWithSimple:image scaledToSize:size];
        [self calculateImageViewSize];
    }else if ([asset isKindOfClass:[PHAsset class]]){
        __weak __typeof(self) weakSelf = self;
        PHAsset *tempAsset = asset;
        CGSize size = CGSizeMake(width*scale, width*scale*tempAsset.pixelHeight/tempAsset.pixelWidth);
        [self.manger thePhotoInPHAsset:asset targetSize:size PHImageInfo:^(UIImage *photo, PHAsset *asset) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.imageView.image = photo;
            [strongSelf calculateImageViewSize];
        }];
    }
}

- (void)calculateImageViewSize
{
    CGRect frame;
    frame.origin = CGPointZero;
    
    UIImage *image = self.imageView.image;
    CGFloat ratio = image.size.height/image.size.width;
    
    CGFloat screenRatio = [[UIScreen mainScreen] bounds].size.height/[[UIScreen mainScreen] bounds].size.width;
    if (image.size.width <= self.frame.size.width && image.size.height <= self.frame.size.height) {
        frame.size.width = image.size.width;
        frame.size.height = image.size.height;
    } else {
        if (ratio > screenRatio) {
            frame.size.height = self.frame.size.height;
            frame.size.width = self.frame.size.height/ratio;
        } else {
            frame.size.width = self.frame.size.width;
            frame.size.height = self.frame.size.width * ratio;
        }
    }
    
    self.scrollView.zoomScale = 1;
    self.scrollView.contentSize = frame.size;
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    self.imageView.frame = frame;
    self.imageView.center = self.contentView.center;
}



- (UIImage*)imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)doubleClickAction:(UITapGestureRecognizer *)click{
    UIScrollView *scrollView = click.view;
    
    CGFloat scale = 1;
    if (scrollView.zoomScale != 2.5) {
        scale = 2.5;
    }
    
    CGPoint locationPoint = [click locationInView:click.view];
    CGRect tempFrame = CGRectZero;
    tempFrame.size.height = self.scrollView.frame.size.height / scale;
    tempFrame.size.width  = self.scrollView.frame.size.width  / scale;
    tempFrame.origin.x    = locationPoint.x - (tempFrame.size.width  /2.0);
    tempFrame.origin.y    = locationPoint.y - (tempFrame.size.height /2.0);
    
    [scrollView zoomToRect:tempFrame animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}



@end

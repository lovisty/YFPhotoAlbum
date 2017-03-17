//
//  YFPhotoAlbumManger+PhotoKit.m
//  NicePro
//
//  Created by Yafei on 2017/2/3.
//  Copyright © 2017年 boohee. All rights reserved.
//

#define MaxImageWidth 500

#import "YFPhotoAlbumManger+PhotoKit.h"

@implementation YFPhotoAlbumManger (PhotoKit)

- (void)allGroupInfo:(PhotoKitAllGrougsBlock)allGrougsInfo{
    
    self.assetCollections = [NSMutableArray array];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"localizedTitle" ascending:YES]];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    PHFetchResult *userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    [self obtainAllAssetCollectionWithPHFetchResult:@[smartAlbums,userAlbums] allGrougsInfo:allGrougsInfo];
}

- (void)obtainAllAssetCollectionWithPHFetchResult:(NSArray *)resultAlbums allGrougsInfo:(PhotoKitAllGrougsBlock)allGrougsInfo{
    
    for (PHFetchResult *result in resultAlbums) {
        for (PHCollection *collection in result) {
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                if (assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeAlbumRegular) {
                    [self.assetCollections addObject:assetCollection];
                }else if (assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary || assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeAlbumMyPhotoStream){
                    [self.assetCollections addObject:assetCollection];
                }
            }
        }
    }
    
    allGrougsInfo(self.assetCollections);
}

- (PHFetchResult *)theFetchResultPhotoInAssetCollection:(PHAssetCollection *)assetCollection{
    PHFetchOptions *options = [PHFetchOptions new];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    return fetchResult;
}

- (void)theCoverPhotoInPHAssetGroup:(PHAssetCollection *)assetCollection PHImageInfo:(PHImageBlock)PHImageInfo{
    
    PHFetchResult *fetchResult = [self theFetchResultPhotoInAssetCollection:assetCollection];
    
    if (fetchResult.count<=0) {
        UIImage *image = [UIImage imageNamed:@"yf_photo_default"];
        PHImageInfo(image,nil);
        return;
    }
    PHImageManager *manger = [PHImageManager  defaultManager];

    PHAsset *asset = fetchResult[0];
    [manger requestImageForAsset:asset targetSize:CGSizeMake(150, 150) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        PHImageInfo(result,asset);
    }];
}

- (void)thePreviewPhotoInPHAsset:(PHAsset *)asset PHImageInfo:(PHImageBlock)PHImageInfo{
    PHImageManager *manger = [PHImageManager defaultManager];
    [manger requestImageForAsset:asset targetSize:CGSizeMake(([[UIScreen mainScreen] bounds].size.width-15)/3, ([[UIScreen mainScreen] bounds].size.width-15)/3) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        PHImageInfo(result,asset);
    }];
}

- (void)thePhotoInPHAsset:(PHAsset *)asset targetSize:(CGSize)targetSize PHImageInfo:(PHImageBlock)PHImageInfo{
    PHImageManager *manger = [PHImageManager defaultManager];
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = NO;
    
    [manger requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        PHImageInfo(result,asset);
    }];
}

- (void)theAppropriateOutputImageInPHAsset:(PHAsset *)asset PHImageInfo:(PHImageBlock)PHImageInfo{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = MIN([[UIScreen mainScreen] bounds].size.width, MaxImageWidth);
    CGSize size = CGSizeMake(width*scale, width*scale*asset.pixelHeight/asset.pixelWidth);
    [self thePhotoInPHAsset:asset targetSize:size PHImageInfo:^(UIImage *photo, PHAsset *asset) {
        PHImageInfo(photo,asset);
    }];
}

- (void)theOriginaPhotoDataInPHAsset:(PHAsset *)asset PHImageInfo:(PHImageBlock)PHImageInfo{
    PHImageManager *manger = [PHImageManager defaultManager];
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = NO;

    [manger requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *image = [UIImage imageWithData:imageData];
        PHImageInfo(image,asset);
    }];
}

- (void)theOriginalPhotoInPHAsset:(PHAsset *)asset PHImageInfo:(PHImageBlock)PHImageInfo{
    PHImageManager *manger = [PHImageManager defaultManager];
    
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = NO;
    
    [manger requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        PHImageInfo(result,asset);
    }];
}

- (void)isICloudPhotoInAsset:(PHAsset *)asset PHICloudInfo:(PHICloudBlock)PHICloudInfo{
    PHImageManager *manger = [PHImageManager defaultManager];
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = NO;
    [manger requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if(imageData){
            PHICloudInfo(@(NO));
        }else{
            PHICloudInfo(@(YES));
        }
    }];
}
@end

//
//  YFPhotoAlbumManger.h
//  Phoenix
//
//  Created by YaFei on 16/4/20.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface YFPhotoAlbumManger : NSObject

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) NSMutableArray *assetCollections;

@end



typedef void(^AssetsLibraryInfoBlock)(NSArray *groupArray);
typedef void(^ALAssetsBlock)(NSArray *photoArray);


@interface YFPhotoAlbumManger (ALAssetsLibrary)

//获取所有分组
- (void)allPhotoGroup:( ALAssetsGroupType )groupType  assetsLibraryInfo:(AssetsLibraryInfoBlock)assetsLibraryInfo ALAssetsoInfo:(ALAssetsBlock)ALAssetsoInfo;

//获取分组内照片
- (void)allPhotoInALAssetsGroup:(ALAssetsGroup *)assetsGroup ALAssetsoInfo:(ALAssetsBlock)ALAssetsoInfo;

@end



typedef void(^PhotoKitAllGrougsBlock)(NSArray *groupArray);
typedef void(^PHImageBlock)(UIImage *photo, PHAsset *asset);

@interface YFPhotoAlbumManger (PhotoKit)

//获取所有分组
- (void)allGroupInfo:(PhotoKitAllGrougsBlock)allGrougsInfo;

/*
    根据 PHAsset 获取照片
 */

//根据 PHAsset 获取照片原尺寸
- (void)theOriginalPhotoInPHAsset:(PHAsset *)asset PHImageInfo:(PHImageBlock)PHImageInfo;
- (void)thePhotoDataInPHAsset:(PHAsset *)asset PHImageInfo:(PHImageBlock)PHImageInfo;

//根据 PHAsset 获取照片预览图
- (void)thePreviewPhotoInPHAsset:(PHAsset *)asset PHImageInfo:(PHImageBlock)PHImageInfo;


//获取封面照片
- (void)theCoverPhotoInPHAssetGroup:(PHAssetCollection *)assetCollection PHImageInfo:(PHImageBlock)PHImageInfo;


//同步获取指定大小的图片
- (void)thePhotoInPHAsset:(PHAsset *)asset targetSize:(CGSize)targetSize PHImageInfo:(PHImageBlock)PHImageInfo;

//获取某个分组的照片集合
- (PHFetchResult *)theFetchResultPhotoInAssetCollection:(PHAssetCollection *)assetCollection;
@end

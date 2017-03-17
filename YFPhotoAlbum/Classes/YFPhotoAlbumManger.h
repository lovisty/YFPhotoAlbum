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

//根据 Asset 判断两张图片是否相同
- (BOOL)isSamePhotoBetweenAsset1:(id)asset1 withAsset2:(id)asset2;

@end



typedef void(^AssetsLibraryInfoBlock)(NSArray *groupArray);
typedef void(^ALAssetsBlock)(NSArray *photoArray);


@interface YFPhotoAlbumManger (ALAssetsLibrary)

//获取所有分组
- (void)allPhotoGroup:(ALAssetsGroupType )groupType  assetsLibraryInfo:(AssetsLibraryInfoBlock)assetsLibraryInfo ALAssetsoInfo:(ALAssetsBlock)ALAssetsoInfo;

//获取分组内照片
- (void)allPhotoInALAssetsGroup:(ALAssetsGroup *)assetsGroup ALAssetsoInfo:(ALAssetsBlock)ALAssetsoInfo;


@end



typedef void(^PhotoKitAllGrougsBlock)(NSArray *groupArray);
typedef void(^PHImageBlock)(UIImage *photo, PHAsset *asset);
typedef void(^PHICloudBlock)(NSNumber *isICloud);

@interface YFPhotoAlbumManger (PhotoKit)

// 获取所有相册分组
- (void)allGroupInfo:(PhotoKitAllGrougsBlock)allGrougsInfo;


// 获取指定分组的 PHFetchResult
- (PHFetchResult *)theFetchResultPhotoInAssetCollection:(PHAssetCollection *)assetCollection;


// 获取 PHAssetCollection 的相册封面图片
- (void)theCoverPhotoInPHAssetGroup:(PHAssetCollection *)assetCollection PHImageInfo:(PHImageBlock)PHImageInfo;


//根据 PHAsset 获取照片列表图
- (void)thePreviewPhotoInPHAsset:(PHAsset *)asset PHImageInfo:(PHImageBlock)PHImageInfo;


/*
 同步获取指定大小的图片
 targetSize：目标尺寸。
 */
- (void)thePhotoInPHAsset:(PHAsset *)asset targetSize:(CGSize)targetSize PHImageInfo:(PHImageBlock)PHImageInfo;


/*
 懒人接口，返回一个合适的尺寸，用来最为最终的输出。
 如果不是必须要输出原图，那么你可以选择该方法，返回的结果既保留了一定的清晰度，图片又不是太大，可以省去压缩图片的步骤。
 如果一定要高清原图，可以选择下面的其他的方法。
 */
- (void)theAppropriateOutputImageInPHAsset:(PHAsset *)asset PHImageInfo:(PHImageBlock)PHImageInfo;


/*
 根据 PHAsset 获取照片高清原图 方法1
 使用的是 requestImageDataForAsset ，先请求 Data ,转化为 UIImage;
 如果一定要获取高清原图，建议用此方法，内存消耗会小很多。
*/
- (void)theOriginaPhotoDataInPHAsset:(PHAsset *)asset PHImageInfo:(PHImageBlock)PHImageInfo;


/*
 根据 PHAsset 获取照片原图 方法2
 使用的是 requestImageForAsset ，直接请求 UIImage。
 */
- (void)theOriginalPhotoInPHAsset:(PHAsset *)asset PHImageInfo:(PHImageBlock)PHImageInfo;


//判断是否为 iCloud 照片
- (void)isICloudPhotoInAsset:(PHAsset *)asset PHICloudInfo:(PHICloudBlock)PHICloudInfo;

@end

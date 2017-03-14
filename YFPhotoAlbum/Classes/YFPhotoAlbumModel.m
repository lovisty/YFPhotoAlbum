//
//  YFPhotoAlbumModel.m
//  Phoenix
//
//  Created by YaFei on 16/4/19.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#import "YFPhotoAlbumModel.h"
#import "YFPhotoAlbumManger.h"

@implementation YFPhotoAlbumModel


+ (NSArray *)transformALAssetsGroupToModelFrom:(NSArray *)groups{
    
    NSMutableArray *groupArray = [NSMutableArray array];
    for (ALAssetsGroup *group in groups) {
        YFPhotoAlbumModel *model = [[YFPhotoAlbumModel alloc]init];
        model.albumName =  [group valueForProperty:ALAssetsGroupPropertyName];
        UIImage* image = [UIImage imageWithCGImage:group.posterImage];
        model.coverImage = image;
        model.photoCount = group.numberOfAssets;
        model.groupType =  [[group valueForProperty:ALAssetsGroupPropertyType] integerValue];
        model.group = group;
        [groupArray addObject:model];
    }
    return [groupArray copy];
}

+ (NSArray *)transformPHAssetCollectionToModelFrom:(NSArray *)groups{
    NSMutableArray *groupArray = [NSMutableArray array];
    
    for (PHAssetCollection *assetCollection in groups) {
        YFPhotoAlbumModel *model = [[YFPhotoAlbumModel alloc]init];
        model.albumName = assetCollection.localizedTitle;
        YFPhotoAlbumManger *manger = [[YFPhotoAlbumManger alloc]init];
        [manger theCoverPhotoInPHAssetGroup:assetCollection PHImageInfo:^(UIImage *photo, PHAsset *asset) {
            model.coverImage = photo;
        }];
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        model.photoCount = assetsFetchResult.count;
        model.assetCollection = assetCollection;
        [groupArray addObject:model];
    }
    
    return groupArray;
}

@end

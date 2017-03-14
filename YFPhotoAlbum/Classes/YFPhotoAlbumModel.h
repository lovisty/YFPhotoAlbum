//
//  YFPhotoAlbumModel.h
//  Phoenix
//
//  Created by YaFei on 16/4/19.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface YFPhotoAlbumModel : NSObject

@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, assign) NSInteger photoCount;

@property (nonatomic, assign) ALAssetsGroupType groupType;
@property (nonatomic, strong) ALAssetsGroup *group;

@property (nonatomic, assign) PHAssetCollectionType collectionType;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

+ (NSArray *)transformALAssetsGroupToModelFrom:(NSArray *)groups;
+ (NSArray *)transformPHAssetCollectionToModelFrom:(NSArray *)groups;
@end

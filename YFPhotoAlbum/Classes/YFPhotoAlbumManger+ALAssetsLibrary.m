//
//  YFPhotoAlbumManger+ALAssetsLibrary.m
//  NicePro
//
//  Created by Yafei on 2017/2/3.
//  Copyright © 2017年 boohee. All rights reserved.
//

#import "YFPhotoAlbumManger+ALAssetsLibrary.h"

@implementation YFPhotoAlbumManger (ALAssetsLibrary)

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,
                  ^{
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

- (void)allPhotoGroup:( ALAssetsGroupType )groupType  assetsLibraryInfo:(AssetsLibraryInfoBlock)assetsLibraryInfo ALAssetsoInfo:(ALAssetsBlock)ALAssetsoInfo{
    
    NSMutableArray *groupArray = [NSMutableArray array];
    
    self.assetsLibrary = [YFPhotoAlbumManger defaultAssetsLibrary];
    __weak typeof(self) weakSelf = self;
    [self.assetsLibrary enumerateGroupsWithTypes:groupType usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        __strong typeof(self) weakSelf = self;
        if (group) {
            if ([group numberOfAssets] > 0) {
                [groupArray addObject:group];
            }
        }else{
            NSArray *resultArray = [[groupArray reverseObjectEnumerator] allObjects];
            assetsLibraryInfo(resultArray);
            //第一次默认遍历第一个相册分组 用于默认展示
            for (ALAssetsGroup *group in resultArray) {
                if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos) {
                    [self allPhotoInALAssetsGroup:group ALAssetsoInfo:^(NSArray *photosInfoArray) {
                        ALAssetsoInfo(photosInfoArray);
                    }];
                    return;
                }
            }
            
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)allPhotoInALAssetsGroup:(ALAssetsGroup *)assetsGroup ALAssetsoInfo:(ALAssetsBlock)ALAssetsoInfo{
    NSMutableArray *assetsArray = [NSMutableArray array];
    [assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result != nil) {
            [assetsArray addObject:result];
        }else{
            ALAssetsoInfo(assetsArray);
        }
    }];
}

@end

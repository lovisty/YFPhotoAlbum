//
//  YFPhotoAlbumManger.m
//  Phoenix
//
//  Created by YaFei on 16/4/20.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#import "YFPhotoAlbumManger.h"


@implementation YFPhotoAlbumManger

- (BOOL)isSamePhotoBetweenAsset1:(id)asset1 withAsset2:(id)asset2{
    if ([asset1 isKindOfClass:[ALAsset class]] && [asset2 isKindOfClass:[ALAsset class]]) {
        ALAsset *tempAsset1 = asset1;
        ALAsset *tempAsset2 = asset2;
        NSString *url1 = [[tempAsset1 valueForProperty:ALAssetPropertyAssetURL] absoluteString];
        NSString *url2 = [[tempAsset2 valueForProperty:ALAssetPropertyAssetURL] absoluteString];
        return [url1 isEqualToString:url2];
    }else if ([asset1 isKindOfClass:[PHAsset class]] && [asset2 isKindOfClass:[PHAsset class]]){
        PHAsset *tempAsset1 = asset1;
        PHAsset *tempAsset2 = asset2;
        NSString *url1 = tempAsset1.localIdentifier;
        NSString *url2 = tempAsset2.localIdentifier;
        return [url1 isEqualToString:url2];
    }
    return NO;
}

@end

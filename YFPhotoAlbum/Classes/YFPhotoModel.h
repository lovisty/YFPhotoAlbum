//
//  YFPhotoModel.h
//  Phoenix
//
//  Created by Amy on 2016/12/20.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface YFPhotoModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, strong) PHAsset *phAsset;
@property (nonatomic, assign) BOOL isSelected;

@end

//
//  YFSelectPhotoAlbumView.h
//  Phoenix
//
//  Created by YaFei on 16/4/19.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class YFPhotoAlbumModel;

@protocol YFSelectPhotoAlbumViewDelegate <NSObject>

- (void)switchAssetsGroup:(YFPhotoAlbumModel *)model;

@end

@interface YFSelectPhotoAlbumView : UIView

@property (nonatomic, assign) id<YFSelectPhotoAlbumViewDelegate> delegate;
@property (nonatomic, strong) NSArray *listArray;

- (void)showWithView:(UIView *)view;
- (void)dismissWithView:(UIView *)view;
- (void)reload;
@end

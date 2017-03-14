//
//  YFPhotoAlbumBottomView.h
//  Phoenix
//
//  Created by YaFei on 16/4/22.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFPhotoAlbumBottomView : UIView

@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)configDataWithCount:(NSInteger )count;
@end

//
//  YFSelectPhotoAlbumItemCell.h
//  Phoenix
//
//  Created by YaFei on 16/4/19.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFPhotoAlbumModel.h"

@interface YFSelectPhotoAlbumItemCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *smallLabel;

- (void)bindCellDataFromData:(YFPhotoAlbumModel *)data;


@end

//
//  YFPhotoAlbumCollectionViewCell.m
//  Phoenix
//
//  Created by YaFei on 16/4/21.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#import "YFPhotoAlbumCollectionViewCell.h"

@implementation YFPhotoAlbumCollectionViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.photoImageView.frame = self.contentView.frame;
    self.selectedImageView.frame = CGRectMake(self.frame.size.width-45, 5, 40, 40);
}
//CTAssetsPickerChecked
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _photoImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.clipsToBounds = YES;
            view;
        });
        
        [self.contentView addSubview:_photoImageView];
        
        _selectedImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.image = [UIImage imageNamed:@"yf_pick_image_unselected"];
            view;
        });
        [self.contentView addSubview:_selectedImageView];
    }
    return self;
}


@end

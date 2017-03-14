//
//  YFSelectPhotoAlbumItemCell.m
//  Phoenix
//
//  Created by YaFei on 16/4/19.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#import "YFSelectPhotoAlbumItemCell.h"

@implementation YFSelectPhotoAlbumItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _photoImageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView;
        });
        [self.contentView addSubview:_photoImageView];
        
        _titleLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.textColor = [UIColor colorWithRed:61/255 green:51/255 blue:51/255 alpha:1.0];
            label.font = [UIFont systemFontOfSize:17];
            label;
        });
        [self.contentView addSubview:_titleLabel];
        
        _smallLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.textColor = [UIColor colorWithRed:61/255 green:51/255 blue:51/255 alpha:1.0];
            label.font = [UIFont systemFontOfSize:14];
            label;
        });
        [self.contentView addSubview:_smallLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _photoImageView.frame = CGRectMake(10, 10, 50, 50);
    CGSize size = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    
    _titleLabel.frame = CGRectMake(_photoImageView.frame.origin.x+_photoImageView.frame.size.width + 10, (self.frame.size.height - size.height)/2 , size.width, size.height);
    _smallLabel.frame = CGRectMake(_titleLabel.frame.origin.x+_titleLabel.frame.size.width + 5, _titleLabel.frame.origin.y+_titleLabel.frame.size.height - 15, 50, 15);

}

- (void)bindCellDataFromData:(YFPhotoAlbumModel *)data{
    self.photoImageView.image = data.coverImage;
    self.titleLabel.text = data.albumName;
    self.smallLabel.text = [NSString stringWithFormat:@"%d",data.photoCount];
}
@end

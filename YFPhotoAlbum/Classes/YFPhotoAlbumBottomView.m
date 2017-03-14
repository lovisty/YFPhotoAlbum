//
//  YFPhotoAlbumBottomView.m
//  Phoenix
//
//  Created by YaFei on 16/4/22.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#import "YFPhotoAlbumBottomView.h"

@implementation YFPhotoAlbumBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.previewButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.enabled = NO;
            button.clipsToBounds = YES;
            button.layer.cornerRadius = 2;
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor colorWithRed:206/255 green:206/255 blue:206/255 alpha:1].CGColor;
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [button setTitle:@"预览" forState:UIControlStateNormal];
            button;
        });
        [self addSubview:self.previewButton];
        
        _titleLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.textColor = [UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1];
            label.text = @"0";
            label;
        });
        [self addSubview:self.titleLabel];
        
//        [self.previewButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(12, 20, 12, ScreenWidth - 60)];
//        [self.titleLabel autoSetDimensionsToSize:CGSizeMake(50, 20)];
//        [self.titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.previewButton];
//        [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.previewButton withOffset:10];
    }

    return self;
}

- (void)configDataWithCount:(NSInteger)count{

    self.previewButton.enabled = (count>0);
    self.titleLabel.text = [NSString stringWithFormat:@"%ld",count];
    self.previewButton.layer.borderColor = count>0?[UIColor colorWithRed:98/255 green:204/255 blue:116/255 alpha:1].CGColor:[UIColor darkGrayColor].CGColor;
    [self.previewButton setTitleColor:(count>0)?[UIColor colorWithRed:98/255 green:204/255 blue:116/255 alpha:1]:[UIColor darkGrayColor] forState:UIControlStateNormal] ;

}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.previewButton.frame = CGRectMake(20, 12, 40, self.frame.size.height-24);
    self.titleLabel.frame = CGRectMake(70, self.previewButton.center.y-10, 50, 20);
    

}

@end

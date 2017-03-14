//
//  YFPhotoTitleSwitcher.m
//  Phoenix
//
//  Created by Chen Yihu on 6/15/15.
//  Copyright (c) 2015 BOOHEE. All rights reserved.
//

#import "YFPhotoTitleSwitcher.h"

@implementation YFPhotoTitleSwitcher

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.switchButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
      
        self.switchButton = ({
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitleColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"yf_bullet_down"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"yf_bullet_up"] forState:UIControlStateSelected];

            button;
        });
        [self addSubview:self.switchButton];
    }
    return self;
}

- (void)horizontalCenterTitleAndImageRight:(CGFloat)spacing
{
    CGSize imageSize = CGSizeMake(15, 15);
    CGSize titleSize = [self.switchButton.currentTitle sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
    self.switchButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, 0.0, 0.0);
    
    self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + imageSize.width + spacing, 0.0, - titleSize.width);
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [self.switchButton setTitle:_title forState:UIControlStateNormal];
    [self horizontalCenterTitleAndImageRight:5];
}
@end

//
//  YFSelectPhotoAlbumView.m
//  Phoenix
//
//  Created by YaFei on 16/4/19.
//  Copyright © 2016年 BOOHEE. All rights reserved.
//

#import "YFSelectPhotoAlbumView.h"
#import "YFSelectPhotoAlbumItemCell.h"
#import "YFPhotoAlbumModel.h"

@interface YFSelectPhotoAlbumView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *table_view;
@end

@implementation YFSelectPhotoAlbumView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.table_view = ({
            UITableView *view = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
            view.delegate = self;
            view.dataSource = self;
            view;
        });
        self.table_view.tableFooterView = [UIView new];
        [self addSubview:self.table_view];
    }

    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YFSelectPhotoAlbumItemCell *cell = (YFSelectPhotoAlbumItemCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YFSelectPhotoAlbumItemCell class])];
    
    if (!cell) {
        cell = [[YFSelectPhotoAlbumItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([YFSelectPhotoAlbumItemCell class])];
    }
    YFPhotoAlbumModel *model = self.listArray[indexPath.row];
    
    [cell bindCellDataFromData:model];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(switchAssetsGroup:)]) {
        YFPhotoAlbumModel *model = self.listArray[indexPath.row];
        [self.delegate switchAssetsGroup:model];
    }
}

- (void)reload{
    
    self.frame = CGRectMake(0, 0.0 - self.listArray.count*70.0, [[UIScreen mainScreen] bounds].size.width, self.listArray.count*70>[[UIScreen mainScreen] bounds].size.height-64-50?[[UIScreen mainScreen] bounds].size.height-64-50:self.listArray.count*70);
    self.table_view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.table_view reloadData];
}

- (void)showWithView:(UIView *)view{
    __weak __typeof(self) weakSelf = self;
    view.hidden = NO;
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        __strong __typeof(self) strongSelf = weakSelf;
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        strongSelf.frame = CGRectMake(0, 0, strongSelf.frame.size.width, strongSelf.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissWithView:(UIView *)view{
     __weak __typeof(self) weakSelf = self;
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.frame = CGRectMake(0,  - strongSelf.frame.size.height, strongSelf.frame.size.width, strongSelf.frame.size.height);
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        view.hidden = YES;
    }];

}

@end

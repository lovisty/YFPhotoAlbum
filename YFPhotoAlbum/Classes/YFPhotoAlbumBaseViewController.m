//
//  YFPhotoAlbumBaseViewController.m
//  Pods
//
//  Created by Yafei on 2017/2/15.
//
//

#import "YFPhotoAlbumBaseViewController.h"

@interface YFPhotoAlbumBaseViewController ()

@end

@implementation YFPhotoAlbumBaseViewController

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.edgesForExtendedLayout   = UIRectEdgeNone;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.view.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end

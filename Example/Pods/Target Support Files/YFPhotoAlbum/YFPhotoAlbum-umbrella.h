#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "YFALAssertLibraryViewController.h"
#import "YFCHTCollectionViewWaterfallLayout.h"
#import "YFCustomPhotoAlbumViewController.h"
#import "YFPhotoAlbumBaseViewController.h"
#import "YFPhotoAlbumBottomView.h"
#import "YFPhotoAlbumCollectionViewCell.h"
#import "YFPhotoAlbumManger+ALAssetsLibrary.h"
#import "YFPhotoAlbumManger+PhotoKit.h"
#import "YFPhotoAlbumManger.h"
#import "YFPhotoAlbumModel.h"
#import "YFPhotoKitAlbumViewController.h"
#import "YFPhotoModel.h"
#import "YFPhotoTitleSwitcher.h"
#import "YFSelectPhotoAlbumItemCell.h"
#import "YFSelectPhotoAlbumView.h"
#import "YFTargetPhotosPreviewViewController.h"

FOUNDATION_EXPORT double YFPhotoAlbumVersionNumber;
FOUNDATION_EXPORT const unsigned char YFPhotoAlbumVersionString[];


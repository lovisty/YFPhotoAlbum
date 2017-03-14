# YFPhotoAlbum

[![CI Status](http://img.shields.io/travis/YaFei/YFPhotoAlbum.svg?style=flat)](https://travis-ci.org/YaFei/YFPhotoAlbum)
[![Version](https://img.shields.io/cocoapods/v/YFPhotoAlbum.svg?style=flat)](http://cocoapods.org/pods/YFPhotoAlbum)
[![License](https://img.shields.io/cocoapods/l/YFPhotoAlbum.svg?style=flat)](http://cocoapods.org/pods/YFPhotoAlbum)
[![Platform](https://img.shields.io/cocoapods/p/YFPhotoAlbum.svg?style=flat)](http://cocoapods.org/pods/YFPhotoAlbum)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS7+


## ScreenShot

![下拉式相册分组](https://github.com/lovisty/YFPhotoAlbum/blob/master/ScreenShot/img_001.png?raw=true)       ![相册展示](https://github.com/lovisty/YFPhotoAlbum/blob/master/ScreenShot/img_002.png?raw=true) 

![照片大图预览](https://github.com/lovisty/YFPhotoAlbum/blob/master/ScreenShot/img_003.png?raw=true)

## Installation
- 通过CocoaPods安装   

YFPhotoAlbum 支持通过 [CocoaPods](http://cocoapods.org)进行安装。
在Podfile文件中加上
```ruby
pod "YFPhotoAlbum"
```
- 直接加项目中使用
```ruby
git clone https://github.com/lovisty/YFPhotoAlbum   
```
找到包含的文件Classes和Assets的YFPhotoAlbum文件，直接把YFPhotoAlbum拖到项目中。

**导入头文件：**
```ruby
#import "YFCustomPhotoAlbumViewController.h"  
```

## Usage

初始化以及相关回调

```ruby
self.photoAlbumViewController = [[BHCustomPhotoAlbumViewController alloc] init];
self.photoAlbumViewController.maxCount = 9;// maxCount > 0, 默认是 1.
self.photoAlbumViewController.selectedAssets = self.selectedAssets;//再次进入相册选择的时候，保留已选择的为选中状态。

//超过最大值的回调
self.photoAlbumViewController.amountBeyondBlock = ^(){ 
    //可以用来提醒用户超过最大值
};
 
//选择结果  
self.photoAlbumViewController.assetsResultBlock = ^(NSMutableArray *assets){
    //优化内存，此处的assets为对象，而非图片本身。
};

```

获取图片

```ruby
    for (id objc in assets) {
        if ([objc isKindOfClass:[UIImage class]]) { //拍照的结果
            //objc 即为图片;
        }else if ([objc isKindOfClass:[PHAsset class]]){ //PhotoKit
            PHAsset *asset = objc;
            PHImageManager *imageManger = [PHImageManager defaultManager];
            [imageManger requestImageForAsset:asset targetSize:CGSizeMake(80*2, 80*2) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                //result 即为图片;
            }];
        }else if ([objc isKindOfClass:[ALAsset class]]){ //ALAssetLibrary
            ALAsset *asset = objc;
            UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
            //image 即为图片;
            
        }
    }

```

## Author

YaFei, nihao1992@163.com

个人博客:http://blog.csdn.net/u013749108


## License

YFPhotoAlbum is available under the MIT license. See the LICENSE file for more info.

//
//  BHPhotoAlbumMacroDefine.h
//  BHPhotoAlbum
//
//  Created by YaFei on 2017/11/16.
//

#ifndef BHPhotoAlbumMacroDefine_h
#define BHPhotoAlbumMacroDefine_h

#define Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define StatusBarHeight   (Is_iPhoneX?44:20)
#define NavHeight     (Is_iPhoneX?88:64)
#define TabHeight     (Is_iPhoneX?83:49)
#define BlankHeight   (Is_iPhoneX?34:0)


#endif /* BHPhotoAlbumMacroDefine_h */

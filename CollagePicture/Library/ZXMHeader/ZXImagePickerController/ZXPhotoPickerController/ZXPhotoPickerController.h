//
//  ZXPhotoPickerController.h
//  FunLive
//
//  Created by simon on 2019/5/8.
//  Copyright © 2019 facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXAlbumModel;
@interface ZXPhotoPickerController : UIViewController

@property (nonatomic, assign) NSInteger columnNumber;

@property (nonatomic, strong) ZXAlbumModel *model;

@end

NS_ASSUME_NONNULL_END

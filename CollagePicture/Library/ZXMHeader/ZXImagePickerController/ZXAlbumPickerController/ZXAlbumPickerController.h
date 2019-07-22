//
//  ZXAlbumPickerController.h
//  FunLive
//
//  Created by simon on 2019/4/23.
//  Copyright © 2019 facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPHPhotoManager.h"

NS_ASSUME_NONNULL_BEGIN


@protocol ZXImagePickerControllerDelegate;

@interface ZXAlbumPickerController : UIViewController

@property (nonatomic, assign) NSInteger columnNumber;

@property (nonatomic, weak) id<ZXImagePickerControllerDelegate> pickerDelegate;

@end

NS_ASSUME_NONNULL_END

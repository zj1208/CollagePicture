//
//  ZXKxMenuOverlay.h
//  CollagePicture
//
//  Created by simon on 2019/2/27.
//  Copyright © 2019 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXKxMenuOverlayDelegate <NSObject>

- (void)zxKxMenuOverlaydissmissAction;

@end

@interface ZXKxMenuOverlay : UIView

@property(nonatomic,weak)id<ZXKxMenuOverlayDelegate>delegate;

@end

NS_ASSUME_NONNULL_END

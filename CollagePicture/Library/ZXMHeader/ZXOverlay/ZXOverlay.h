//
//  ZXOverlay.h
//  Baby
//
//  Created by simon on 16/1/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZXOverlayDelegate <NSObject>

- (void)zxOverlaydissmissAction;

@end



@interface ZXOverlay : UIView

@property(nonatomic,weak)id<ZXOverlayDelegate>delegate;

@end

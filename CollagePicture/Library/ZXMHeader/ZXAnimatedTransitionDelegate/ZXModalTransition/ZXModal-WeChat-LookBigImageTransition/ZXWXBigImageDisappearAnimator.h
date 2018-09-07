//
//  ZXWXBigImageDisappearAnimator.h
//  YiShangbao
//
//  Created by simon on 2018/8/15.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXWXBigImageDisappearAnimator : NSObject<UIViewControllerAnimatedTransitioning>

//转场图片
@property (nonatomic, strong) UIImage *transitionImage;
//转场前图片的frame，在手势交互返回的时候，这个frame会跟随交互imageView移动；
@property (nonatomic, assign) CGRect transitionBeforeImgFrame;
//转场后图片的frame
@property (nonatomic, assign) CGRect transitionAfterImgFrame;


@end

NS_ASSUME_NONNULL_END

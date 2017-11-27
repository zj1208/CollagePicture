//
//  ZXProgressView.h
//  YiShangbao
//
//  Created by simon on 17/1/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//优化系统UIProgressView的设置图片bug，重新写2个属性；
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXProgressView : UIProgressView

//已有进度的图片－可以放渐变图，会自动拉伸变形； 如果是真正的有轮廓的图片，则需要用UIGraphic方法重绘
@property (nonatomic, strong) UIImage *zxTrackImage;

//没有进度的底图
@property (nonatomic, strong) UIImage *zxProgressImage;

@property (nonatomic, assign) CGFloat progressHeight;


//设置是否需要圆角
@property (nonatomic, assign) BOOL cornerRaidius;

@end

NS_ASSUME_NONNULL_END

//////////////////////----------例如－－－－－－－////////////////////
/*
self.numPersonalLab.text = [NSString stringWithFormat:@"%@",model.qouterAmout];
self.progressLab.text = [NSString stringWithFormat:@"%d%%",(int)(model.ratio*100)];
CGFloat progress = [model.qouterAmout floatValue]<10?0.3:model.ratio;
[self.progressView setProgress:progress animated:YES];

*/

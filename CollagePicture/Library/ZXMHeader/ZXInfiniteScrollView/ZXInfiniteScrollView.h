//
//  ZXInfiniteScrollView.h
//  YiShangbao
//
//  Created by simon on 2017/8/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSTimer+Addition.h"
#import "ZXADBannerModel.h"

@class ZXInfiniteScrollView;
@protocol ZXInfiniteScrollViewDelegate <NSObject>

@optional

-(void)infiniteScrollView:(ZXInfiniteScrollView *)infiniteView didSelectRowAtIndex:(NSInteger)index;

- (void)infiniteScrollView:(ZXInfiniteScrollView *)infiniteView didSelectModel:(ZXADBannerModel *)data;

@end



@interface ZXInfiniteScrollView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) NSTimer *timer;


@property(nonatomic, weak) id<ZXInfiniteScrollViewDelegate>delegate;


//  数据源接口

/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

@property (nonatomic, strong) NSMutableArray *itemModelArray;


//  滚动控制接口

//是否自动滚动,默认Yes
@property (nonatomic, assign) BOOL autoScroll;

//自动滚动时间间隔
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;

//是否无限循环,默认Yes
@property (nonatomic,assign) BOOL infiniteLoop;


//  自定义样式接口

/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;

@end

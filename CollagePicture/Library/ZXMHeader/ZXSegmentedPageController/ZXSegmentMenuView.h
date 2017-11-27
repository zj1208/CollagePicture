//
//  ZXSegmentMenuView.h
//  Demo
//
//  Created by simon on 2017/9/7.
//  Copyright © 2017年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXLabelsTagsView.h"

@protocol ZXSegmentMenuViewDelegate;

@interface ZXSegmentMenuView : UIView

@property (nonatomic, weak) id<ZXSegmentMenuViewDelegate>delegate;

// segmented的高度,默认40
@property (nonatomic, assign) CGFloat segmentHeight;

@property (nonatomic, copy) NSArray *itemTitles;

/**
 选中的索引
 */
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)showInView:(UIView *)view;
@end




@protocol ZXSegmentMenuViewDelegate <NSObject>

- (void)zx_segmentMenuView:(ZXSegmentMenuView *)menuView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;


@optional
/**
 将要展示数据的时候，自定义设置cell的显示；不影响布局的外观设置
 
 @param cell LabelCell
 @param indexPath collectionView中的对应indexPath
 */
- (void)zx_segmentMenuView:(ZXSegmentMenuView *)menuView labelTagsView:(ZXLabelsTagsView *)tagsView willDisplayCell:(LabelCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

@end

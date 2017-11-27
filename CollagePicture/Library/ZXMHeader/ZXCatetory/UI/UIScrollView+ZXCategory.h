//
//  UIScrollView+ZXCategory.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ZXCategory)


/**
 *  获取tableView/UICollectionView中的cell的view的indexPath
 *
 *  @param view  要转化坐标的view：button／textField；
 *
 *  @return indexPath
 */

- (nullable NSIndexPath *)zh_getIndexPathFromTableViewOrCollectionViewWithConvertView:(nullable UIView *)view;

@end


NS_ASSUME_NONNULL_END

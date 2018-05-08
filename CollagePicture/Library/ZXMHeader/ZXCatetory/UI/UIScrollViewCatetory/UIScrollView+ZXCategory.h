//
//  UIScrollView+ZXCategory.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：UIScrollView的类目；
//  注意：tableView/collectionView的SectionHeaderView目前只能用tag标识做注释，
//  无法用坐标换算方法；

//  2018.4.24 修改注释，移动文件目录

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ZXCategory)


/**
 *  获取tableView/UICollectionView中的cell的view的indexPath
    注意：只能用于tableViewCell，UICollectionViewCell点击转换；
    SectionHeaderView目前只能用tag标识做；
 *
 *  @param subView  要转化坐标的view：button／textField；
 *
 *  @return indexPath
 */

- (nullable NSIndexPath *)zh_getIndexPathFromTableViewOrCollectionViewWithConvertView:(nullable UIView *)subView;

@end


NS_ASSUME_NONNULL_END

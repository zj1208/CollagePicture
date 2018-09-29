//
//  UIScrollView+ZXCategory.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIScrollView+ZXCategory.h"

@implementation UIScrollView (ZXCategory)

// 只能用于tableViewCell，UICollectionViewCell点击转换；
- (nullable NSIndexPath *)zh_getIndexPathFromTableViewOrCollectionViewWithConvertView:(nullable UIView *)subView
{
    CGPoint point = subView.center;
    point = [self convertPoint:point fromView:subView.superview];
    if ([self isKindOfClass:[UITableView class]])
    {
        UITableView *tableView = (UITableView *)self;
        NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:point];
        return indexPath;
    }
    if ([self isKindOfClass:[UICollectionView class]])
    {
        UICollectionView *tableView = (UICollectionView *)self;
        NSIndexPath* indexPath = [tableView indexPathForItemAtPoint:point];
        return indexPath;
    }
    return nil;
}



@end

//
//  UIScrollView+ZXCategory.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIScrollView+ZXCategory.h"

@implementation UIScrollView (ZXCategory)


- (nullable NSIndexPath *)zh_getIndexPathFromTableViewOrCollectionViewWithConvertView:(nullable UIView *)view
{
    CGPoint point = view.center;
    point = [self convertPoint:point fromView:view.superview];
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

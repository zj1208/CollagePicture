//
//  ZXHorizontalPageCollectionView.m
//  ZXPageDemo
//
//  Created by simon on 2018/1/30.
//  Copyright © 2018年 simon. All rights reserved.
//

#import "ZXHorizontalPageCollectionView.h"

@implementation ZXHorizontalPageCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static NSString * const reuseTagsCell = @"Cell";
static CGFloat const ZXInteritemSpacing = 4.f;//item之间固定间隔
static CGFloat const ZXLineSpacing = 12.f; //固定行间距

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}


- (void)commonInit
{
    self.backgroundColor = [UIColor whiteColor];
    
//   item之间的间距=sectoinInset间距；这样一页的时候2边边距一样；
    self.sectionInset = UIEdgeInsetsMake(0, ZXInteritemSpacing/2, 10, ZXInteritemSpacing/2);
    self.interitemSpacing = ZXInteritemSpacing;
    self.lineSpacing = ZXLineSpacing;
//    没有实际意义，只是用于先前计算出总高度；
    self.itemSize = CGSizeMake(60, 60);
    
    [self addSubview:self.collectionView];
    [self addCustomConstraintWithItem:self.collectionView];
    
    [self addSubview:self.pageControl];
    [self addPageControlConstraintWithItem:self.pageControl];
    
//    self.backgroundColor = [UIColor orangeColor];
//    self.collectionView.backgroundColor = [UIColor blueColor];
//    self.pageControl.backgroundColor = [UIColor orangeColor];
    
}

- (CGFloat)getItemAverageWidthInTotalWidth:(CGFloat)totalWidth columnsCount:(NSUInteger)count sectionInset:(UIEdgeInsets)inset minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{

    CGFloat itemWidth =  (totalWidth - (count-1)*minimumInteritemSpacing-inset.left-inset.right)/count;
    return floorf(itemWidth);
}

#pragma mark - layoutSubviews

// 如果当前view的父视图在layoutSubViews用.frame设置当前view，那么这里的frame设置才有同步有效；
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

// 修改pageControl的width约束
- (void)updateConstraints
{
    [super updateConstraints];

    if (self.dataMArray.count>0)
    {
        CGSize pageSize = [self.pageControl sizeForNumberOfPages:self.pageControl.numberOfPages];//minSize of pageCount
        pageSize = CGSizeMake(pageSize.width+40, 18);
        
        [self.pageControl.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.firstAttribute ==NSLayoutAttributeWidth)
            {
                obj.constant = pageSize.width;
            }
        }];
    }
}

#pragma mark - 添加collectionView，pageControl的约束

- (void)addCustomConstraintWithItem:(UIView *)item
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    constraint1.active = YES;
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    constraint2.active = YES;
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    constraint3.active = YES;
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    constraint4.active = YES;
}

- (void)addPageControlConstraintWithItem:(UIView *)item
{
    CGSize pageSize = [self.pageControl sizeForNumberOfPages:self.pageControl.numberOfPages];//minSize of pageCount
    pageSize = CGSizeMake(pageSize.width+20, 18);
    
    item.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:pageSize.height];
    constraint1.active = YES;
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    constraint2.active = YES;
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:pageSize.width];
    constraint3.active = YES;
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    constraint4.active = YES;
}


#pragma mark - UICollectionView

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        ZXHorizontalPageFlowLayout *flowLayout = [[ZXHorizontalPageFlowLayout alloc] init];
        flowLayout.edgeInsets = self.sectionInset;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.rowSpacing = self.lineSpacing;
        flowLayout.columnSpacing = self.interitemSpacing;
        self.collectionFlowLayout = flowLayout;
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collection.backgroundColor = [UIColor clearColor];
        collection.delegate = self;
        collection.dataSource = self;
        collection.pagingEnabled = YES;
        [collection registerNib:[UINib nibWithNibName:NSStringFromClass([ZXBadgeCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:reuseTagsCell];
        collection.showsHorizontalScrollIndicator = NO;
        
        _collectionView = collection;
    }
    return _collectionView;
}

#pragma mark - pageControl

- (UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.hidesForSinglePage = YES;
        pageControl.pageIndicatorTintColor = UIColorFromRGB(194.f, 194.f, 194.f);

        pageControl.defersCurrentPageDisplay = YES;
        pageControl.currentPageIndicatorTintColor =UIColorFromRGB(229.f, 54.f, 40.f);
        pageControl.userInteractionEnabled = NO;
        _pageControl = pageControl;
    }
    return _pageControl;
}

#pragma mark - set

- (NSMutableArray *)dataMArray {
    if (_dataMArray == nil) {
        _dataMArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataMArray;
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    _sectionInset = sectionInset;
    self.collectionFlowLayout.edgeInsets = sectionInset;
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    _lineSpacing = lineSpacing;
    self.collectionFlowLayout.rowSpacing = lineSpacing;
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing
{
    _interitemSpacing = interitemSpacing;
    self.collectionFlowLayout.columnSpacing = interitemSpacing;
}

- (void)setColumnsCount:(NSInteger)columnsCount
{
    _columnsCount = columnsCount;
    self.collectionFlowLayout.columnsCount = columnsCount;
}

- (void)setMaxRowCount:(NSInteger)maxRowCount
{
    _maxRowCount = maxRowCount;
    self.collectionFlowLayout.rowCount = maxRowCount;
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataMArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXBadgeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseTagsCell forIndexPath:indexPath];

    if (indexPath.item<self.dataMArray.count)
    {
        id model = [self.dataMArray objectAtIndex:indexPath.item];
        [cell setData:model placeholderImage:self.placeholderImage];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXBadgeCollectionCell *badgeCell = (ZXBadgeCollectionCell *)cell;
    if ([self.delegate respondsToSelector:@selector(zx_horizontalPageCollectionView:willDisplayCell:forItemAtIndexPath:)])
    {
        [self.delegate zx_horizontalPageCollectionView:self willDisplayCell:badgeCell forItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(zx_horizontalPageCollectionView:collectionView:didSelectItemAtIndexPath:)])
    {
        [self.delegate zx_horizontalPageCollectionView:self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    计算currentPage只能在这里计算，因为有drag一定距离，又会反弹回去的情况，要动态及改变,不然会影响self.pageControl.currentPage；
    [self setCurrentPage];
}

// 可以优化 往左边拖动的时候，也自动先改变currentPage；
- (void)setCurrentPage
{
    CGFloat pagewidth = CGRectGetWidth(self.collectionView.frame);
    CGFloat mx =pagewidth/4; //多加这个是为了效果更好罢了，pageControl会有动态赋值效果；
    NSInteger currentPage = floor((self.collectionView.contentOffset.x - mx) / pagewidth);
    // 计算多加了mx问题，所以第一页的时候currentPage会变－1
    currentPage = currentPage +1;
    self.pageControl.currentPage =currentPage;
}


#pragma mark - 计算方法

- (NSInteger)getRowsWithDataCount:(NSInteger)count
{
    if (count ==0)
    {
        return 0;
    }
    NSInteger rows = 0; // 行数
    //计算有几行的简单方法
    if (count%self.columnsCount>0)
    {
        NSInteger totalItems = count+(self.columnsCount-(count%self.columnsCount));
        rows = totalItems /self.columnsCount;
    }
    else
    {
        rows = count/self.columnsCount;
    }
    rows = rows>self.maxRowCount?self.maxRowCount:rows;
    return  rows;
}


- (NSInteger)getPageNumsWithDataCount:(NSInteger)count
{
    if (count ==0)
    {
        return 0;
    }
    NSInteger rows = [self getRowsWithDataCount:count];
    // 理论上每页展示的item数目
    NSInteger itemCount = rows * self.columnsCount;
    // 余数（用于确定最后一页展示的item个数）
    NSInteger remainder = count % itemCount;
    // 除数（用于判断页数）
    NSInteger pageNumber = count / itemCount;
    // 总个数小于self.rowCount * self.itemCountPerRow
    if (count <= itemCount)
    {
        pageNumber = 1;
    }
    else
    {
        if (remainder == 0) {
            pageNumber = pageNumber;
        }else {
            // 余数不为0,除数加1
            pageNumber = pageNumber + 1;
        }
    }
    return pageNumber;
}





#pragma mark - 滚动到第几页

- (void)scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if ([self.collectionView numberOfItemsInSection:0]>0)
    {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
        NSInteger pageNumber = [self getPageNumsWithDataCount:itemCount];
        if (index< pageNumber)
        {
            //  获取当前显示的item
            NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
            NSInteger rows = [self getRowsWithDataCount:itemCount];
            //  要滚动到的某个item的位置；
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0+self.columnsCount*rows*index inSection:0];
//            如果不在当前page页则滚动；
            if (![visibleIndexPaths containsObject:indexPath])
            {
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
            }
        }
   
    }
}

#pragma mark - 获取高度

- (CGFloat)getCellHeightWithContentData:(NSArray *)data
{
    // collectionViewCell的高度，不要返回0，不然会出错；
    if ([data count]==0)
    {
        return 0;
    }
    CGFloat pageViewHeight = 0;
    NSInteger rows = [self getRowsWithDataCount:data.count];
    //计算高度
    pageViewHeight = rows * self.itemSize.height + (rows - 1) * self.lineSpacing +self.sectionInset.top+self.sectionInset.bottom;
//    NSLog(@"个数= %@,高度 = %@",@(data.count), @(pageViewHeight));
    
    return ceilf(pageViewHeight);
}


#pragma mark - 设置数据

- (void)setData:(NSArray *)data
{
    if (![self.dataMArray isEqualToArray:data])
    {
        NSInteger pageNumber = [self getPageNumsWithDataCount:data.count];
        self.pageControl.numberOfPages = pageNumber;
        [self setNeedsUpdateConstraints];
        
        [self.dataMArray removeAllObjects];
        [self.dataMArray addObjectsFromArray:data];
        [self.collectionView reloadData];
    }
}

@end

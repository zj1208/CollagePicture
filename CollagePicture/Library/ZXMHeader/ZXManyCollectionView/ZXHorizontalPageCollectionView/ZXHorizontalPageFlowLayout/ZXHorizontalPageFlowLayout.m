//
//  ZXHorizontalPageFlowLayout.m
//  YiShangbao
//
//  Created by simon on 2018/1/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXHorizontalPageFlowLayout.h"

@implementation ZXHorizontalPageFlowLayout

static NSInteger const ZXColumnsCount =4;
static NSInteger const ZXMaxRowsCount =2;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}


- (void)initData
{
    //设置默认值
    self.columnsCount= ZXColumnsCount;
    self.rowSpacing = 0;
    self.columnSpacing = 0;
    self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.rowCount = ZXMaxRowsCount;

}

- (NSMutableArray *)attributesMArray
{
    if (!_attributesMArray) {
        
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        _attributesMArray = mArray;
    }
    return _attributesMArray;
}

/**
 *  当初始化完collectionView，开始要布局的时候调用
 *
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.attributesMArray removeAllObjects];
    
    if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)])
    {
        //获取个数
        NSInteger count = [self.collectionView numberOfItemsInSection:0];
        
        //这个遍历会导致返回indexPath对应item的属性的方法运行count次，不好
        for (int k =0; k<count; k++)
        {
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:k inSection:0]];
            [self.attributesMArray addObject:attrs];
        }
    }
}

- (NSInteger)getRowsWithDataCount:(NSInteger)count
{
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
    rows = rows>self.rowCount?self.rowCount:rows;
    return  rows;
}

/** 计算collectionView的滚动范围 */
- (CGSize)collectionViewContentSize
{
    if (CGRectIsEmpty(self.collectionView.frame))
    {
        return CGSizeZero;
    }
    // 计算出item的宽度
    CGFloat itemWidth = (self.collectionView.frame.size.width - self.edgeInsets.left - self.columnsCount * self.columnSpacing) / self.columnsCount;
    // 从collectionView中获取到有多少个item
    NSInteger itemTotalCount = [self.collectionView numberOfItemsInSection:0];
    
    // 理论上每页展示的item数目
    NSInteger itemCount = self.rowCount * self.columnsCount;
    // 余数（用于确定最后一页展示的item个数）
    NSInteger remainder = itemTotalCount % itemCount;
    // 除数（用于判断页数）
    NSInteger pageNumber = itemTotalCount / itemCount;
    // 总个数小于self.rowCount * self.itemCountPerRow
    if (itemTotalCount <= itemCount) {
        pageNumber = 1;
    }else {
        if (remainder == 0) {
            pageNumber = pageNumber;
        }else {
            // 余数不为0,除数加1
            pageNumber = pageNumber + 1;
        }
    }
    
    CGFloat width = 0;
    // 考虑特殊情况(当item的总个数不是self.rowCount * self.itemCountPerRow的整数倍,并且余数小于每行展示的个数的时候)
    if (pageNumber > 1 && remainder != 0 && remainder < self.columnsCount) {
        width = self.edgeInsets.left + (pageNumber - 1) * self.columnsCount * (itemWidth + self.columnSpacing) + remainder * itemWidth + (remainder - 1)*self.columnSpacing + self.edgeInsets.right;
    }else {
        width = self.edgeInsets.left + pageNumber * self.columnsCount * (itemWidth + self.columnSpacing) - self.columnSpacing + self.edgeInsets.right;
    }
    
    NSInteger collectionWidth = CGRectGetWidth(self.collectionView.frame);
    if ((NSInteger)width%collectionWidth >0)
    {
        width = ((NSInteger)width/collectionWidth+1)*collectionWidth;
    }
    // 只支持水平方向上的滚动
    return CGSizeMake(width, 0);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //获取个数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSInteger rows = [self getRowsWithDataCount:count];
    
    // item的宽高由行列间距和collectionView的内边距决定
    CGFloat itemWidth = (self.collectionView.frame.size.width - self.edgeInsets.left - self.columnsCount * self.columnSpacing + self.columnSpacing/2) / self.columnsCount;
    CGFloat itemHeight = (self.collectionView.frame.size.height - self.edgeInsets.top - self.edgeInsets.bottom - (rows - 1) * self.rowSpacing) / rows;
    
    NSInteger item = indexPath.item;
    // 当前item所在的页,第几行第几例
    NSInteger pageNumber = item / (rows * self.columnsCount);
    NSInteger x = item % self.columnsCount + pageNumber * self.columnsCount;
    NSInteger y = item / self.columnsCount - pageNumber * rows;
    
    // 计算出item的坐标
    CGFloat itemX = self.edgeInsets.left + (itemWidth + self.columnSpacing) * x;
    CGFloat itemY = self.edgeInsets.top + (itemHeight + self.rowSpacing) * y;
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    // 每个item的frame
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    return attributes;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesMArray;
}

@end

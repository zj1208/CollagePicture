//
//  ZXWaterfallFlowLayout.m
//  lovebaby
//
//  Created by simon on 16/5/6.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "ZXWaterfallFlowLayout.h"


//设置item默认高度／ 最大高宽比／最小高宽比
static CGFloat itemDefaultHeigth =80.f;
static CGFloat itemMaxScale = 5.f/4.f;
static CGFloat itemMinScale = 1.f/2.f;


@interface ZXWaterfallFlowLayout ()

/** 这个字典用来存储所有列最大的Y值(每一列的高度)的集合 */
@property (nonatomic, strong) NSMutableDictionary *maxYDict;
/**
*  存放所有的布局属性LayoutAttributes
*/
@property (nonatomic, strong) NSMutableArray *attrsMArray;

@end


@implementation ZXWaterfallFlowLayout


- (instancetype)init
{
    if (self =[super init])
    {
         [self initData];
    }
    return self;
}



- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initData];
    }
    return self;
}



- (void)initData
{
    //设置默认值
    self.columnsCount = 2;
    self.columnMargin = 10;
    self.rowMargin = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.headerReferenceSize = CGSizeMake(0, 0);
    self.limitItemHeight = YES;
}


- (NSMutableDictionary *)maxYDict
{
    if (!_maxYDict) {
        self.maxYDict = [[NSMutableDictionary alloc] init];
    }
    return _maxYDict;
}


- (NSMutableArray *)attrsMArray
{
    if (!_attrsMArray) {
        
        self.attrsMArray = [[NSMutableArray alloc] init];
    }
    return _attrsMArray;
}

/**
 *  当初始化完collectionView，开始要布局的时候调用
 *  
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    for (int i=0; i<self.columnsCount; i++)
    {
        NSNumber *num = [NSNumber numberWithFloat:self.sectionInset.top];
        [self.maxYDict setObject:num forKey:[@(i) stringValue]];
    }
    
    [self.attrsMArray removeAllObjects];
    
    //必定实现的
//    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    
    if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)])
    {
        UICollectionViewLayoutAttributes *headerAttrs = [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [self.attrsMArray addObject:headerAttrs];
        
        for (int i=0; i<self.columnsCount; i++)
        {
            NSNumber *num = [NSNumber numberWithFloat:(self.sectionInset.top+headerAttrs.size.height)];
            [self.maxYDict setObject:num forKey:[@(i) stringValue]];
        }
    }
    if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)])
    {
        //获取个数
        NSInteger count = [self.collectionView numberOfItemsInSection:0];
        //这个遍历会导致返回indexPath对应item的属性的方法运行count次，不好
        for (int k =0; k<count; k++)
        {
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:k inSection:0]];
            [self.attrsMArray addObject:attrs];
        }
    }
}


//自定义Layout必须重写
/**
 *  返回整个内容的高度和宽度
 *
 *  @return return value description
 */


- (CGSize)collectionViewContentSize
{
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    
    __block NSString * maxColum = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj floatValue]>[[self.maxYDict objectForKey:maxColum]floatValue])
        {
            maxColum = key;
        }
    }];
    
    return CGSizeMake(contentWidth, [self.maxYDict[maxColum] floatValue] + self.sectionInset.bottom);
}


//自定义Layout必须重写
//UICollectionView调用这四个方法来确定布局信息；
 - (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
//    NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];
//    NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
//    [visibleIndexPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:obj];
//        [layoutAttributes addObject:attrs];
//
//    }];
//    return layoutAttributes;
//    NSLog(@"%@",NSStringFromCGRect(rect));
    return self.attrsMArray;
}

//自定义Layout必须重写
//根据indexPath 初始化UICollectionViewLayoutAttributes－Cell／SupplementaryView／DecorationView

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"indexPath.item=%ld",indexPath.item);
    // 假设最短的那一列的第0列
    __block NSString *minColumn = @"0";
    // 找出最短的那一列
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj floatValue] <[[self.maxYDict objectForKey:minColumn] floatValue])
        {
            minColumn = key;
        }
    }];
    
    //由于无法获取@protocol UICollectionViewDelegateFlowLayout 的item／header等size，所以需要自己写代理方法获取；
    CGFloat totalWidth = CGRectGetWidth(self.collectionView.frame)-self.sectionInset.left-self.sectionInset.right;
    CGFloat width = floorf((totalWidth-(self.columnsCount-1)*self.columnMargin)/self.columnsCount);
    
    //计算位置
    CGFloat x = self.sectionInset.left + (width +self.columnMargin)*[minColumn integerValue];
    CGFloat y = [[self.maxYDict objectForKey:minColumn]floatValue] + self.rowMargin;

    CGFloat height =[self showHeightForItemOfWidth:width atIndexPath:indexPath];
    
    //更新这一列的最大Y值-即重新赋值最短那一列的Y值
    [self.maxYDict setObject:@(y + height) forKey:minColumn];
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectMake(x, y, width, height);
    return attributes;
}

//自定义Layout根据需要重写
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    CGSize size = CGSizeZero;
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:referenceSizeForHeaderInSection:)])
    {
        size = [self.delegate waterflowLayout:self referenceSizeForHeaderInSection:indexPath.section];
    }

    attributes.frame = CGRectMake(self.sectionInset.left, self.sectionInset.top, CGRectGetWidth(self.collectionView.bounds)-self.sectionInset.left-self.sectionInset.right, size.height);
    return attributes;
}

//
//- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
//    return nil;
//}

                                                                                                    - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) !=CGRectGetWidth(oldBounds))
    {
        return YES;
    }
    return NO;
}

/**
 *  获取item的高度;先根据协议获取高度；再判断是否限制高度；
 *
 *  @param width     width description
 *  @param indexPath indexPath description
 *
 *  @return return 如果限制了高度，则返回限制后计算的高度；如果不限制高度，则返回原始比例高度；
 */
- (CGFloat)showHeightForItemOfWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = itemDefaultHeigth;
    
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:referenceHeightForItemOfWidth:atIndexPath:)])
    {
        CGFloat height2 = [self.delegate waterflowLayout:self referenceHeightForItemOfWidth:width atIndexPath:indexPath];
        if (height2>0)
        {
            height = height2;
        }
    }
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:limitItemHeightAtIndexPath:)])
    {
        if ([self.delegate waterflowLayout:self limitItemHeightAtIndexPath:indexPath])
        {
            //设置高度与宽度的比例
            if (height/width<itemMinScale)
            {
                height= width*itemMinScale;
            }
            if (height/width>itemMaxScale)
            {
                height= width*itemMaxScale;
            }
            
        }
    }
    else if (self.limitItemHeight)
    {
        //设置高度与宽度的比例
        if (height/width<itemMinScale)
        {
            height= width*itemMinScale;
        }
        if (height/width>itemMaxScale)
        {
            height= width*itemMaxScale;
        }
        
    }
    return height;
}
@end

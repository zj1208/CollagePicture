//
//  ZXLabelsTagsView.m
//  YiShangbao
//
//  Created by simon on 17/2/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXLabelsTagsView.h"

static NSInteger const ZXMaxItemCount = 10;


static CGFloat const ZXMinimumInteritemSpacing = 12.f;//item之间最小间隔
static CGFloat const ZXMinimumLineSpacing = 12.f; //最小行间距

static NSString * const reuseTagsCell = @"Cell";

@interface ZXLabelsTagsView ()

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;

@end

@implementation ZXLabelsTagsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
     //只用于在加载完ui－initWithCoder之后，对IBOutlet 连接的子控件进行初始化工作；
    [super awakeFromNib];
}


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
    self.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    self.minimumInteritemSpacing = ZXMinimumInteritemSpacing;
    self.minimumLineSpacing = ZXMinimumLineSpacing;
    self.maxItemCount = ZXMaxItemCount;
    self.apportionsItemWidthsByContent = NO;
    // 适合最多4个字的宽度
    self.itemSameSize = CGSizeMake(82.f, 30.f);
    self.titleFontSize = 14.f;
    self.cellSelectedStyle = NO;
    self.clipsToBounds = YES;
    [self addSubview:self.collectionView];
}



#pragma mark - layoutSubviews

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Setter



- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    if (self.cellSelectedStyle)
    {
        NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
        [visibleIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            LabelCell * cell = (LabelCell *)[self.collectionView cellForItemAtIndexPath:obj];
            [self collectionView:self.collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
            
        }];
 
    }

}



- (NSMutableArray *)dataMArray {
    if (_dataMArray == nil) {
        _dataMArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataMArray;
}


#pragma mark - UICollectionView

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = self.sectionInset;
        self.collectionFlowLayout = flowLayout;
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collection.backgroundColor = [UIColor whiteColor];
        collection.delegate = self;
        collection.dataSource = self;

        UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([LabelCell class]) bundle:nil];
        [collection registerNib:cellNib forCellWithReuseIdentifier:reuseTagsCell];
        collection.scrollEnabled = NO;
        
        _collectionView = collection;

    }
    return _collectionView;
}

- (void)setCollectionViewLayoutWithEqualSpaceAlign:(AlignType)alignType withItemEqualSpace:(CGFloat)equalSpace animated:(BOOL)animated
{
    
    EqualSpaceFlowLayoutEvolve * flowLayout = [[EqualSpaceFlowLayoutEvolve alloc]initWthType:alignType];
    flowLayout.betweenOfCell = equalSpace ==NSNotFound?10:equalSpace;
    self.collectionFlowLayout = flowLayout;
    flowLayout.sectionInset = self.sectionInset;
    [self.collectionView setCollectionViewLayout:flowLayout animated:NO completion:^(BOOL finished) {
        
    }];
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
    LabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseTagsCell forIndexPath:indexPath];
    cell.titleLab.font = [UIFont systemFontOfSize:self.titleFontSize];
    cell.title = [self.dataMArray objectAtIndex:indexPath.item];    // Configure the cell
    if (!self.apportionsItemWidthsByContent)
    {
        cell.height = self.itemSameSize.height;
    }
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.sectionInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.minimumInteritemSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.apportionsItemWidthsByContent)
    {
        static LabelCell *cell =  nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            if (cell == nil) {
                cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([LabelCell class]) owner:nil options:nil][0];
            }
        });
        cell.titleLab.font = [UIFont systemFontOfSize:self.titleFontSize];
        cell.title = [self.dataMArray objectAtIndex:indexPath.item];
        cell.height = 26.f;
        return [cell sizeForCell];
    }
    
    return self.itemSameSize;
}

// 展示数据外观更改
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    为什么cell的backgoundColor设置无效?
    LabelCell *newCell = (LabelCell *)cell;

    if (newCell.selected && self.cellSelectedStyle)
    {
        UIColor *textColor = [UIColor colorWithRed:255.f/255 green:84.f/255 blue:52.f/255 alpha:1];
        newCell.titleLab.textColor = textColor;
        newCell.titleLab.layer.borderColor = textColor.CGColor;
        newCell.titleLab.backgroundColor = [UIColor colorWithRed:255.f/255 green:245.f/255 blue:241.f/255 alpha:1];
    }
    else
    {
        // 默认设置
        newCell.titleLab.textColor = [UIColor redColor];
        newCell.titleLab.layer.borderColor = [UIColor redColor].CGColor;
        newCell.titleLab.backgroundColor = self.tagBackgroudColor?self.tagBackgroudColor:[UIColor whiteColor];
    }

 
    if ([self.delegate respondsToSelector:@selector(zx_labelsTagsView:willDisplayCell:forItemAtIndexPath:)])
    {
        [self.delegate zx_labelsTagsView:self willDisplayCell:newCell forItemAtIndexPath:indexPath];
    }
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellSelectedStyle)
    {
        NSArray *visibleIndexPaths = [collectionView indexPathsForVisibleItems];
        [visibleIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            LabelCell * cell = (LabelCell *)[collectionView cellForItemAtIndexPath:obj];
            [self collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
            
        }]; 
    }

    if ([self.delegate respondsToSelector:@selector(zx_labelsTagsView:collectionView:didSelectItemAtIndexPath:)])
    {
        [self.delegate zx_labelsTagsView:self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}


//计算collectionView的总高度;前提是self.frame必须有值，不然无法计算；
// 获取高度的地方，数据源必须重新赋值
// 返回cell（view）重用的内存地址-独立重用view获取高度的内存地址，例如：【 ***280-***060，  ***ba0-***060 ， ***100-***060，  ***8b0-***060，  ***280-***060】,总结：cell/tableFooterView/tableHeaderView（返回view）重用原理一样，根据初始化屏幕的几个cell/tableFooterView/tableHeaderView依次重用，但是在获取cell/tableFooterView/tableHeaderView高度独立设置重用的地方永远只重用一个；
- (CGFloat)getCellHeightWithContentData:(NSArray *)data
{
    if (!data || [data count]==0)
    {
        self.collectionView.frame =CGRectZero;
        return 0;
    }
    [self setData:data];
    
    NSInteger maxIndex = [self.dataMArray count]-1;
    NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:maxIndex inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath];
    CGFloat height = CGRectGetMaxY(attributes.frame)+self.sectionInset.bottom;
//    NSLog(@"%f",height);
    return ceilf(height);
}



- (void)setData:(NSArray *)data
{
//    在dispatch_once使用的重用中，永远使用第一个collectionView和collectionView的数据源，如果2个重用collectionView的数据源数组是一样的，比如新数组和旧数组都是“查看详情”，只要复用的collectionView所有属性不更新变动，那么collectionView的所有属性也是一样的，布局也是一样的； 外部tableView获取高度的重用，永远是重用第一个cell，所以获取高度的地方永远是跟第一个重用的colletionView比较，遇到被重用的时候，不管是数据更新，还是高度获取，都是2次不同的业务比较； 都实时更新才不会出错，不要复用以前的高度而不更新collectionView；
    if (![self.dataMArray isEqualToArray:data])
    {
        [self.dataMArray removeAllObjects];
        
        if ([data count] > self.maxItemCount)
        {
            NSRange range = NSMakeRange(0, self.maxItemCount);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            data = [NSMutableArray arrayWithArray:[data objectsAtIndexes:set]];
        }
        [self.dataMArray addObjectsFromArray:data];
        self.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self.collectionView reloadData];
    }
}

- (CGFloat)getDispatchOnceCellHeightWithContentData:(NSArray *)data
{
    if (!data || [data count]==0)
    {
        self.collectionView.frame =CGRectZero;
        return 0;
    }
    if (![self.dataMArray isEqualToArray:data])
    {
        [self.dataMArray removeAllObjects];
        
        if ([data count] > self.maxItemCount)
        {
            NSRange range = NSMakeRange(0, self.maxItemCount);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            data = [NSMutableArray arrayWithArray:[data objectsAtIndexes:set]];
        }
        [self.dataMArray addObjectsFromArray:data];
    }
    self.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.collectionView reloadData];
    
    NSInteger maxIndex = [self.dataMArray count]-1;
    NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:maxIndex inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath];
    CGFloat height = CGRectGetMaxY(attributes.frame)+self.sectionInset.bottom;
    //    NSLog(@"%f",height);
    if (height>50)
    {
        
    }
    return ceilf(height);
}

@end

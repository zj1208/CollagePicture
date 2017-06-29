//
//  ZXLabelsTagsView.m
//  YiShangbao
//
//  Created by simon on 17/2/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXLabelsTagsView.h"


static NSInteger ZXMaxItemCount = 10;


static CGFloat ZXMinimumInteritemSpacing = 10.f;//item之间最小间隔
static CGFloat ZXMinimumLineSpacing = 10.f; //最小行间距

static NSString * const reuseInputTagsCell = @"Cell";

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
    //[self commonInit];
    //只用于在加载完ui－initWithCoder之后，对IBOutlet 连接的子控件进行初始化工作；
    [super awakeFromNib];
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
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
        //如果写在这里，永远是这个值；
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}


- (void)commonInit
{
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.minimumInteritemSpacing = ZXMinimumInteritemSpacing;
    self.minimumLineSpacing = ZXMinimumLineSpacing;
    self.maxItemCount = ZXMaxItemCount;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = self.sectionInset;
    self.collectionFlowLayout = flowLayout;
    
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView = collection;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    
    
    if (!_dataMArray)
    {
        _dataMArray = [NSMutableArray array];
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:nibName_LabelCell bundle:nil] forCellWithReuseIdentifier:reuseInputTagsCell];
    
    self.collectionView.scrollEnabled = NO;
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
 
    return self.dataMArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseInputTagsCell forIndexPath:indexPath];
    cell.highlighted = YES;
    cell.title = [self.dataMArray objectAtIndex:indexPath.item];    // Configure the cell
    return cell;
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.sectionInset;
    //    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.minimumLineSpacing;
    //    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.minimumInteritemSpacing;
    //    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(0, 10);
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static LabelCell *cell =  nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"LabelCell" owner:nil options:nil][0];
        }
    });
    
    cell.title = [self.dataMArray objectAtIndex:indexPath.item];    
    return [cell sizeForCell];
}

//展示数据外观更改
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCell *newCell = (LabelCell *)cell;
    
    if ([self.delegate respondsToSelector:@selector(zx_labelsTagsView:willDisplayCell:forItemAtIndexPath:)])
    {
        [self.delegate zx_labelsTagsView:self willDisplayCell:newCell forItemAtIndexPath:indexPath];
    }
    else
    {
        //默认设置
        newCell.titleLab.textColor = [UIColor redColor];
        newCell.layer.borderColor = [UIColor redColor].CGColor;
        newCell.titleLab.backgroundColor = self.tagBackgroudColor?self.tagBackgroudColor:[UIColor whiteColor];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(zx_labelsTagsView:collectionView:didSelectItemAtIndexPath:)])
    {
        [self.delegate zx_labelsTagsView:self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
//    //添加标签
//    if (indexPath.item ==self.dataMArray.count &&self.isExistInputItem &&_dataMArray.count <self.maxItemCount)
//    {
//        if ([self.delegate respondsToSelector:@selector(zxInputActionWithCollectionView:didSelectItemAtIndexPath: didAddTags:)])
//        {
//            [self.delegate zxInputActionWithCollectionView:collectionView didSelectItemAtIndexPath:indexPath didAddTags:self.dataMArray];
//        }
//        else
//        {
//            [self presentAlertController];
//        }
//    }
//    //其余选中事件是删除标签
//    else
//    {
//        [self reloadDataWithDeleteObjectWithCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
//    }
}


//计算collectionView的总高度

- (CGFloat)getCellHeightWithContentData:(NSArray *)data
{
    if ([data count]==0)
    {
        return 0.f;
    }
    [self setData:data];
    
    NSInteger item = [self.dataMArray count]-1;
    NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath];
    return CGRectGetMaxY(attributes.frame)+self.collectionFlowLayout.sectionInset.bottom;
}

- (void)setData:(NSArray *)data
{
    if (![self.dataMArray isEqualToArray:data])
    {
        [self.dataMArray removeAllObjects];
        
        if ([data count] > self.maxItemCount)
        {
            NSRange range = NSMakeRange(0, self.maxItemCount);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            data = [NSMutableArray arrayWithArray:[data objectsAtIndexes:set]];
        };
        
        [self.dataMArray addObjectsFromArray:data];
        [self.collectionView reloadData];    }
}


@end

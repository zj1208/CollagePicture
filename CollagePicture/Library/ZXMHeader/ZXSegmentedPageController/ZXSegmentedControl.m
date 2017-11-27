//
//  ZXSegmentedControl.m
//  Demo
//
//  Created by simon on 2017/9/5.
//  Copyright © 2017年 simon. All rights reserved.
//

#import "ZXSegmentedControl.h"


@interface ZXSegmentedControl ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSources;

//指示条线
@property (nonatomic, strong) UIView *indicateLine;

//底部分割线
@property (nonatomic, strong) UIView *bottomDivideLine;

@end

@implementation ZXSegmentedControl

#pragma mark - 初始化

+ (instancetype)segmentViewWithSectionTitles:(NSArray<NSString *> *)titles {
    
    ZXSegmentedControl *segment = [[ZXSegmentedControl alloc]init];

    [segment setSectionTitles:titles];
//    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:datas.count];
//    BOOL isDefault = YES;
//    for (NSString *str in datas) {
//        ZXSegmentModel *model = [[ZXSegmentModel alloc]init];
//        model.title = str;
//        if (isDefault)
//        {
//            model.selected = YES;
//            isDefault = NO;
//        }
//        [tmpArr addObject:model];
//    }
//    
//    segment.dataSources = [NSMutableArray arrayWithArray:tmpArr];
    
    return segment;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
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
    self.selectedColor = [UIColor redColor];
    self.normalColor = [UIColor blackColor];
    _fontSize = 15.f;
    self.selectedFontSize = 15.f;
    self.selectedIndex = NSNotFound;
    self.hideBottomDivideLine = NO;
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 8, 0, 8);
    self.minimumItemSpacing = 10.f;
    self.selectionIndicatorColor = self.selectedColor;
    self.selectionIndicatorHeight = 3.f;
    
    [self addSubview:self.collectionView];

    //先添加collectionView，再添加indicateLine
//    [self.collectionView addSubview:self.indicateLine];
//    [self addSubview:_bottomDivideLine];

}

#pragma mark - setters
- (void)setSectionTitles:(NSArray *)sectionTitles
{
    _sectionTitles = sectionTitles;
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:sectionTitles.count];
    
    BOOL isDefault = YES;
    for (NSString *str in sectionTitles) {
        ZXSegmentModel *model = [[ZXSegmentModel alloc]init];
        model.title = str;
        model.fontSize = self.fontSize;
        if (isDefault) {
            model.selected = YES;
            isDefault = NO;
        }
        [tmpArr addObject:model];
    }
    
    self.dataSources = [NSMutableArray arrayWithArray:tmpArr];
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
}

//所有属性设置完后，一定要调用一下reloadData根据参数重新布局，不然属性设置无效果；
- (void)reloadData
{
    if (self.selectedIndex !=NSNotFound)
    {
        [self.dataSources enumerateObjectsUsingBlock:^(ZXSegmentModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.selected = self.selectedIndex==idx?YES:NO;
        }];
    }
    [self.collectionView reloadData];
    self.bottomDivideLine.hidden = self.hideBottomDivideLine;

}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex ==NSNotFound)
    {
        return;
    }
    _selectedIndex = selectedIndex;
    if (selectedIndex<self.dataSources.count)
    {
        [self setSelectedIndex:selectedIndex animation:YES];
    }

}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    if (self.dataSources.count > 0) {
        for (ZXSegmentModel *model in self.dataSources)
        {
            model.fontSize = fontSize;
        }
    }
}


- (void)setSelectedIndex:(NSInteger)selectedIndex animation:(BOOL)animation {
    
    if (selectedIndex>=self.dataSources.count)
    {
        NSLog(@"越界了");
        return;
    }
    _selectedIndex = selectedIndex;


    
    [self.dataSources enumerateObjectsUsingBlock:^(ZXSegmentModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == selectedIndex) {
            obj.selected = YES;
        }
        else
        {
            obj.selected = NO;

        }
    }];
    
    
   [self.collectionView reloadData];

//     没有效果，还是没有解决问题；
//   [self layoutIfNeeded];
    // 滚动到哪里；
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:selectIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animation];
    [self moveLineToIndexPath:selectIndexPath animation:YES];
}


#pragma mark - Getter

- (UIView *)indicateLine {
    if (_indicateLine == nil) {
        _indicateLine = [[UIView alloc]init];
        _indicateLine.backgroundColor = _selectionIndicatorColor;
        [self.collectionView addSubview:_indicateLine];
    }
    return _indicateLine;
}


- (UIView *)bottomDivideLine
{
    if (!_bottomDivideLine)
    {
        _bottomDivideLine = [[UIView alloc] init];
        _bottomDivideLine.backgroundColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1];
        [self addSubview:_bottomDivideLine];

    }
    return _bottomDivideLine;
}

#pragma mark - UICollectionView & UICollectionViewDelegate & UICollectionViewDataSource

#pragma mark -UICollectionView

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = self.minimumItemSpacing;
        UICollectionView *collection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        collection.delegate = self;
        collection.dataSource = self;
        collection.backgroundColor = self.backgroundColor;
        collection.showsVerticalScrollIndicator = NO;
        collection.showsHorizontalScrollIndicator = NO;
        [collection registerClass:[ZXSegmentCell class] forCellWithReuseIdentifier:@"ZXSegmentCellID"];
//        [self addSubview:collection];
        _collectionView = collection;
    }
    return _collectionView;
}


#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXSegmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXSegmentCellID" forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor blueColor];
    ZXSegmentModel *model = [self.dataSources objectAtIndex:indexPath.row];

    cell.selectedColor = self.selectedColor;
    cell.normalColor = self.normalColor;
    cell.normalFontSize= self.fontSize;
    cell.selectedFontSize = self.selectedFontSize;
    cell.isSelected = model.selected;

    if (model.title)
    {
        cell.title = model.title;
    }
    else if (model.attributedTitle)
    {
        cell.attributedTitle = model.attributedTitle;
    }
    return cell;
}



#pragma mark -UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXSegmentModel *model = [self.dataSources objectAtIndex:indexPath.row];
    return CGSizeMake(model.width, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return self.segmentEdgeInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.minimumItemSpacing;
}

#pragma mark -UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(zx_segmentView:willDisplayCell:forItemAtIndexPath:)])
    {
        ZXSegmentCell *cell1 = (ZXSegmentCell *)cell;
        [self.delegate zx_segmentView:self willDisplayCell:cell1 forItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self setSelectedIndex:indexPath.row animation:YES];
    
    // 代理回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(zx_segmentView:didSelectedIndex:)]) {
        
        [self.delegate zx_segmentView:self didSelectedIndex:indexPath.item];
    }
//    // block 回调
//    if (self.selectBlock) {
//        self.selectBlock(indexPath.row);
//    }
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
//    NSIndexPath *path = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
//    [self moveLineToIndexPath:path animation:YES];
}

#pragma mark - 移动横线

- (void)moveLineToIndexPath:(NSIndexPath *)indexPath animation:(BOOL)animation
{
    UICollectionViewLayoutAttributes *layoutAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect lineBounds = self.indicateLine.bounds;
    if (self.selectionStyle == ZXSegmentedControlSelectionStyleTextWidthStripe)
    {
        lineBounds.size.width = layoutAttributes.size.width - 10;
    }
    else
    {
        lineBounds.size.width = layoutAttributes.size.width;
    }
    CGPoint lineCenter = self.indicateLine.center;
    lineCenter.x = layoutAttributes.center.x;
    
    if (animation) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.indicateLine.bounds = lineBounds;
            self.indicateLine.center = lineCenter;
        }];
    } else {
        
        self.indicateLine.bounds = lineBounds;
        self.indicateLine.center = lineCenter;
    }
    
}

//1.父视图init初始化当前view，或添加当前view（addSubview），不会触发回调这个layoutSubviews方法；
//例如：当前view是ZXSegmentedControl；
//_segmentView = [[ZXSegmentedControl alloc]init] ;
//[self.view addSubview:_segmentView];

//2.父视图控制器设置当前view的frame的时候，等走完父视图控制器的viewDidLayoutSubview会触发；


//走collectionView代理，根据参数布局collectionView；
//再走父视图控制器的viewDidLayoutSubview，
//再走子视图layoutSubviews；
#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.backgroundColor = self.backgroundColor;
    self.collectionView.frame = self.bounds;
    
    NSInteger index = self.selectedIndex !=NSNotFound?self.selectedIndex:0;
    ZXSegmentModel *model = [self.dataSources objectAtIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    //没有走代理方法的时候，是nil无cell;
    UICollectionViewLayoutAttributes *layoutAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
//    ZXSegmentCell *cell = (ZXSegmentCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (self.selectionStyle == ZXSegmentedControlSelectionStyleFullWidthStripe) {
        self.indicateLine.frame = CGRectMake(4, CGRectGetHeight(self.frame) - self.selectionIndicatorHeight-1, model.width, self.selectionIndicatorHeight);
    }
    else if (self.selectionStyle == ZXSegmentedControlSelectionStyleTextWidthStripe)
    {
        self.indicateLine.frame = CGRectMake(4, CGRectGetHeight(self.frame) - self.selectionIndicatorHeight-1, model.width-10, self.selectionIndicatorHeight);
    }
    CGPoint lineCenter = self.indicateLine.center;
    lineCenter.x = layoutAttributes.center.x;
    self.indicateLine.center = lineCenter;

    NSLog(@"%@",NSStringFromCGPoint(lineCenter));
    self.indicateLine.layer.masksToBounds = YES;
    self.indicateLine.layer.cornerRadius = CGRectGetHeight(self.indicateLine.frame)/2;
    
    
    [self bringSubviewToFront:_bottomDivideLine];
    self.bottomDivideLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5);
//    [self setSelectedIndex:self.selectedIndex animation:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



@interface ZXSegmentCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZXSegmentCell

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle
{
    _attributedTitle = attributedTitle;
    self.titleLabel.attributedText = attributedTitle;
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    self.titleLabel.textColor = self.isSelected ? _selectedColor : _normalColor;
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    self.titleLabel.textColor = self.isSelected ? selectedColor : _normalColor;

}
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    self.titleLabel.textColor = isSelected ? _selectedColor : _normalColor;
    self.titleLabel.font = isSelected ? [UIFont systemFontOfSize:_selectedFontSize] : [UIFont systemFontOfSize:_normalFontSize];
}
- (void)setNormalFontSize:(CGFloat)normalFontSize {
    _normalFontSize = normalFontSize;
    
    self.titleLabel.font = [UIFont systemFontOfSize:normalFontSize];
}


- (void)setSelectedFontSize:(CGFloat)selectedFontSize
{
    _selectedFontSize = selectedFontSize;

}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _selectedColor = [UIColor redColor];
        _normalColor = [UIColor blackColor];
        _normalFontSize = 15.0;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.backgroundColor = self.backgroundColor;
    self.titleLabel.frame = self.bounds;
}

@end


@implementation ZXSegmentModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _selected = NO;
        _fontSize = 15.0;
        _selectedFontSize = 15.f;
    }
    
    return self;
}
- (CGFloat)width
{
    if (_width <= 0)
    {
        if (self.attributedTitle)
        {
            _width = self.attributedTitle.size.width+10 ;
        }
        else
        {
            NSString *string = self.title?self.title:self.attributedTitle.string;
            CGFloat wid = [string boundingRectWithSize:CGSizeMake(0, 40) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize]} context:nil].size.width;
            
            _width = wid + 10;
 
        }
     }
    
    return _width;
}


@end

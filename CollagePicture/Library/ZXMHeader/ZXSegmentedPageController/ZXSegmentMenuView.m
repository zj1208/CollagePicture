//
//  ZXSegmentMenuView.m
//  Demo
//
//  Created by simon on 2017/9/7.
//  Copyright © 2017年 simon. All rights reserved.
//

#import "ZXSegmentMenuView.h"
#import "ZXOverlay.h"
#import "ZXLabelsTagsView.h"

static CGFloat const ZXSegmentChoseBtnWidth = 50.f;
static CGFloat const ZXSegmentChoseBtnHeight = 40.f;


@interface ZXSegmentMenuView ()<ZXOverlayDelegate,ZXLabelsTagsViewDelegate>

@property (nonatomic, strong) UIButton *choseBtn;

//底部分割线
@property (nonatomic, strong) UIView *bottomDivideLine;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) ZXLabelsTagsView *labelsTagsView;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ZXSegmentMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomDivideLine];
    
    self.menuHeaderViewHeight = ZXSegmentChoseBtnHeight;
}



- (UILabel *)titleLab
{
    if (!_titleLab)
    {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"选择订单状态";
        lab.textColor = [UIColor colorWithRed:134.f/255 green:134.f/255 blue:134.f/255 alpha:1];
        lab.font = [UIFont systemFontOfSize:13];
        [self addSubview:lab];
        _titleLab = lab;
    }
    return _titleLab;
}


- (UIButton *)choseBtn
{
    if (!_choseBtn)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"arrows_up"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dismssMenuView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _choseBtn = btn;
    }
    return _choseBtn;
}


- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
}

- (void)dismssMenuView:(UIButton *)sender
{
    [self zxOverlaydissmissAction];
}



- (UIView *)bottomDivideLine
{
    if (!_bottomDivideLine)
    {
        _bottomDivideLine = [[UIView alloc] init];
        _bottomDivideLine.backgroundColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1];
        
    }
    return _bottomDivideLine;
}



- (ZXLabelsTagsView *)labelsTagsView
{
    if (!_labelsTagsView)
    {
        ZXLabelsTagsView *tagsView = [[ZXLabelsTagsView alloc] init];
        tagsView.maxItemCount = 50;
        tagsView.delegate =self;
        tagsView.minimumLineSpacing = 20.f;
        tagsView.titleFontSize = 13.f;
        tagsView.cellSelectedStyle = YES;
        [self addSubview:tagsView];
        _labelsTagsView = tagsView;
    }
    return _labelsTagsView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.choseBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-ZXSegmentChoseBtnWidth, 0, ZXSegmentChoseBtnWidth, self.menuHeaderViewHeight);
    
    self.titleLab.frame = CGRectMake(10, 0, CGRectGetWidth(self.frame)-ZXSegmentChoseBtnWidth-20, self.menuHeaderViewHeight);
    
    self.bottomDivideLine.frame = CGRectMake(0, CGRectGetMaxY(self.choseBtn.frame), CGRectGetWidth(self.frame), 0.5);
    CGFloat tagsViewHeight = [self.labelsTagsView getCellHeightWithContentData:self.itemTitles];
    self.labelsTagsView.frame = CGRectMake(0, CGRectGetMaxY(self.bottomDivideLine.frame), CGRectGetWidth(self.frame), tagsViewHeight);
}

- (void)setItemTitles:(NSArray *)itemTitles
{
    _itemTitles = itemTitles;
    [self.labelsTagsView setData:itemTitles];
}


- (void)zx_labelsTagsView:(ZXLabelsTagsView *)labelsTagView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self zxOverlaydissmissAction];
    if ([self.delegate respondsToSelector:@selector(zx_segmentMenuView:didSelectItemAtIndexPath:)])
    {
        [self.delegate zx_segmentMenuView:self didSelectItemAtIndexPath:indexPath];
    }
}

- (void)zx_labelsTagsView:(ZXLabelsTagsView *)labelsTagView willDisplayCell:(LabelCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (cell.selected)
    {
        UIColor *color = [UIColor colorWithRed:255.f/255 green:84.f/255 blue:52.f/255 alpha:1];
        cell.titleLab.textColor =color;
        cell.titleLab.layer.borderColor = color.CGColor;
        UIColor *color2 = [UIColor colorWithRed:255.f/255 green:245.f/255 blue:241.f/255 alpha:1];
        
        cell.titleLab.backgroundColor = color2;
    }
    else
    {
        UIColor *color = [UIColor colorWithRed:83.f/255 green:83.f/255 blue:83.f/255 alpha:1];
        cell.titleLab.textColor = color;
        UIColor *color2 = [UIColor colorWithRed:134.f/255 green:134.f/255 blue:134.f/255 alpha:1];
        cell.titleLab.layer.borderColor = color2.CGColor;
        cell.titleLab.backgroundColor = nil;
    }
    
    if ([self.delegate respondsToSelector:@selector(zx_segmentMenuView:labelTagsView:willDisplayCell:forItemAtIndexPath:)])
    {
        [self.delegate zx_segmentMenuView:self labelTagsView:labelsTagView willDisplayCell:cell forItemAtIndexPath:indexPath];
    }
}
//动画问题待解决
- (void)showInView:(UIView *) view
{
    if ([view isKindOfClass:[UITableView class]] ||[view isKindOfClass:[UICollectionView class]])
    {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    ZXOverlay *overlay = [[ZXOverlay alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
    overlay.delegate = self;
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    [self layoutIfNeeded];
    
    self.labelsTagsView.selectedIndex = _selectedIndex;

    CGFloat tagsViewHeight = [self.labelsTagsView getCellHeightWithContentData:self.itemTitles];
    CGFloat totalHeight = self.menuHeaderViewHeight +0.5 +tagsViewHeight;
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), ZXSegmentChoseBtnHeight);


    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), totalHeight);
        
    } completion:^(BOOL finished) {
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

//
- (void)zxOverlaydissmissAction
{
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.15
                     animations:^{
                         
                         self.frame = CGRectMake(0,0, CGRectGetWidth(self.frame),ZXSegmentChoseBtnHeight);
                         self.superview.alpha = 0.1;
                         self.alpha = 0.3;
                     }
                     completion:^(BOOL finished){
                         
                         [self.superview removeFromSuperview];
                         [self removeFromSuperview];
                         self.alpha = 1.0f;
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }];

}

@end

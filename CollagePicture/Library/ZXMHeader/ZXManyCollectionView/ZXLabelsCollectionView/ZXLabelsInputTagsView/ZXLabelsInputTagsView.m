//
//  ZXLabelsInputTagsView.m
//  YiShangbao
//
//  Created by simon on 17/2/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXLabelsInputTagsView.h"

#ifndef LCDW
#define LCDW [[UIScreen mainScreen]bounds].size.width
#define LCDScale_iphone6_Width(X)    X*LCDW/375
#endif


static NSInteger ZXMaxItemCount = 10;

static NSInteger ZXDefaultAlertFieldTextLength =10;
static NSString *ZXDefaultAddTagTitle = @"添加产品标签";
static NSString *ZXDefaultAlertTitle =@"输入产品标签";

static CGFloat ZXMinimumInteritemSpacing = 12.f;//item之间最小间隔
static CGFloat ZXMinimumLineSpacing = 12.f; //最小行间距

static CGFloat const ZXAddPicItemWidth = 60.f;
static CGFloat const ZXAddPicItemHeight = 24.f;

static NSString * const reuseInputTagsCell = @"Cell";

@interface ZXLabelsInputTagsView ()


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;

@property (nonatomic, strong) UIAlertAction *textAlertAction;
@end

@implementation ZXLabelsInputTagsView

- (BOOL)isExistInputItem
{
    return _existInputItem;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
//    [self commonInit];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = [[UIScreen mainScreen]bounds];
}

//- (void)setDefaultAddTagTitle:(NSString *)defaultAddTagTitle
//{
//    _defaultAddTagTitle = defaultAddTagTitle;
//    // [self setNeedsLayout];
////    [self.collectionView reloadData];    
//}
//
//- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing
//{
//    _minimumLineSpacing = minimumLineSpacing;
////    self.collectionFlowLayout.minimumLineSpacing = _minimumLineSpacing;
//}
//
//- (void)setSectionInset:(UIEdgeInsets)sectionInset
//{
//    _sectionInset = sectionInset;
//    self.collectionFlowLayout.sectionInset = _sectionInset;
//}
//
//- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
//{
//    _minimumInteritemSpacing = minimumInteritemSpacing;
//}

- (void)commonInit
{
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.itemWidth = ZXAddPicItemWidth;
    self.itemHeight = ZXAddPicItemHeight;
    self.itemSize = CGSizeMake(ZXAddPicItemWidth, ZXAddPicItemHeight);
    self.minimumInteritemSpacing = LCDScale_iphone6_Width(ZXMinimumInteritemSpacing) ;
    self.minimumLineSpacing =LCDScale_iphone6_Width(ZXMinimumLineSpacing);
    self.defaultAlertTitle = ZXDefaultAlertTitle;
    self.defaultAlertFieldTextLength = ZXDefaultAlertFieldTextLength;
    self.existInputItem = YES;//输入标签默认存在
    self.maxItemCount = ZXMaxItemCount;
    self.defaultAddTagTitle = ZXDefaultAddTagTitle;
    
//    self.addTagColor = UIColorFromRGB_HexValue(0x979797);
//    self.addTagBorderColor = UIColorFromRGB_HexValue(0x979797);
//    self.addTagCornerRadius = 24/2;
}


- (NSMutableArray *)dataMArray
{
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
        [self addSubview:collection];
        
        [collection registerNib:[UINib nibWithNibName:nibName_LabelCell bundle:nil] forCellWithReuseIdentifier:reuseInputTagsCell];
        collection.scrollEnabled = NO;
        
        _collectionView = collection;
        
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.isExistInputItem &&_dataMArray.count <self.maxItemCount)
    {
        return self.dataMArray.count+1;
    }
    return self.dataMArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseInputTagsCell forIndexPath:indexPath];
    
    if (self.isExistInputItem && indexPath.item==self.dataMArray.count&&_dataMArray.count <self.maxItemCount)
    {
        cell.title = self.defaultAddTagTitle;

    }
    else
    {
        cell.title = [NSString stringWithFormat:@"%@ X",[self.dataMArray objectAtIndex:indexPath.item]];
    }
          // Configure the cell
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
            cell = [[NSBundle mainBundle]loadNibNamed:nibName_LabelCell owner:nil options:nil][0];
        }
    });
    
    if (indexPath.item ==self.dataMArray.count &&self.isExistInputItem &&_dataMArray.count <self.maxItemCount)
    {
        cell.title = self.defaultAddTagTitle;
        return [cell sizeForCell];
    }
    cell.title = [NSString stringWithFormat:@"%@ X",[self.dataMArray objectAtIndex:indexPath.item]];
    return [cell sizeForCell];
}

// 展示数据外观更改
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCell *newCell = (LabelCell *)cell;
    
    if ([self.delegate respondsToSelector:@selector(zx_labelsInputTagsView:willDisplayCell:forItemAtIndexPath:)])
    {
        [self.delegate zx_labelsInputTagsView:self willDisplayCell:newCell forItemAtIndexPath:indexPath];
    }
    else
    {
        
        //默认设置
        newCell.titleLab.textColor = [UIColor redColor];
        newCell.layer.borderColor = [UIColor redColor].CGColor;
        newCell.titleLab.backgroundColor = self.tagBackgroudColor?self.tagBackgroudColor:[UIColor whiteColor];
        
        if (indexPath.item ==self.dataMArray.count &&self.isExistInputItem &&_dataMArray.count <self.maxItemCount)
        {
            if (self.addTagColor)
            {
                newCell.titleLab.textColor =self.addTagColor;
            }
            if (self.addTagBorderColor)
            {
                newCell.layer.borderColor = self.addTagBorderColor.CGColor;
            }
            newCell.titleLab.backgroundColor = self.addTagBackgroudColor?self.addTagBackgroudColor:[UIColor whiteColor];
        }
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加标签
    if (indexPath.item ==self.dataMArray.count &&self.isExistInputItem &&_dataMArray.count <self.maxItemCount)
    {
        [self labelsInputTagsView:self commitEditingStyle:ZXLabelsInputCellEditingStyleInsert forRowAtIndexPath:indexPath];
    }
    // 其余选中事件是删除标签
    else
    {
        [self labelsInputTagsView:self commitEditingStyle:ZXLabelsInputCellEditingStyleDelete forRowAtIndexPath:indexPath];
    }
}

- (void)labelsInputTagsView:(ZXLabelsInputTagsView *)collectionView commitEditingStyle:(ZXLabelsInputCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除标签事件
    if (editingStyle == ZXLabelsInputCellEditingStyleDelete)
    {
        [self reloadDataWithDeleteObjectWithCollectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
    }
    // 添加标签事件
    else if (editingStyle == ZXLabelsInputCellEditingStyleInsert)
    {
        if ([self.delegate respondsToSelector:@selector(zx_labelsInputTagsView:collectionView:didSelectItemAtIndexPath:didAddTags:)])
        {
            [self.delegate zx_labelsInputTagsView:self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath didAddTags:_dataMArray];
        }
        else
        {
            [self addLabelsWithPresentAlertController];
        }
    }
}


// 删除标签
- (void)reloadDataWithDeleteObjectWithCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 当存在输入标签，而且已经到最大个数
    if (_dataMArray.count == self.maxItemCount && self.isExistInputItem)
    {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:_dataMArray.count inSection:0];
        [collectionView insertItemsAtIndexPaths:@[lastIndexPath]];
        
        [self.dataMArray removeObjectAtIndex:indexPath.item];
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
    
    // 不存在输入标签，或有输入标签但点击的不是输入标签
    else
    {
        [self.dataMArray removeObjectAtIndex:indexPath.item];
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
    // 删除事件
    if ([self.delegate respondsToSelector:@selector(zx_labelsInputTagsView:didChangedTagsWithTags:)])
    {
        NSMutableArray *tagsArray = [_dataMArray mutableCopy];
        [self.delegate zx_labelsInputTagsView:self didChangedTagsWithTags:tagsArray];
    }
}

#pragma mark - 默认添加标签弹框

- (void)addLabelsWithPresentAlertController
{
    NSString *aTitle = NSLocalizedString(@"", nil);
    NSString *aMessage = NSLocalizedString(self.defaultAlertTitle, nil);
    NSString *aCancelButtonTitle = NSLocalizedString(@"取消", @"Cancel");
    NSString *otherButtonTitle = NSLocalizedString(@"确定", @"OK");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:aTitle message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    __weak typeof (self) weakSelf = self;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:aCancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
         [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = [alertController.textFields firstObject];
        if (![ZXLabelsInputTagsView zhIsBlankString:textField.text])
        {   // 如果已经有这个内容item，则提示；
            if ([self.dataMArray containsObject:textField.text])
            {
                if ([self.delegate respondsToSelector:@selector(zx_labelsInputTagsViewWithAlertViewDoButtonAction)])
                {
                    [self.delegate zx_labelsInputTagsViewWithAlertViewDoButtonAction];
                }
            }
            else
            {
                [weakSelf reloadDataWithAddObject:textField.text];
            }
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
        }
      
    }];

    self.textAlertAction = otherAction;
    otherAction.enabled = NO;
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    UIViewController *vc = [self getMyViewController];

    [vc presentViewController:alertController animated:YES completion:nil];
}



#pragma mark 默认点击输入添加按钮 警告提示中的textField的 通知监听回调
- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification
{
     UITextField *textField = notification.object;
    self.textAlertAction.enabled = ![ZXLabelsInputTagsView zhIsBlankString:textField.text];
    if ([self.delegate respondsToSelector:@selector(zx_labelsInputTagsView:handleTextFieldTextDidChangeNotification:)])
    {
        [self.delegate zx_labelsInputTagsView:self handleTextFieldTextDidChangeNotification:notification];
    }
    else
    {
       
        if (textField.text.length >self.defaultAlertFieldTextLength)
        {
            textField.text = [textField.text substringToIndex:self.defaultAlertFieldTextLength];
        }
    }
}


// 添加标签时候的数据业务处理；虽然我增加了一个数据，但是在tableViewCell重用那，其实数据根本没有改变；所以要用同一个cell
- (void)reloadDataWithAddObject:(NSString *)title
{
    [_dataMArray insertObject:title atIndex:0];
    
    if (_dataMArray.count < self.maxItemCount)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    }
    
    if ([self.delegate respondsToSelector:@selector(zx_labelsInputTagsView:didChangedTagsWithTags:)])
    {
        //需要强引用，如果弱引用，在循环引用的时候，数据会被释放；
        NSMutableArray *tagsArray = [NSMutableArray arrayWithArray:self.dataMArray];
        [self.delegate zx_labelsInputTagsView:self didChangedTagsWithTags:tagsArray];
    }
}


#pragma mark - 计算collectionView的总高度

- (CGFloat)getCellHeightWithContentData:(NSArray *)data
{
    if (!self.existInputItem && [data count]==0)
    {
        return 0.f;
    }
    else
    {
        if ([data count] ==0)
        {
            return self.collectionFlowLayout.sectionInset.bottom+ self.collectionFlowLayout.sectionInset.top+_itemHeight;
        }
        [self setData:data];
        
        // 由于整个view被tableViewCell重用了，所以他只会记得init初始化的值；
        // [self layoutIfNeeded];
        NSInteger totalItem = [self.collectionView numberOfItemsInSection:0];
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:totalItem-1 inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath];
        CGFloat height = CGRectGetMaxY(attributes.frame)+self.collectionFlowLayout.sectionInset.bottom;
        return ceilf(height);
    }
}

#pragma mark - 设置数据

- (void)setData:(NSArray *)data
{
    [self.dataMArray removeAllObjects];
    
    if ([data count] > self.maxItemCount)
    {
        NSRange range = NSMakeRange(0, self.maxItemCount);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        data = [NSMutableArray arrayWithArray:[data objectsAtIndexes:set]];
    };
    
    [self.dataMArray addObjectsFromArray:data];
    [self.collectionView reloadData];

}

+ (BOOL)zhIsBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (UIViewController *)getMyViewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}



@end

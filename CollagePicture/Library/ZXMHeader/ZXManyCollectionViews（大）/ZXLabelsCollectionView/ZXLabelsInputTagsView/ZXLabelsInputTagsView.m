//
//  ZXLabelsInputTagsView.m
//  YiShangbao
//
//  Created by simon on 17/2/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXLabelsInputTagsView.h"


static NSInteger ZXMaxItemCount = 10;

static NSInteger ZXDefaultAlertFieldTextLength =10;
static NSString *ZXDefaultAddTagTitle = @"添加产品标签";
static NSString *ZXDefaultAlertTitle =@"输入产品标签";

static CGFloat ZXMinimumInteritemSpacing = 12.f;//item之间最小间隔
static CGFloat ZXMinimumLineSpacing = 12.f; //最小行间距

//static CGFloat const ZXAddPicItemWidth = 60.f;
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

// 更新self.collectionFlowLayout.sectionInset
- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    _sectionInset = sectionInset;
    self.collectionFlowLayout.sectionInset = _sectionInset;
}
//
//- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
//{
//    _minimumInteritemSpacing = minimumInteritemSpacing;
//}

- (void)commonInit
{
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.itemHeight = ZXAddPicItemHeight;
    self.minimumInteritemSpacing = LCDScale_iPhone6(ZXMinimumInteritemSpacing) ;
    self.minimumLineSpacing =LCDScale_iPhone6(ZXMinimumLineSpacing);
    self.defaultAlertTitle = ZXDefaultAlertTitle;
    self.defaultAlertFieldTextLength = ZXDefaultAlertFieldTextLength;
    self.existInputItem = YES;//输入标签默认存在
    self.maxItemCount = ZXMaxItemCount;
    self.defaultAddTagTitle = ZXDefaultAddTagTitle;
    
    self.tagTextColor = [UIColor redColor];
    self.tagBorderColor =  [UIColor redColor];
    self.tagBackgroudColor = [UIColor whiteColor];
    self.tagCornerRadius = self.itemHeight/2;
    
    self.addTagTextColor = [UIColor redColor];
    self.addTagBorderColor =  [UIColor redColor];
    self.addTagBackgroudColor = [UIColor whiteColor];
    self.addTagCornerRadius = self.itemHeight/2;
    
    [self addSubview:self.collectionView];
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
        
        [collection registerNib:[UINib nibWithNibName:NSStringFromClass([LabelCell class]) bundle:nil] forCellWithReuseIdentifier:reuseInputTagsCell];
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
    cell.height = self.itemHeight;

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
            cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([LabelCell class]) owner:nil options:nil][0];
        }
    });
    
    if (indexPath.item ==self.dataMArray.count &&self.isExistInputItem &&_dataMArray.count <self.maxItemCount)
    {
        cell.title = self.defaultAddTagTitle;
        cell.height = self.itemHeight;
        return [cell sizeForCellThatWidthFits:collectionView.bounds.size.width-self.sectionInset.left-self.sectionInset.right];
    }
    cell.title = [NSString stringWithFormat:@"%@ X",[self.dataMArray objectAtIndex:indexPath.item]];
    cell.height = self.itemHeight;
    return [cell sizeForCellThatWidthFits:collectionView.bounds.size.width-self.sectionInset.left-self.sectionInset.right];
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
        newCell.titleLab.textColor = self.tagTextColor;
        newCell.layer.borderColor = self.tagBorderColor.CGColor;
        newCell.titleLab.backgroundColor = self.tagBackgroudColor;
        newCell.layer.cornerRadius = self.tagCornerRadius;
//        添加按钮设置
        if (indexPath.item ==self.dataMArray.count &&self.isExistInputItem &&_dataMArray.count <self.maxItemCount)
        {
            newCell.titleLab.textColor =self.addTagTextColor;
            newCell.layer.borderColor = self.addTagBorderColor.CGColor;
            newCell.titleLab.backgroundColor = self.addTagBackgroudColor;
            newCell.layer.cornerRadius = self.addTagCornerRadius;
        }
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加标签
    if (indexPath.item ==self.dataMArray.count &&self.isExistInputItem &&_dataMArray.count <self.maxItemCount)
    {
        [self labelsInputTagsView:self commitEditingStyle:ZXLabelsInputCellEditingStyleInserting forRowAtIndexPath:indexPath];
    }
    // 其余选中事件是删除标签
    else
    {
        [self labelsInputTagsView:self commitEditingStyle:ZXLabelsInputCellEditingStyleDelete forRowAtIndexPath:indexPath];
    }
}

#pragma mark - 添加/删除标签 处理；
- (void)labelsInputTagsView:(ZXLabelsInputTagsView *)collectionView commitEditingStyle:(ZXLabelsInputCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除标签事件
    if (editingStyle == ZXLabelsInputCellEditingStyleDelete)
    {
        [self deleteTagsWithCommitEditingStyle:ZXLabelsInputCellEditingStyleDelete didSelectItemAtIndexPath:indexPath];
    }
    // 添加标签事件
    else if (editingStyle == ZXLabelsInputCellEditingStyleInserting)
    {
        if ([self.delegate respondsToSelector:@selector(zx_shuoldPopAddTagAlertViewLabelsInputTagsView:)])
        {
           BOOL should =  [self.delegate zx_shuoldPopAddTagAlertViewLabelsInputTagsView:self];
            if (!should)
            {
                return;
            }
        }
        [self popAlertControllerWithSelectItemAtIndexPath:indexPath];
    }
}


// 删除标签
- (void)deleteTagsWithCommitEditingStyle:(ZXLabelsInputCellEditingStyle)editingStyle didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 当存在输入标签，而且已经到最大个数
    if (_dataMArray.count == self.maxItemCount && self.isExistInputItem)
    {
        [self.dataMArray removeObjectAtIndex:indexPath.item];
        [self.collectionView reloadData];
    }
    // 有输入标签但点击的不是输入标签;或不存在输入标签
    else
    {
        [self.dataMArray removeObjectAtIndex:indexPath.item];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }

    if ([self.delegate respondsToSelector:@selector(zx_labelsInputTagsView:commitEditingStyle:forRowAtIndexPath:addTagTitle:)])
    {
        [self.delegate zx_labelsInputTagsView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath addTagTitle:nil];
    }
}

#pragma mark - 默认添加标签弹框

- (void)popAlertControllerWithSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *aTitle = NSLocalizedString(@"", nil);
    NSString *aMessage = NSLocalizedString(self.defaultAlertTitle, nil);
    NSString *aCancelButtonTitle = NSLocalizedString(@"取消", @"Cancel");
    NSString *otherButtonTitle = NSLocalizedString(@"确定", @"OK");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:aTitle message:aMessage preferredStyle:UIAlertControllerStyleAlert];
//    每次弹框都添加监听
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    __weak typeof (self) weakSelf = self;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:aCancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
         [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = [alertController.textFields firstObject];
        if (![ZXLabelsInputTagsView zhIsBlankString:textField.text])
        {
            BOOL should  = YES;
            if ([self.delegate respondsToSelector:@selector(zx_shuoldAddTagTitleWithLabelsInputTagsView:tagTitle:)])
            {
              should = [self.delegate zx_shuoldAddTagTitleWithLabelsInputTagsView:self tagTitle:textField.text];
            }
            if (should)
            {
                [weakSelf addTag:textField.text];
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
- (void)textFieldTextDidChangeNotification:(NSNotification *)notification
{
     UITextField *textField = notification.object;
    self.textAlertAction.enabled = ![ZXLabelsInputTagsView zhIsBlankString:textField.text];
    if ([self.delegate respondsToSelector:@selector(zx_labelsInputTagsView:textFieldTextDidChangeNotification:)])
    {
        [self.delegate zx_labelsInputTagsView:self textFieldTextDidChangeNotification:notification];
    }
    else
    {
       
        if (textField.text.length >self.defaultAlertFieldTextLength)
        {
            textField.text = [textField.text substringToIndex:self.defaultAlertFieldTextLength];
        }
    }
}



- (void)addTag:(NSString *)title
{
    [_dataMArray insertObject:title atIndex:0];
    
    if (_dataMArray.count < self.maxItemCount)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    }
    else
    {
        [self.collectionView reloadData];
    }
    
    if ([self.delegate respondsToSelector:@selector(zx_labelsInputTagsView:commitEditingStyle:forRowAtIndexPath:addTagTitle:)])
    {
        [self.delegate zx_labelsInputTagsView:self commitEditingStyle:ZXLabelsInputCellEditingStyleInserted forRowAtIndexPath:nil addTagTitle:title];
    }
}


#pragma mark - 计算collectionView的总高度

- (CGFloat)getCellHeightWithContentData:(nullable NSArray *)data
{
    if (!self.existInputItem && (!data || [data count]==0))
    {
        return 0.f;
    }
    else if (self.existInputItem && (!data || [data count]==0))
    {
        CGFloat height = self.collectionFlowLayout.sectionInset.bottom+ self.collectionFlowLayout.sectionInset.top+self.itemHeight;
        return height;
    }
    else
    {

        [self setData:data];
        
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
//    因为有操作增删，所以数组会变，需要重新更新；
    else if ([self.dataMArray isEqualToArray:data] && data.count ==0)
    {
        self.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self.collectionView reloadData];
    }
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

//
//  ZXAddPicCollectionView.m
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAddPicCollectionView.h"
#import "UIView+ZXChangeSize.h"
#import "UIImageView+WebCache.h"
#import <Photos/Photos.h>
#import "ZXAddPicPlaceholderCell.h"
#import "ZXAddPicCollectionConst.h"

static NSString * const reuseCell = @"Cell";
static NSString * const reusePlaceholderCell = @"placeholderCell";

// SYSTEMVERSION以上用iOS9移动方法，以下用iOS8可以用的通用方法；
static CGFloat SYSTEMVERSION = 12.0;

@interface ZXAddPicCollectionView ()<ZXAddPicViewCellDelegate,UIGestureRecognizerDelegate>


@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;
@property (nonatomic, strong) ZXAddPicPlaceholderCell *placeholderCell;

//编辑-删除item前后的内容高度；
@property (nonatomic, assign) CGFloat beforeDeleteContentHight;
@property (nonatomic, assign) CGFloat afterDeleteContentHight;


// 长按拖动有关属性：
//长按手势
@property (nonatomic, strong) UIGestureRecognizer *longPressGesture;
//刚选中的cell
@property (nonatomic, strong) ZXAddPicViewCell *beganSelectCell;
//移动前选中的indexPath
@property (nonatomic, strong) NSIndexPath *sourceIndexPath;
//移动到的目标indexPath
@property (nonatomic, strong) NSIndexPath *destinationIndexPath;
//是否改变了移动indexPath的item
@property (nonatomic, assign) BOOL isChangeMoveItem;
//长按cell位置 与长按下去的当前cell真实中心位置的坐标偏差;
@property (nonatomic, assign) CGPoint pressCellCenterOffest;
//长按手势began时是否允许；
@property (nonatomic, assign) BOOL shouldBegainLongPress;
//cell的属性数组；
@property (nonatomic, strong) NSMutableArray *cellAttributesMArray;

@end


@implementation ZXAddPicCollectionView

@synthesize picItemHeight = _picItemHeight;


#pragma mark -

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

- (void)layoutSubviews
{
    [super layoutSubviews];
   self.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.addPicCoverView.frame = self.bounds;
}



- (void)commonInit
{
    self.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
    self.picItemWidth = ZXAddPicItemWidth;
    self.picItemHeight = ZXAddPicItemHeight;
    self.picItemSize = CGSizeMake(ZXAddPicItemWidth, ZXAddPicItemHeight);
    self.minimumInteritemSpacing = ZXMinimumInteritemSpacing;
    self.minimumLineSpacing = ZXMinimumLineSpacing;
    self.existInputItem = YES;//添加图片按钮默认存在
    self.maxItemCount = ZXMaxItemCount;
    self.photosState = ZXPhotosViewStateWillCompose;
    self.columnsCount = 4;
    self.addButtonPlaceholderImage = [UIImage imageNamed:ZXAddPhotoImageName];
    
    [self addSubview:self.collectionView];
    self.clipsToBounds = YES;
    self.showAddPicCoverView = YES;
    self.canMoveItem = NO;
//    collectionView没有编辑模式
    self.showDeleteIconButton = YES;

}

#pragma mark - 初始化数据

- (NSMutableArray *)dataMArray
{
    if (!_dataMArray)
    {
        _dataMArray = [NSMutableArray array];
    }
    return _dataMArray;
}

- (NSMutableArray *)cellAttributesMArray
{
    if (!_cellAttributesMArray)
    {
        _cellAttributesMArray = [NSMutableArray array];
    }
    return _cellAttributesMArray;
}


#pragma mark - UI

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
        
        [collection registerNib:[UINib nibWithNibName:nib_ZXAddPicViewCell bundle:nil] forCellWithReuseIdentifier:reuseCell];
        [collection registerClass:[ZXAddPicPlaceholderCell class] forCellWithReuseIdentifier:reusePlaceholderCell];
        collection.scrollEnabled = NO;
        
        _collectionView = collection;
    }
    return _collectionView;
}

- (ZXAddPicCoverView *)addPicCoverView
{
    if (!_addPicCoverView)
    {
        ZXAddPicCoverView *coverView = [ZXAddPicCoverView viewFromNib];
        [coverView.addButton addTarget:self action:@selector(coverAddBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _addPicCoverView = coverView;
    }
    return _addPicCoverView;
}

- (UIGestureRecognizer *)longPressGesture
{
    if (!_longPressGesture)
    {
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longPressGesture.delegate = self;
        _longPressGesture = longPressGesture;
    }
    return  _longPressGesture;
}


#pragma mark - setter方法

- (void)setShowAddPicCoverView:(BOOL)showAddPicCoverView
{
    if (showAddPicCoverView != _showAddPicCoverView)
    {
        _showAddPicCoverView = showAddPicCoverView;
        
        // 12.05 新增提示view；
        if (!showAddPicCoverView && [self.addPicCoverView isDescendantOfView:self])
        {
//            没有经过测试；删除的同时并行执行alpha =0；
            [UIView performSystemAnimation:UISystemAnimationDelete onViews:@[self.addPicCoverView] options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.addPicCoverView.alpha =0;

            } completion:nil];
//            [self.addPicCoverView removeFromSuperview];
        }
        else if(showAddPicCoverView && ![self.addPicCoverView isDescendantOfView:self])
        {
            
            [self addSubview:self.addPicCoverView];
        }
    }
}



- (void)setCanMoveItem:(BOOL)canMoveItem
{
    if (canMoveItem == _canMoveItem)
    {
        return;
    }
    _canMoveItem = canMoveItem;
    
    if ([Device_SYSTEMVERSION floatValue]>=SYSTEMVERSION)
    {
        if (_canMoveItem)
        {
            if (![self.collectionView.gestureRecognizers containsObject:self.longPressGesture])
            {
                [self.collectionView addGestureRecognizer:self.longPressGesture];
            }
        }
        else
        {
            if ([self.collectionView.gestureRecognizers containsObject:self.longPressGesture])
            {
                [self.collectionView removeGestureRecognizer:self.longPressGesture];
            }
        }
    }
}


- (void)setAddButtonPlaceholderImage:(UIImage *)addButtonPlaceholderImage
{
    if (addButtonPlaceholderImage != _addButtonPlaceholderImage)
    {
        _addButtonPlaceholderImage = addButtonPlaceholderImage;
        if (self.addPicCoverView)
        {
            [self.addPicCoverView.addButton setImage:addButtonPlaceholderImage forState:UIControlStateNormal];
        }
    }
}


// 重写行间距，item宽度，item之间间距；

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{
    if (minimumInteritemSpacing != _minimumInteritemSpacing)
    {
        CGFloat itemSpace = minimumInteritemSpacing-ZXPicItemLayoutRight;
        itemSpace = itemSpace>0?itemSpace:0;
        _minimumInteritemSpacing = itemSpace;
    }
}

- (void)setColumnsCount:(NSInteger)columnsCount
{
    if (columnsCount != _columnsCount)
    {
        _columnsCount = columnsCount;
    }
}

//- (void)setPicItemSize:(CGSize)picItemSize
//{
//    _picItemSize = CGSizeMake(picItemSize.width+ZXPicItemLayoutRight, picItemSize.height+ZXPicItemLayoutTop);
//}

//- (void)setPicItemWidth:(CGFloat)aPicItemWidth
//{
//    _picItemWidth = aPicItemWidth +ZXPicItemLayoutRight;
//}
//
//- (void)setPicItemHeight:(CGFloat)aPicItemHeight
//{
//    _picItemHeight = aPicItemHeight +ZXPicItemLayoutTop;
//}


- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing
{
    if (minimumLineSpacing != _minimumLineSpacing)
    {
        CGFloat space = minimumLineSpacing-ZXPicItemLayoutTop;
        space = space>0?space:0;
        _minimumLineSpacing = space;
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(sectionInset, _sectionInset))
    {
        CGFloat right = sectionInset.right-ZXPicItemLayoutRight>0?sectionInset.right-ZXPicItemLayoutRight:0;
        _sectionInset = UIEdgeInsetsMake(sectionInset.top, sectionInset.left, sectionInset.bottom, right);
        self.collectionFlowLayout.sectionInset = _sectionInset;
    }
}


#pragma mark - get方法



- (BOOL)isExistInputItem
{
    return _existInputItem;
}

- (BOOL)isContainVideoAsset
{
    return _containVideoAsset;
    //    return [self containsVideoObject:self.dataMArray];
}


- (BOOL)isChangeDeleteContentHeight
{
    return ((self.beforeDeleteContentHight == self.afterDeleteContentHight)?NO:YES);
}

// 获取data数据中是否包含视频资源
- (BOOL)containsVideoObject:(NSArray *)data
{
    if (data.count ==0)
    {
        return NO;
    }
    __block BOOL containVideo = NO;
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ZXPhoto class]])
        {
            ZXPhoto *photo = (ZXPhoto *)obj;
            if (photo.type ==ZXAssetModelMediaTypeVideo)
            {
                containVideo = YES;
            }
        }
    }];
    return containVideo;
}


- (CGFloat)getItemAverageWidthInTotalWidth:(CGFloat)totalWidth columnsCount:(NSUInteger)columnsCount sectionInset:(UIEdgeInsets)inset minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{
    minimumInteritemSpacing = minimumInteritemSpacing>0?minimumInteritemSpacing:0;
    CGFloat itemWidth =  ((totalWidth - (columnsCount-1)*minimumInteritemSpacing-inset.left-inset.right)/columnsCount)-ZXPicItemLayoutRight;
    return floorf(itemWidth);
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = [self getNumberOfItemsInSection:self.dataMArray];
    return count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"indexPath=%ld",indexPath.item);
    //添加图片按钮Cell 重用；
    if (self.isExistInputItem && indexPath.item == self.dataMArray.count && _dataMArray.count <self.maxItemCount)
    {
        ZXAddPicPlaceholderCell *placeholderCell = (ZXAddPicPlaceholderCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reusePlaceholderCell forIndexPath:indexPath];
        if (self.addButtonPlaceholderImage)
        {
            placeholderCell.imageView.image =self.addButtonPlaceholderImage;
        }
        self.placeholderCell = placeholderCell;
        return placeholderCell;
    }
    //因为cell右上角放删除按钮，所以左右上下各增加10个距离；
    ZXAddPicViewCell *cell = (ZXAddPicViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseCell forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];
    [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.hidden = !self.showDeleteIconButton;
    cell.delegate = self;
    cell.longPress.delegate = self;
    [cell makeGestureRecognizersWithCanMoveItem:self.canMoveItem];
//    [self addGestureRecognizerOnCell:cell];

    id obj = [_dataMArray objectAtIndex:indexPath.item];
    if ([obj isKindOfClass:[UIImage class]])
    {
        cell.imageView.image = (UIImage *)obj;
    }
    else if ([obj isKindOfClass:[ZXPhoto class]])
    {
        ZXPhoto *photo = (ZXPhoto *)obj;
        if (photo.type == ZXAssetModelMediaTypePhoto ||photo.type == ZXAssetModelMediaTypeCustom)
        {
            NSURL *url = [NSURL URLWithString:photo.thumbnail_pic];
            [cell.imageView sd_setImageWithURL:url placeholderImage:AppPlaceholderImage];
        }
        else if (photo.type == ZXAssetModelMediaTypeVideo)
        {
            NSURL *url = [NSURL URLWithString:photo.videoURLString];
            [self setImageView:cell.imageView withURL:url placeholderImage:AppPlaceholderImage];
        }
        [cell setData:photo indexPath:indexPath isContainVideo:self.isContainVideoAsset];

    }
    // Configure the cell
    return cell;
}

/*
// 改为cell中添加手势
// 每个cell添加手势
- (void)addGestureRecognizerOnCell:(ZXAddPicViewCell *)cell
{
    if ([Device_SYSTEMVERSION floatValue] <SYSTEMVERSION && self.canMoveItem)
    {
        NSArray *gestureRecognizers = cell.gestureRecognizers;
        __block BOOL isAddLongPressGesture = NO;
        if (gestureRecognizers.count >0)
        {
            [gestureRecognizers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[UILongPressGestureRecognizer class]])
                {
                    isAddLongPressGesture = YES;
                }
            }];
        }
        if (!isAddLongPressGesture)
        {
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
            longPressGesture.delegate = self;
            [cell addGestureRecognizer:longPressGesture];
        }
//        NSLog(@"%@",cell.gestureRecognizers);
    }
}
*/

//id<ZXAddPicCellLayoutConfigSource> layoutConfig = [[ZXAddPicViewKit sharedKit] cellLayoutConfig];
//NSString *identity = [layoutConfig cellContent:photo];
//ZXAddPicViewCell *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];


// 视频缩略图
- (void)setImageView:(UIImageView *)imageView withURL:(NSURL *)videoURL placeholderImage:(UIImage *)placeholderImage
{
    imageView.image = placeholderImage;
    UIImage *cacheImage = [[SDImageCache sharedImageCache]imageFromCacheForKey:videoURL.absoluteString];
    if (cacheImage)
    {
        [imageView setImage:cacheImage];
    }
    else
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(queue, ^{
            
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
            AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            gen.appliesPreferredTrackTransform = YES;
            CMTime time = CMTimeMakeWithSeconds(0.0, 60);
            NSError *error = nil;
            CMTime actualTime;
            CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
            UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];
            
            [[SDImageCache sharedImageCache] storeImage:thumbImg forKey:videoURL.absoluteString completion:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [imageView setImage:thumbImg];
            });
        });
    }
    //获取视频时间
//    CMTime time2 = [asset duration];
//    int seconds = ceil(time2.value/time2.timescale);
//    NSLog(@"%d",seconds);
}

// 当开始移动，调用[self.collectionView beginInteractiveMovementForItemAtIndexPath:beganSelectIndexPath];方法时候，会先回调这个代理，等回调后，再处理内部程序；
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0)
{
    if (indexPath.item ==self.dataMArray.count &&self.isExistInputItem &&self.dataMArray.count <self.maxItemCount)
    {
        return NO;
    }
    return self.canMoveItem;
}

// 当结束移动,调用[self.collectionView endInteractiveMovement]方法时候，移动到一个目标有效的indexPath，会主线程回调这个代理，等回调后，再处理内部程序；如果没有改变sourceIndexPath，或目标indexPath =nil，则不会回调；
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath NS_AVAILABLE_IOS(9_0)
{
    if (destinationIndexPath.item ==self.dataMArray.count &&self.isExistInputItem &&self.dataMArray.count <self.maxItemCount)
    {
        return ;
    }
    NSUInteger fromItem = sourceIndexPath.item;
    NSUInteger toItem = destinationIndexPath.item;
    id object = [self.dataMArray objectAtIndex:fromItem];
    [self.dataMArray removeObjectAtIndex:fromItem];
    [self.dataMArray insertObject:object atIndex:toItem];
    
    self.destinationIndexPath = destinationIndexPath;
}

#pragma mark - UICollectionViewDelegateFlowLayout

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
    return self.minimumInteritemSpacing-ZXPicItemLayoutRight;
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
    return CGSizeMake(_picItemWidth+ZXPicItemLayoutRight, _picItemHeight+ZXPicItemLayoutTop);
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //“添加图片”按钮事件
    if (indexPath.item ==self.dataMArray.count &&self.isExistInputItem &&_dataMArray.count <self.maxItemCount)
    {
        [self addPicCollectionView:self commitEditingStyle:ZXAddPicCellEditingStyleInsert forRowAtIndexPath:indexPath];
    }
    //其它图片item点击事件
    else
    {
        if ([self.delegate respondsToSelector:@selector(zx_addPicCollectionView:didSelectPicItemAtIndex:didAddPics:)])
        {
            [self.delegate zx_addPicCollectionView:self didSelectPicItemAtIndex:indexPath.item didAddPics:_dataMArray];
        }
    }
}


#pragma mark - 过滤点击cell空白区域事件

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event
{
    return YES;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
//    NSLog(@"point =%@",NSStringFromCGPoint(point));
    NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:point];
    if (selectIndexPath)
    {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:selectIndexPath];
        CGPoint cellPoint = [self.collectionView convertPoint:point toView:cell];
        if ([cell isKindOfClass:[ZXAddPicViewCell class]])
        {
            ZXAddPicViewCell *zxCell = (ZXAddPicViewCell *)cell;
            BOOL flag1 = CGRectContainsPoint(zxCell.imageView.frame,cellPoint);
            BOOL flag2 = CGRectContainsPoint(zxCell.deleteBtn.frame, cellPoint);
            if (!flag1 && !flag2)
            {
                return self.collectionView;
            }
        }
        else if ([cell isKindOfClass:[ZXAddPicPlaceholderCell class]])
        {
            ZXAddPicPlaceholderCell *zxCell = (ZXAddPicPlaceholderCell *)cell;
            BOOL flag1 = CGRectContainsPoint(zxCell.imageView.frame,cellPoint);
            if (!flag1)
            {
                return self.collectionView;
            }
        }
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - 编辑模式:长按事件  iOS9以下 和 iOS9以上
- (void)zxLongPressAction:(UILongPressGestureRecognizer *)longPress
{
    [self longPressAction:longPress];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    if ([Device_SYSTEMVERSION floatValue] >=SYSTEMVERSION)
    {
        [self longPressActionIOS9:longPress];
    }
    else
    {
        [self longPressActionBeforeIOS9:longPress];
    }
}

// 因为placeholderCell 没有长按事件添加，所以不用考虑
- (void)longPressActionBeforeIOS9:(UILongPressGestureRecognizer *)longPress
{
    ZXAddPicViewCell *cell = (ZXAddPicViewCell *) longPress.view;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    _isChangeMoveItem = NO;
    [self.collectionView bringSubviewToFront:cell];

    switch (longPress.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            if (![self zx_shouldBegainLongPress:indexPath])
            {
//                把无效的开始 设为nil，后面手势的程序可以过滤不执行
                _shouldBegainLongPress = NO;
                return;
            }
            _shouldBegainLongPress = YES;;
            _sourceIndexPath = indexPath;
            _destinationIndexPath = indexPath;
            
            [self.cellAttributesMArray removeAllObjects];
            for (int i=0;i<self.dataMArray.count; i++)
            {
                UICollectionViewLayoutAttributes *layoutAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                [self.cellAttributesMArray addObject:layoutAttributes];
            }
            UICollectionViewLayoutAttributes * attributes = [self.cellAttributesMArray objectAtIndex:indexPath.item];
            CGPoint pressPoint = [longPress locationInView:self.collectionView];
            if (CGRectContainsPoint(attributes.frame, pressPoint) && indexPath == attributes.indexPath)
            {
                CGPoint pressCellCenterOffest = CGPointMake(attributes.center.x-pressPoint.x, attributes.center.y-pressPoint.y);
                self.pressCellCenterOffest = pressCellCenterOffest;
            }
            [self zx_begainLongPressDoAction:_sourceIndexPath];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
//           拆分2步判断
            // (1)自己就是特殊item，也可以设置cancle；
            if (!self.shouldBegainLongPress)
            {
                break;
            }
            CGPoint pressPoint = [longPress locationInView:self.collectionView];
            cell.center = CGPointMake(pressPoint.x+self.pressCellCenterOffest.x, pressPoint.y+self.pressCellCenterOffest.y);
//            NSLog(@"%@",NSStringFromCGPoint(pressPoint));
            [self.cellAttributesMArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *  _Nonnull attributes, NSUInteger idx, BOOL * _Nonnull stop) {
        
                
//                在移动过程中，很多时候是不包含的； 如果移动到无效indexPath区域，则当目标indexPath = 原始indexPath
                if (CGRectContainsPoint(attributes.frame, cell.center) && indexPath != attributes.indexPath)
                {
//                  (2)began有效的item，移动到无效indexPath的item，需要cancle；不允许移动交换数据
                    if (![self zx_shouldCanMoveToIndexPath:attributes.indexPath])
                    {
                        *stop = YES;
                    }
                    else
                    {
                        self.isChangeMoveItem = YES;
                        self.destinationIndexPath = attributes.indexPath;
                        id object = [self.dataMArray objectAtIndex:indexPath.item];
                        [self.dataMArray removeObjectAtIndex:indexPath.item];
                        [self.dataMArray insertObject:object atIndex:attributes.indexPath.item];
                        
                        cell.transform = CGAffineTransformIdentity;
                        [self.collectionView  moveItemAtIndexPath:indexPath toIndexPath:attributes.indexPath];
                        cell.transform = CGAffineTransformMakeScale(1.2, 1.2);
                        cell.center = CGPointMake(pressPoint.x+self.pressCellCenterOffest.x, pressPoint.y+self.pressCellCenterOffest.y);
                        [cell.layer removeAllAnimations];
                    }
                }
            }];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
//            如果手势是无效的
            if (!self.shouldBegainLongPress)
            {
                break;
            }
            if (!self.isChangeMoveItem)
            {
                cell.center = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath].center;
            }
            [self zx_endLongPressDoAction:self.destinationIndexPath];
            break;
        }
        default:
            break;
    }
}

- (void)longPressActionIOS9:(UILongPressGestureRecognizer *)longPress
{
    
    CGPoint point = [longPress locationInView:self.collectionView];

    switch (longPress.state)
    {
        case UIGestureRecognizerStateBegan:
        {
//            开始可能是无效的
            NSIndexPath *beganSelectIndexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (![self zx_shouldBegainLongPress:beganSelectIndexPath])
            {
                _shouldBegainLongPress = NO;
                return;
            }
            BOOL flag = [self.collectionView beginInteractiveMovementForItemAtIndexPath:beganSelectIndexPath];
            if (flag)
            {
                [self zx_begainLongPressDoAction:beganSelectIndexPath];
            }
            _shouldBegainLongPress = YES;;
            _sourceIndexPath = beganSelectIndexPath;
            _destinationIndexPath = beganSelectIndexPath;

//            NSLog(@"begain长按");
            break;}
        case UIGestureRecognizerStateChanged:
        {
            if (_shouldBegainLongPress)
            {
                NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
                // began有效的item，移动到无效indexPath的item，或 indexPath ==null时候，不能cancle，因为item之间间隔也是null，会造成移动不了的结果； 自己就是特殊item，也可以设置cancle；
//                不要cancelInteractiveMovement，不然遇到2处对角item都无效的时候，无法移动直角处item；
                if (![self zx_shouldCanMoveToIndexPath:indexPath])
                {
                    break;
                }
//indexPath ==null时候，不能更新位置；
                if (indexPath)
                {
                    [self.collectionView updateInteractiveMovementTargetPosition:point];
                }
                NSLog(@"%@",indexPath);
            }
//            NSLog(@"changed变化中的长按");
            break;}
        case UIGestureRecognizerStateEnded:
        {
//          调用endInteractiveMovement时，会重新主线程回调cell数据元代理方法,还会reload当前结束点的IndexPath； 如果移动到indexPath =nil，无效位置，或移动位置回到原始位置，结束indexPath = 原始indexPath，不会回调代理方法； 如果移动到不能移动的位置,但发生改变了，目标indexPath需要去代理方法获取；不能用[self.collectionView indexPathForItemAtPoint:point]获取；
            if (_shouldBegainLongPress)
            {
                NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
//                当没有移动有效item的时候； 这里会执行嘛？
                if (indexPath && indexPath != self.sourceIndexPath)
                {
                    [self.collectionView endInteractiveMovement];
                }
//                如果移动到indexPath =nil，无效位置，或移动位置回到原始位置，结束indexPath = 原始indexPath，不会回调代理方法；
                else if (!indexPath)
                {
                    [self.collectionView endInteractiveMovement];
                    self.destinationIndexPath = self.sourceIndexPath;
                }
                else
                {
                    [self.collectionView endInteractiveMovement];
                    self.destinationIndexPath = indexPath;
                }
                [self zx_endLongPressDoAction:self.destinationIndexPath];

            }
//            NSLog(@"ended的长按");
            break;}
        default: [self.collectionView cancelInteractiveMovement];
            break;
    }
}

- (BOOL)zx_shouldBegainLongPress:(NSIndexPath *)indexPath
{
//    在不是item区域长按
    if (!indexPath)
    {
        return NO;
    }
    //            添加item按钮 不执行事件；
    else if (indexPath.item ==self.dataMArray.count &&self.isExistInputItem &&self.dataMArray.count <self.maxItemCount)
    {
        return NO;
    }
    //          代理回调
    else if ([self.delegate respondsToSelector:@selector(zx_addPicCollectionView:shouldLongPressGestureStateBeganCanMoveItemAtIndexPath:)])
    {
        //                长按事件回调；可以处理哪个indexPath的item；
        BOOL should = [self.delegate zx_addPicCollectionView:self shouldLongPressGestureStateBeganCanMoveItemAtIndexPath:indexPath];
        if (!should)
        {
            return NO;
        }
    }
    return YES;
}

// 可以优化长按开始时，增加动画
- (void)zx_begainLongPressDoAction:(NSIndexPath *)beganSelectIndexPath
{
    ZXAddPicViewCell  *beganSelectCell = (ZXAddPicViewCell *)[self.collectionView cellForItemAtIndexPath:beganSelectIndexPath];
    _beganSelectCell = beganSelectCell;
    _beganSelectCell.contentView.alpha =0.8;

    [self zx_showDeleteIconButton:NO];

    CGAffineTransform transformA = CGAffineTransformMakeScale(1.2, 1.2);

    [UIView animateWithDuration:0.2 animations:^{
        self.beganSelectCell.transform = transformA;
    }];
}

// 长按事件处理时候，不能用刷新列表的方法处理UI更新；
- (void)zx_showDeleteIconButton:(BOOL)flag
{
    if (self.showDeleteIconButton != flag)
    {
        self.showDeleteIconButton = flag;
        [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[ZXAddPicViewCell class]])
            {
                ZXAddPicViewCell *cell  = (ZXAddPicViewCell *)obj;
                cell.deleteBtn.hidden = !flag;
                [UIView animateWithDuration:0.3 animations:^{
                    cell.deleteBtn.alpha = [[NSNumber numberWithBool:flag] floatValue];
                }];
            }
        }];
    }
 
}




- (BOOL)zx_shouldCanMoveToIndexPath:(NSIndexPath *)indexPath
{
    //  NO：允许移动到无效indexPath，但不能交换数据，最后反弹回有效indexPath；
    
    if (!indexPath)
    {
        return NO;
    }
    if (indexPath.item ==self.dataMArray.count &&self.isExistInputItem &&self.dataMArray.count <self.maxItemCount)
    {
        return NO;
    }
    else if ([self.delegate respondsToSelector:@selector(zx_addPicCollectionView:itemAtIndexPath:canMoveToIndexPath:)])
    {
        //   长按事件回调；可以处理哪个indexPath的item；
        
        BOOL should = [self.delegate zx_addPicCollectionView:self itemAtIndexPath:_sourceIndexPath canMoveToIndexPath:indexPath];
        if (!should)
        {
            return NO;
        }
    }
    return YES;
}




// 如果移动到原来位置，endIndexPath = sourceIndexPath;无效位置，则=nil;
//
- (void)zx_endLongPressDoAction:(nullable NSIndexPath *)endIndexPath
{
    if (_beganSelectCell)
    {
        _beganSelectCell.contentView.alpha = 1.0;

        [UIView animateWithDuration:0.2 animations:^{
            self.beganSelectCell.transform = CGAffineTransformIdentity;
        }];
    }
    if (!self.showDeleteIconButton)
    {
        [self zx_showDeleteIconButton:YES];
    }
//  处理长按事件结束回调,处理一些UI变化
    if ([self.delegate respondsToSelector:@selector(zx_addPicCollectionView:longPressGestureStateEndAtIndexPath: toIndexPath:)])
    {
        [self.delegate zx_addPicCollectionView:self longPressGestureStateEndAtIndexPath:self.sourceIndexPath toIndexPath:endIndexPath];
    }
//    处理移动到一个新的有效的item之后的回调
    if (endIndexPath  && self.sourceIndexPath && (endIndexPath != _sourceIndexPath))
    {
        //        目标是placeholder按钮；
        if (endIndexPath.item ==self.dataMArray.count &&self.isExistInputItem &&self.dataMArray.count <self.maxItemCount)
        {
            return ;
        }
        //        开始是placeholder按钮；
        if (self.sourceIndexPath.item ==self.dataMArray.count &&self.isExistInputItem &&self.dataMArray.count <self.maxItemCount)
        {
            return ;
        }
        if ([self.delegate respondsToSelector:@selector(zx_addPicCollectionView:didEndMoveAtIndexPath:toIndexPath:)])
        {
            [self.delegate zx_addPicCollectionView:self didEndMoveAtIndexPath:_sourceIndexPath toIndexPath:endIndexPath];
        }
    }
}


#pragma mark -gestureRecognizerDelegate 过滤长按事件触发点
// 过滤长按手势不是点击在imageView上，不应该触发； delete按钮与 imageView有重叠区域，得看产品交互决定；
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *view = gestureRecognizer.view;
    if ([view isKindOfClass:[UICollectionViewCell class]])
    {
        ZXAddPicViewCell *cell = (ZXAddPicViewCell *)view;
        CGPoint point = [gestureRecognizer locationInView:view];
        BOOL flag = CGRectContainsPoint(cell.imageView.frame, point);
        return flag;
//        如果是点击在cell上，长按事件是可以失效了，但是cell的点击事件却能马上响应了；
//        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
//
//        if (!flag || ![self zx_shouldBegainLongPress:indexPath])
//        {
//            return NO;
//        }
    }
    return YES;
}

#pragma mark - 添加，删除item 编辑事件

- (void)coverAddBtnAction:(UIButton *)sender
{
     [self addPicCollectionView:self commitEditingStyle:ZXAddPicCellEditingStyleInsert forRowAtIndexPath:nil];
}

// 删除
- (void)deleteAction:(UIButton *)sender
{
    CGPoint point = sender.center;
    point = [self.collectionView convertPoint:point fromView:sender.superview];
    NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    [self addPicCollectionView:self commitEditingStyle:ZXAddPicCellEditingStyleDelete forRowAtIndexPath:indexPath];
}



- (void)addPicCollectionView:(ZXAddPicCollectionView *)collectionView commitEditingStyle:(ZXAddPicCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==ZXAddPicCellEditingStyleDelete)
    {
        // 当需要动态“添加图片”按钮但已经到最大个数，按钮已经隐藏； 第9个直接替换为placeholder，不应该增加删除item操作；
        if (_dataMArray.count == self.maxItemCount && self.isExistInputItem)
        {
            [self.dataMArray removeObjectAtIndex:indexPath.item];
            [self.collectionView reloadData];
        }
        // 不需要动态“添加图片”按钮，或有动态“添加图片”按钮且当前显示，点击删除按钮
        else
        {
            self.beforeDeleteContentHight = [self getCurrentContentHeight];
            [self.dataMArray removeObjectAtIndex:indexPath.item];
            // 有删除动画，但当你调用reload方法后，删除动画会消失； 可以优化为判断collectionView高度变化了，才让父视图tableView刷新列表高度，就能保持一部分删除动画效果了；
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            self.afterDeleteContentHight = [self getCurrentContentHeight];
            // 12.05转换提示view最上层显示
            if ([self.addPicCoverView isDescendantOfView:self] && self.dataMArray.count ==0)
            {
                [UIView transitionFromView:self.collectionView toView:self.addPicCoverView duration:0.3 options:UIViewAnimationOptionShowHideTransitionViews|UIViewAnimationOptionTransitionCrossDissolve completion:nil];
            }
        }
        self.containVideoAsset = [self containsVideoObject:self.dataMArray];
        
    }
    if ([self.delegate respondsToSelector:@selector(zx_addPicCollectionView:commitEditingStyle:forRowAtIndexPath:)])
    {

        [self.delegate zx_addPicCollectionView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
    
}

- (CGFloat)getCurrentContentHeight
{
    NSInteger totalItem = [self.collectionView numberOfItemsInSection:0];
    NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:totalItem-1 inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath];
    CGFloat height = CGRectGetMaxY(attributes.frame)+self.collectionFlowLayout.sectionInset.bottom+ZXPicItemLayoutTop;
    return height;
}

#pragma mark - 计算collectionView的总高度

- (CGFloat)getCellHeightWithContentData:(NSArray *)data
{
    
    if (!self.existInputItem && [data count]==0)
    {
        return 0.f;
    }
    else if (self.existInputItem && (!data || [data count]==0))
    {
        CGFloat height = self.collectionFlowLayout.sectionInset.top+self.collectionFlowLayout.sectionInset.bottom+(self.picItemHeight+ZXPicItemLayoutTop);
        return height;
    }
    else
    {        
        NSInteger count = [self getNumberOfItemsInSection:data];
        NSInteger rows = [self getRowsWithDataCount:count];
        //计算高度
        CGFloat height = rows * (self.picItemHeight+ZXPicItemLayoutTop) + (rows - 1) * self.minimumLineSpacing +self.sectionInset.top+self.sectionInset.bottom;
        return ceilf(height);
    }
}
#pragma mark - 计算方法
// 获取总
- (NSInteger)getNumberOfItemsInSection:(NSArray *)data
{
    NSInteger count = 0;
    if (self.isExistInputItem)
    {
        count = data.count<self.maxItemCount?data.count+1:self.maxItemCount;
    }
    else
    {
        count = data.count<self.maxItemCount?data.count:self.maxItemCount;
    }
    return count;
}

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
    return  rows;
}

# pragma mark - 实例方法
//如果tableView用reloadRows/reloadSections方法，则必须每次重新调用此方法，因为会新创建一个cell2+cell2数据作为复用；
//尽量使用reloadData刷新列表高度数据；
- (void)setData:(NSArray *)data
{
//    如果是相同数据，集合视图不会刷新数据元代理；例如上面已经删除数据元，然后重新把外部删除后，一样的数据元数组再传过来；
    if ([self.dataMArray isEqualToArray:data])
    {
        return;
    }
    [self.dataMArray removeAllObjects];
    if ([data count] > self.maxItemCount)
    {
        NSRange range = NSMakeRange(0, self.maxItemCount);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        data = [NSMutableArray arrayWithArray:[data objectsAtIndexes:set]];
    };
    
    [self.dataMArray addObjectsFromArray:data];
    //12.05 新增提示view；转换view的最上层显示；
    if ([self.addPicCoverView isDescendantOfView:self] && self.dataMArray.count>0)
    {
        [UIView transitionFromView:self.addPicCoverView toView:self.collectionView duration:0.2 options:UIViewAnimationOptionShowHideTransitionViews|UIViewAnimationOptionTransitionCrossDissolve completion:nil];
    }
    [self.collectionView reloadData];
    self.containVideoAsset = [self containsVideoObject:data];
}

// 动态更新占位符cell的image
- (void)updatePlaceholderButtonImage:(UIImage *)placeholderImage
{
    self.addButtonPlaceholderImage = placeholderImage;
    if (self.placeholderCell)
    {
        self.placeholderCell.imageView.image = self.addButtonPlaceholderImage;
    }
}



- (ZXAssetModelMediaType)getAssetType:(PHAsset *)asset
{
    ZXAssetModelMediaType type = ZXAssetModelMediaTypePhoto;
    if (asset.mediaType == PHAssetMediaTypeVideo)
    {
        type = ZXAssetModelMediaTypeVideo;
    }
    else if (asset.mediaType == PHAssetMediaTypeAudio)
    {
        type = ZXAssetModelMediaTypeAudio;
    }
    else if (asset.mediaType == PHAssetMediaTypeImage)
    {
        if ([[asset valueForKey:@"filename"]hasSuffix:@"GIF"])
        {
            type = ZXAssetModelMediaTypePhotoGif;
        }
        else
        {
             type = ZXAssetModelMediaTypePhoto;
        }
    }
    return type;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

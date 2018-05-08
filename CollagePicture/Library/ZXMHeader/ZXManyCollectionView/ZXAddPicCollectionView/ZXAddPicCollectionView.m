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




static NSInteger const ZXMaxItemCount = 3;

static CGFloat const ZXMinimumInteritemSpacing = 12.f;//item之间最小间隔
static CGFloat const ZXMinimumLineSpacing = 12.f; //最小行间距
static CGFloat const ZXAddPicItemWidth = 60.f;
static CGFloat const ZXAddPicItemHeight = 60.f;

NSInteger const ZXAddPicMaxColoum = 3;  // 图片每行默认最多个数
//设置的时候，xib也要同时调整；与删除按钮有关；
static CGFloat const ZXPicItemLayoutTop =  10.f;
static CGFloat const ZXPicItemLayoutRight = 10.f;

static NSString * const reuseCell = @"Cell";
static NSString * const reusePlaceholderCell = @"placeholderCell";


@interface ZXAddPicCollectionView ()<ZXAddPicViewCellDelegate>


@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;


@end


@implementation ZXAddPicCollectionView

@synthesize picItemHeight = _picItemHeight;


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
    
    self.showAddPicCoverView = YES;
}

- (BOOL)isExistInputItem
{
    return _existInputItem;
}

- (NSMutableArray *)dataMArray
{
    if (!_dataMArray)
    {
        _dataMArray = [NSMutableArray array];
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
        
        [collection registerNib:[UINib nibWithNibName:nib_ZXAddPicViewCell bundle:nil] forCellWithReuseIdentifier:reuseCell];
        [collection registerClass:[ZXAddPicPlaceholderCell class] forCellWithReuseIdentifier:reusePlaceholderCell];
        collection.scrollEnabled = NO;
        
        _collectionView = collection;
    }
    return _collectionView;
}


- (void)setShowAddPicCoverView:(BOOL)showAddPicCoverView
{
    _showAddPicCoverView = showAddPicCoverView;
    // 12.05 新增提示view；
    if (!showAddPicCoverView && [self.addPicCoverView isDescendantOfView:self])
    {
        [self.addPicCoverView removeFromSuperview];
    }
    else if(showAddPicCoverView && ![self.addPicCoverView isDescendantOfView:self])
    {
        
        [self addSubview:self.addPicCoverView];
    }
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

- (void)setAddButtonPlaceholderImage:(UIImage *)addButtonPlaceholderImage
{
    _addButtonPlaceholderImage = addButtonPlaceholderImage;
    [self.addPicCoverView.addButton setImage:addButtonPlaceholderImage forState:UIControlStateNormal];
}


// 重写行间距，item宽度，item之间间距；

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{
    CGFloat itemSpace = minimumInteritemSpacing-ZXPicItemLayoutRight;
    itemSpace = itemSpace>0?itemSpace:0;
    _minimumInteritemSpacing = itemSpace;
}

- (void)setColumnsCount:(NSInteger)columnsCount
{
    _columnsCount = columnsCount;
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
    CGFloat space = minimumLineSpacing-ZXPicItemLayoutTop;
    space = space>0?space:0;
    _minimumLineSpacing = space;
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    CGFloat right = sectionInset.right-ZXPicItemLayoutRight>0?sectionInset.right-ZXPicItemLayoutRight:0;
    _sectionInset = UIEdgeInsetsMake(sectionInset.top, sectionInset.left, sectionInset.bottom, right);
    self.collectionFlowLayout.sectionInset = _sectionInset;
}

- (CGFloat)getItemAverageWidthInTotalWidth:(CGFloat)totalWidth columnsCount:(NSUInteger)columnsCount sectionInset:(UIEdgeInsets)inset minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{
    minimumInteritemSpacing = minimumInteritemSpacing>0?minimumInteritemSpacing:0;
    CGFloat itemWidth =  (totalWidth - (columnsCount-1)*minimumInteritemSpacing-inset.left-inset.right)/columnsCount-ZXPicItemLayoutRight;
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
    //因为cell右上角放删除按钮，所以左右上下各增加10个距离；
    ZXAddPicViewCell *cell = (ZXAddPicViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseCell forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];
    [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
//    NSLog(@"indexPath=%ld",indexPath.item);
    //添加图片按钮Cell 重用；
    if (self.isExistInputItem && indexPath.item==self.dataMArray.count&&_dataMArray.count <self.maxItemCount)
    {
        ZXAddPicPlaceholderCell *placeholderCell = (ZXAddPicPlaceholderCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reusePlaceholderCell forIndexPath:indexPath];
        if (self.addButtonPlaceholderImage)
        {
            placeholderCell.imageView.image =self.addButtonPlaceholderImage;
        }
        return placeholderCell;
    }
    else
    {
        cell.deleteBtn.hidden = NO;

        id obj = [_dataMArray objectAtIndex:indexPath.item];
        if ([obj isKindOfClass:[UIImage class]])
        {
            cell.imageView.image = (UIImage *)obj;
        }
        else if ([obj isKindOfClass:[ZXPhoto class]])
        {

            ZXPhoto *photo = (ZXPhoto *)obj;
            [cell setData:photo];

            if (photo.type == ZXAssetModelMediaTypePhoto)
            {
                NSURL *url = [NSURL URLWithString:photo.thumbnail_pic];
                [cell.imageView sd_setImageWithURL:url placeholderImage:AppPlaceholderImage];
            }
            if (photo.type == ZXAssetModelMediaTypeCustom)
            {
                NSURL *url = [NSURL URLWithString:photo.thumbnail_pic];
                [cell.imageView sd_setImageWithURL:url placeholderImage:AppPlaceholderImage];
            }
            else if (photo.type == ZXAssetModelMediaTypeVideo)
            {
                NSURL *url = [NSURL URLWithString:photo.videoURLString];
                [self setImageView:cell.imageView withURL:url placeholderImage:AppPlaceholderImage];
            }
        }
    }
    // Configure the cell
    return cell;
}

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
        // 当需要动态“添加图片”按钮但而且已经到最大个数，按钮已经隐藏，；
        if (_dataMArray.count == self.maxItemCount && self.isExistInputItem)
        {
            [self.dataMArray removeObjectAtIndex:indexPath.item];
            [self.collectionView reloadData];
        }
        // 不需要动态“添加图片”按钮，或有动态“添加图片”按钮且当前显示，点击删除按钮
        else
        {
            [self.dataMArray removeObjectAtIndex:indexPath.item];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            
            // 12.05转换提示view最上层显示
            if ([self.addPicCoverView isDescendantOfView:self])
            {
                  self.addPicCoverView.hidden = self.dataMArray.count >0?YES:NO;
            }
     
        }
    }
    if ([self.delegate respondsToSelector:@selector(zx_addPicCollectionView:commitEditingStyle:forRowAtIndexPath:)])
    {
        [self.delegate zx_addPicCollectionView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
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
            return self.collectionFlowLayout.sectionInset.bottom+ self.collectionFlowLayout.sectionInset.top+_picItemHeight+2*ZXPicItemLayoutTop;
        }
        
        NSInteger count = [self getNumberOfItemsInSection:data];
        NSInteger rows = [self getRowsWithDataCount:count];
        //计算高度
        CGFloat height = rows * (_picItemHeight+ZXPicItemLayoutTop) + (rows - 1) * self.minimumLineSpacing +self.sectionInset.top+self.sectionInset.bottom;
        return ceilf(height);

//        [self setData:data];

//        //由于整个view被tableViewCell重用了，所以他只会记得init初始化的值；
//        NSInteger totalItem = [self.collectionView numberOfItemsInSection:0];
//        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:totalItem-1 inSection:0];
//        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath];
//        CGFloat height = CGRectGetMaxY(attributes.frame)+self.collectionFlowLayout.sectionInset.bottom+ZXPicItemLayoutTop;
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
    //12.05 新增提示view；转换view的最上层显示；
    if ([self.addPicCoverView isDescendantOfView:self])
    {
        self.addPicCoverView.hidden = self.dataMArray.count >0?YES:NO;
    }
    [self.collectionView reloadData];
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

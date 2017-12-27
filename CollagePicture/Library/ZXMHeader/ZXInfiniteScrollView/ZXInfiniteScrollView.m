//
//  ZXInfiniteScrollView.m
//  YiShangbao
//
//  Created by simon on 2017/8/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXInfiniteScrollView.h"
#import "ZXInfiniteCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface ZXInfiniteScrollView ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) NSArray *imagePathsGroup;
@property (nonatomic, assign) NSInteger totalItemsCount;

@end


static const NSTimeInterval kTimeInterval= 3.f;
static NSString *const kIdentifierCell = @"Cell";

@implementation ZXInfiniteScrollView

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
        [self initUI];
    }
    return self;
}



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
        [self initUI];
    }
    return self;
    
}

- (void)initUI
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.minimumLineSpacing = 0;
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout = flow;

    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.directionalLockEnabled = YES;
    [mainView registerClass:[ZXInfiniteCollectionCell class] forCellWithReuseIdentifier:kIdentifierCell];
    mainView.dataSource = self;
    mainView.delegate = self;
    [self addSubview:mainView];
    self.collectionView = mainView;

    [self setupPageControl];
 
}
- (void)setupPageControl
{
//    if (_pageControl) [_pageControl removeFromSuperview];
//    if (_imagePathsGroup.count <=1)
//    {
//        return;
//    }

    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.hidesForSinglePage = YES;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.defersCurrentPageDisplay = YES;
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.userInteractionEnabled = NO;
//    [pageControl addTarget:self action:@selector(pageEventMathod:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControl];
    
    self.pageControl = pageControl;
}
- (void)commonInit
{
    self.autoScroll = YES;
    self.autoScrollTimeInterval = kTimeInterval;
    self.infiniteLoop = YES;
}


#pragma mark - 属性设置

- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    
//    if (!self.backgroundImageView) {
//        UIImageView *bgImageView = [UIImageView new];
//        bgImageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self insertSubview:bgImageView belowSubview:self.mainView];
//        self.backgroundImageView = bgImageView;
//    }
//    
//    self.backgroundImageView.image = placeholderImage;
}


- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup
{
    _imageURLStringsGroup = imageURLStringsGroup;
    
    _totalItemsCount = self.infiniteLoop ? self.imagePathsGroup.count * 100 : self.imagePathsGroup.count;
    
    NSMutableArray *temp = [NSMutableArray new];
    [_imageURLStringsGroup enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        } else if ([obj isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.imagePathsGroup = [temp copy];
}


- (void)setItemModelArray:(NSMutableArray *)itemModelArray
{
    _itemModelArray = itemModelArray;
}

- (void)setImagePathsGroup:(NSArray *)imagePathsGroup
{
    if (self.timer)
    {
        [self.timer pauseTimer];
    }

    
    _imagePathsGroup = imagePathsGroup;
    
    _totalItemsCount = self.infiniteLoop ? self.imagePathsGroup.count * 100 : _imagePathsGroup.count;
    
    if (imagePathsGroup.count != 1)
    {
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    }
    else
    {
        self.collectionView.scrollEnabled = NO;
    }
    self.pageControl.currentPage = 0;
//  [self setupPageControl];
    [self.collectionView reloadData];
}

-(void)setAutoScroll:(BOOL)autoScroll{
    
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
}



#pragma mark - actions

- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}


- (void)automaticScroll
{
//    if (0 == _totalItemsCount){
//      
//        return;
//    }
//    int currentIndex = [self currentIndex];
//    int targetIndex = currentIndex + 1;
//    [self scrollToIndex:targetIndex];
}




#pragma mark - life circles

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.frame.size;
    
    _collectionView.frame = self.bounds;
//    if (_collectionView.contentOffset.x == 0 &&  _totalItemsCount) {
//        int targetIndex = 0;
//        if (self.infiniteLoop) {
//            targetIndex = _totalItemsCount * 0.5;
//        }else{
//            targetIndex = 0;
//        }
//        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//    }
    if (_collectionView.contentOffset.x ==0)
    {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
//    CGSize size = CGSizeZero;
//    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
//        TAPageControl *pageControl = (TAPageControl *)_pageControl;
//        if (!(self.pageDotImage && self.currentPageDotImage && CGSizeEqualToSize(kCycleScrollViewInitialPageControlDotSize, self.pageControlDotSize))) {
//            pageControl.dotSize = self.pageControlDotSize;
//        }
//        size = [pageControl sizeForNumberOfPages:self.imagePathsGroup.count];
//    } else {
//        size = CGSizeMake(self.imagePathsGroup.count * self.pageControlDotSize.width * 1.5, self.pageControlDotSize.height);
//    }
//    CGFloat x = (self.sd_width - size.width) * 0.5;
//    if (self.pageControlAliment == SDCycleScrollViewPageContolAlimentRight) {
//        x = self.mainView.sd_width - size.width - 10;
//    }
//    CGFloat y = self.mainView.sd_height - size.height - 10;
//    
//    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
//        TAPageControl *pageControl = (TAPageControl *)_pageControl;
//        [pageControl sizeToFit];
//    }
//    
//    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
//    pageControlFrame.origin.y -= self.pageControlBottomOffset;
//    pageControlFrame.origin.x -= self.pageControlRightOffset;
//    self.pageControl.frame = pageControlFrame;
//    self.pageControl.hidden = !_showPageControl;
//    
//    if (self.backgroundImageView) {
//        self.backgroundImageView.frame = self.bounds;
//    }
    
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.imagePathsGroup.count;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXInfiniteCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifierCell forIndexPath:indexPath];
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    
    NSString *imagePath = self.imagePathsGroup[itemIndex];
    
    if ([imagePath isKindOfClass:[NSString class]]) {
        if ([imagePath hasPrefix:@"http"]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
        } else {
            UIImage *image = [UIImage imageNamed:imagePath];
            if (!image) {
                [UIImage imageWithContentsOfFile:imagePath];
            }
            cell.imageView.image = image;
        }
    } else if ([imagePath isKindOfClass:[UIImage class]]) {
        cell.imageView.image = (UIImage *)imagePath;
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didSelectRowAtIndex:)])
    {
        NSInteger index = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
        [self.delegate infiniteScrollView:self didSelectRowAtIndex:index];
    }
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didSelectModel:)])
    {
//        [self.delegate infiniteScrollView:self didSelectModel:[self.itmesArray objectAtIndex:self.currentPageIndex]];
    }
}


@end

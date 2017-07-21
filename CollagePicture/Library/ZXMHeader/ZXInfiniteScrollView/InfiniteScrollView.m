//
//  InfiniteScrollView.m
//  baohuai_iPhone
//
//  Created by 朱新明 on 14/5/2.
//  Copyright (c) 2014年 朱新明. All rights reserved.
//

#import "InfiniteScrollView.h"
#import "NSTimer+Addition.h"

#import "UIImageView+WebCache.h"


static NSString *const kPlaceholderImage = @"bannerPlaceholder";



static const NSTimeInterval timeInterval= 3.f;

@interface InfiniteScrollView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIPageControl *pageControl;

@property(nonatomic,assign) NSInteger currentPageIndex;

@property(nonatomic,strong) NSMutableArray *viewArray;

/**
 * @brief model数组；
 */
@property(nonatomic, strong) NSMutableArray *itmesArray;

@end

@implementation InfiniteScrollView
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



- (id)initWithCoder:(NSCoder *)aDecoder
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
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;//no add scrollView's imageView
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    

    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.defersCurrentPageDisplay = YES;
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self.pageControl addTarget:self action:@selector(pageEventMathod:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
    
    self.viewArray = [NSMutableArray array];
    self.currentPageIndex = 0;
 
}

- (void)setItemsArray:(NSMutableArray *)array placeholderImage:(UIImage *)placeholderImage
{
    UIImage *placeholder = [UIImage imageNamed:kPlaceholderImage];
    
    if (placeholderImage)
    {
        placeholder = placeholderImage;
    }
    _itmesArray = array;

    if (_itmesArray.count ==0)
    {
        return;
    }
    while (self.viewArray.count < _itmesArray.count+2) {
        
        UIImageView *contentView = [[UIImageView alloc] init];
        
        
        [self.scrollView addSubview:contentView];
        
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [tapGesture requireGestureRecognizerToFail:self.scrollView.panGestureRecognizer];
        tapGesture.delegate =self;
        [contentView addGestureRecognizer:tapGesture];
        
        contentView.contentMode = UIViewContentModeScaleAspectFill;
        contentView.clipsToBounds = YES;
        
        [self.viewArray addObject:contentView];
    }
    
    if (self.viewArray.count>_itmesArray.count+2)
    {
        NSUInteger length = self.viewArray.count-_itmesArray.count;//3-2
        [self.viewArray removeObjectsInRange:NSMakeRange(_viewArray.count-length-1, length)];
    }
    
    
    
    [self.viewArray enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        UIImageView *tempImgV = (UIImageView *)obj;
        //        CGRect rightRect = tempImgV.frame;
        //        rightRect.origin = CGPointMake(CGRectGetWidth(self.frame) * idx, 0);// // 首页是第0页,默认从第1页开始的。所以+320。。。
        //        rightRect.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        //        tempImgV.frame = rightRect;
        
        ZXADBannerModel *model = nil;
        if (idx ==0)
        {
            model = (ZXADBannerModel *)[_itmesArray lastObject];
        }
        else if (idx ==_viewArray.count-1)
        {
            model = (ZXADBannerModel *)[_itmesArray firstObject];
        }
        else
        {
            model = (ZXADBannerModel *)[_itmesArray objectAtIndex:idx-1];
        }
        if ([tempImgV respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:completed:)])
        {
            [tempImgV sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
        }
    }];

}

- (void)setItmesArray:(NSMutableArray *)itmesArray
{
    _itmesArray = itmesArray;
}

- (void)reloadData
{
    if (self.timer)
    {
        [self.timer pauseTimer];
    }
//    [self.viewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [self.viewArray removeAllObjects];
//    [self.viewArray addObjectsFromArray:[self totalFromImageViewsArray]];
    
    self.scrollView.scrollEnabled = self.itmesArray.count>1?YES:NO;
    [self setNeedsLayout];
    
    self.pageControl.numberOfPages = self.itmesArray.count;
    
    
    if (self.timer&&self.itmesArray.count>1)
    {
        [self.timer resumeTimer];
    }

    
    if (!self.timer &&self.itmesArray.count>1)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [self.timer fire];
    }
}


/*
- (NSMutableArray *)totalFromImageViewsArray
{
    if (self.itmesArray.count<1)
    {
        return nil;
    }

    NSMutableArray *arr = [NSMutableArray array];
    
    [self.itmesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ZXADBannerModel *model = (ZXADBannerModel *)obj;
        
        UIImageView *tempImgV = [[UIImageView alloc] init];
        tempImgV.frame = self.frame;
        if ([tempImgV respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:completed:)])
        {
            [tempImgV sd_setImageWithURL:model.picURL placeholderImage:AppPlaceholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
        }
        [arr addObject:tempImgV];

    }];
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    UIImageView * imageView2 = [[UIImageView alloc] init];
    
    if ([imageView1 respondsToSelector:@selector(sd_setImageWithURL:)])
    {
        [imageView1 sd_setImageWithURL:[(ZXADBannerModel*)[self.itmesArray lastObject] picURL] placeholderImage:AppPlaceholderImage];// 添加最后1页在首页 循环
        
        [imageView2 sd_setImageWithURL:[(ZXADBannerModel *)[self.itmesArray objectAtIndex:0]picURL] placeholderImage:AppPlaceholderImage];
    }
    [arr insertObject:imageView1 atIndex:0];
    [arr addObject:imageView2];

    return arr;
}



- (void)configContentView
{
    if (self.viewArray.count==0)
    {
        return;
    }
    NSInteger count = 0;
    for(UIView *contentView in self.viewArray)
    {
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.frame) * (count ++), 0);// // 首页是第0页,默认从第1页开始的。所以+320。。。
        rightRect.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        contentView.frame = rightRect;
        
        [self.scrollView addSubview:contentView];
        
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [tapGesture requireGestureRecognizerToFail:self.scrollView.panGestureRecognizer];
        [contentView addGestureRecognizer:tapGesture];
        
        contentView.contentMode = UIViewContentModeScaleAspectFill;
        contentView.clipsToBounds = YES;

    }
}
*/

#pragma mark-layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];

    self.scrollView.frame = self.bounds;
    if (self.itmesArray.count>0)
    {
        CGSize pageSize = [self.pageControl sizeForNumberOfPages:self.itmesArray.count];//minSize of pageCount
        pageSize = CGSizeMake(pageSize.width+40, pageSize.height);
        self.pageControl.frame =CGRectMake(CGRectGetMidX(self.scrollView.frame)-pageSize.width/2, CGRectGetHeight(self.scrollView.frame)-pageSize.height, pageSize.width,pageSize.height);
        // NSLog(@"%@",NSStringFromCGRect(self.pageControl.bounds));
        
        self.scrollView.contentSize = CGSizeMake((self.itmesArray.count+2)*CGRectGetWidth(self.scrollView.frame),  CGRectGetHeight(self.scrollView.frame));////  +上第1页和第4页  原理：3-[1-2-3]-1

        NSInteger _counter =0;
        for(UIView *contentView in self.viewArray)
        {
            CGRect rightRect = contentView.frame;
            rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (_counter ++), 0);
            rightRect.size = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
            contentView.frame = rightRect;
        }

        //  如果没有设置contentSize，contentOffset是偏移不起来的
        //  NSLog(@"%@",NSStringFromCGRect(self.scrollView.frame));
        //  NSLog(@"contentSize=%@",NSStringFromCGSize(self.scrollView.contentSize));
        
        NSLog(@"%@",NSStringFromCGPoint(self.scrollView.contentOffset));
        //只有第一次的时候默认移动过去距离，以后刷新的时候不移动
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
              [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame), 0) animated:NO]; //是否需要滚动的效果
        });

    }

}



#pragma mark-PageAction
- (void)pageEventMathod:(UIPageControl *)sender
{
    [self.timer pauseTimer];
    [self timerFired:nil];
    [self.timer resumeTimer];
}





- (void)timerFired:(NSTimer *)sender
{
//    NSLog(@"timer-contentOffset=%@再转到下一页", NSStringFromCGPoint(self.scrollView.contentOffset));
   
    //稍微滑过去一段距离，如果大于某个平均距离，则提前改变当前页数标识
    CGFloat pagewidth = CGRectGetWidth(self.scrollView.frame);
    CGFloat mx =pagewidth/ (self.itmesArray.count+2);
    NSInteger currentPage = floor((self.scrollView.contentOffset.x - mx) / pagewidth);

//    NSLog(@"%ld",currentPage);
//    CGFloat pagewidth = CGRectGetWidth(self.scrollView.frame);
//    int currentPage = floor((self.scrollView.contentOffset.x - 0) / pagewidth);
//        NSLog(@"滚动前currentPage＝%d再转到下一页",currentPage);
     if (currentPage==(self.itmesArray.count))
    {
        //        假如最后一页不显示了，直接跳到同一个对象的第二页，那最后倒数第二页到 第二页就没有滚动效果了；
        //        调用这个方法的时候会有点延迟，最后一页跳转到第二页的时候，如果测试速度太快，这个方法还没来得及响应，会出现背景空白； -1 <0,1> 2  ,-1就是1页面， 2就是0页面
        //        这个方法也会调用ScrollViewDidScrollView－－然后导致那边设置的currentPage正确,self.currentPageIndex也正确；  有个问题就是这里运行的时候，点击事件会被阻拦，等这个方法运行完点击才有效；
        
        //为了解决到count＋1=最后一张，再跳回到第二张图片；但是其实是同一张图片，导致停留2次时间； 所以引入暂停，重启；
        [self.timer pauseTimer];
        [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.scrollView.frame),0,CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)) animated:NO]; // 最后+1,循环第1页
        [self.timer resumeTimer];

    }
    else
    {
        CGPoint newOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame)*(currentPage+1) + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
        if (!CGSizeEqualToSize(self.scrollView.contentSize, CGSizeZero))
        {
            [self.scrollView setContentOffset:newOffset animated:YES];

        }

    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.timer)
    {
        [self.timer pauseTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.timer)
    {
        [self.timer resumeTimerAfterTimeInterval:3.f];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    计算currentPage只能在这里计算，因为有drag一定距离，又会反弹回去的情况，要动态及改变,不然会影响self.pageControl.currentPage；
    [self getCurrentPage];
//    这里早点可以调用scrollrectto方法，就不会出现测试太快导致出现空白面来不及现实的问题了
    if (self.scrollView.dragging)
    {
        CGFloat pagewidth = CGRectGetWidth(scrollView.frame);
        int currentPage = floor((self.scrollView.contentOffset.x - 0) / pagewidth);
        
        //    这里的scrollView offest是减速停止的时候； 这里的currentPage 和 scrollViewDidScrollView得到的一样；
        if (currentPage==-1)
        {
            [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.scrollView.frame) * self.itmesArray.count,0,CGRectGetWidth(self.scrollView.frame),CGRectGetHeight(self.scrollView.frame)) animated:NO]; // 第一页的时候 变为最后1页
        }

        if (currentPage==(self.itmesArray.count+1))
        {
            // 这个方法也会调用ScrollViewDidScrollView－－然后导致那边设置的currentPage正确,self.currentPageIndex也正确；// 最后+1,循环第1页
            
            [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.frame),0,CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)) animated:NO];
        }
    }
}

- (void)getCurrentPage
{
    CGFloat pagewidth = CGRectGetWidth(self.scrollView.frame);
    CGFloat mx =pagewidth/ (self.itmesArray.count+2); //多加这个是为了效果更好罢了，pageControl会有动态赋值效果；也可以直接设置为0；但是会改变cuttrentPage的值，需要重新调；
    int currentPage = floor((self.scrollView.contentOffset.x - mx) / pagewidth);
    //    NSLog(@"currentPage＝%d",currentPage);
    //    总共count＋2页，当cuttentPage为最后一页的时候，调用EndDecelerating方法，跳转到第2页面；
    //    当currentPage为第一页的时候，触发方法，跳转到最后一页；
    //    设置这里是为了以防self.currentPageIndex出错；//计算多加了mx问题，所以第一页的时候currentPage会变－1
    
    if(currentPage ==-1)
    {
        currentPage =(int)self.itmesArray.count-1;
    }
    if (currentPage==self.itmesArray.count)
    {
        currentPage=0;
    }
    
    self.pageControl.currentPage =currentPage;//currentPage值最大是count－1;
    self.currentPageIndex = self.pageControl.currentPage;
    
}

//手动的时候检测，减速停止下来，翻页的时候，是整页都翻过去后停下来的时候；  320，640， 960，1280； 如果没有翻页过去，那还是原来的坐标；
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = CGRectGetWidth(scrollView.frame);
   CGFloat mx =pagewidth/ (self.itmesArray.count+2);
    int currentPage = floor((self.scrollView.contentOffset.x - mx) / pagewidth);

//    这里的scrollView offest是减速停止的时候； 这里的currentPage 和 scrollViewDidScrollView得到的一样；
    if (currentPage==-1)
    {
        [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.scrollView.frame) * self.itmesArray.count,0,CGRectGetWidth(self.scrollView.frame),CGRectGetHeight(self.scrollView.frame)) animated:NO]; // 第一页的时候 变为最后1页
    }
    
    else if (currentPage==(self.itmesArray.count))
    {
       // 这个方法也会调用ScrollViewDidScrollView－－然后导致那边设置的currentPage正确,self.currentPageIndex也正确；// 最后+1,循环第1页
        
        [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.frame),0,CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)) animated:NO];
    }
}


#pragma mark-delegate

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
//    NSLog(@"tap = %@",tap);
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didSelectRowAtIndex:)])
    {
        [self.delegate infiniteScrollView:self didSelectRowAtIndex:self.currentPageIndex];
    }
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didSelectModel:)])
    {
        [self.delegate infiniteScrollView:self didSelectModel:[self.itmesArray objectAtIndex:self.currentPageIndex]];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    NSLog(@"%@",@(gestureRecognizer.state));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press
{
    NSLog(@"Press:%@",@(gestureRecognizer.state));

    return YES;
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"gestureRecognizer=%@, otherGestureRecognizer=%@",gestureRecognizer,otherGestureRecognizer);
    
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
-(void)dealloc
{
    if ([self.timer isValid])
    {
        [self.timer invalidate];//将计时器从runloop中移出
    }
}

#pragma mark-测试数据
- (void)addTestData
{
    if (!self.itmesArray)
    {
        self.itmesArray = [NSMutableArray array];
    }
    if (self.itmesArray.count==0)
    {
        if ([NSClassFromString(@"ZXADBannerModel") instancesRespondToSelector:@selector(initWithDesc:picString:url:advId:)])
        {
           NSString *str1 = @"http://image.cdn.ichuandian.com/img/post/500_500/bhapost3a076c0c75284bd89e0d95201af26b68.jpg";
            ZXADBannerModel *advModel1 = [[ZXADBannerModel alloc] initWithDesc:nil picString:str1 url:nil advId:nil];
            NSString *str2 = @"http://image.cdn.ichuandian.com/img/post/500_500/bhapost61154e677f7a4e438ecc352ff16ce3fc.jpg";
            ZXADBannerModel *advModel2 = [[ZXADBannerModel alloc] initWithDesc:nil picString:str2 url:nil advId:nil];

            NSString *str3 = @"http://image.cdn.ichuandian.com/img/post/500_500/bhapost61154e677f7a4e438ecc352ff16ce3fc.jpg";
            ZXADBannerModel *advModel3 = [[ZXADBannerModel alloc] initWithDesc:nil picString:str3 url:nil advId:nil];

            NSArray *arr = @[advModel1,advModel2,advModel3];
            
            [self.itmesArray addObjectsFromArray:arr];

        }
        
    }
}

@end




/*
 //动画自动的时候检测，会调用2次；因为2次layoutSubview调用了动画
 - (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
 {
 NSLog(@"滚动完后contentOffset=%@",NSStringFromCGPoint(scrollView.contentOffset));//{375, 0}//
 self.scrollView.delaysContentTouches = NO;
 }
 
 - (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
 {
 NSLog(@"%@,targetContentOffest =",NSStringFromCGPoint(velocity));
 }
 */



#pragma mark-重写scrollView的时候使用
//- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
//{
//    if(!self.scrollView.dragging)
//
//    {
//        [[self.scrollView nextResponder]touchesBegan:touches withEvent:event];
//    }
//
//    [super touchesBegan:touches withEvent:event];
//
//    // NSLog(@"MyScrollView touch Began");
//}
//
//- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
//{
//    if(!self.scrollView.dragging)
//    {
//        [[self nextResponder]touchesEnded:touches withEvent:event];
//    }
//    [super touchesEnded:touches withEvent:event];
//}
//- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
//{
//    return YES;
//}
//- (BOOL)touchesShouldCancelInContentView:(UIView *)view
//{
//    return NO;
//}



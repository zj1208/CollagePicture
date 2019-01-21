//
//  ZXPhotosView.m
//  CollagePicture
//
//  Created by simon on 17/1/6.
//  Copyright © 2017年 simon. All rights reserved.
//

#import "ZXPhotosView.h"
#import <SDWebImage/UIButton+WebCache.h>

#import "APPCommonDef.h"
#import "UIView+ZXChangeSize.h"
@interface ZXPhotosView ()

/** 添加图片按钮*/
@property (nonatomic, strong) UIButton *addImageButton;



@property (nonatomic, strong) NSMutableArray *cellMArray;
@end


@implementation ZXPhotosView
@synthesize delegate = _delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}


- (instancetype)init
{
    if (self = [super init]) {
        // 初始化
        self.photoMargin =LCDScale_iPhone6_Width(ZXPhotoMargin) ;
        self.photoWidth = LCDScale_iPhone6_Width(ZXPhotoWidth);
        self.photoHeight =LCDScale_iPhone6_Width(ZXPhotoHeight);
        self.photoMaxCount = ZXPhotoMaxCount;
        self.photosMaxColoum = ZXPhotosMaxColoum;
        self.imagesMaxCountWhenWillCompose = ZXImagesMaxCountWhenWillCompose;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = NO;
        self.autoLayoutWithWeChatSytle = YES;
        self.photosState = ZXPhotosViewStateDidCompose;
    
        self.cellMArray = [NSMutableArray array];
//        self.backgroundColor = [UIColor orangeColor];
//        self.contentInset = UIEdgeInsetsMake(5.f, 0.f, 5.f, 0.f);
//        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



+ (instancetype)photosView
{
    return [[self alloc] init];
}

+ (instancetype)photosViewWithThumbnailPicUrls:(NSArray *)thumbnailUrls  originalPicUrls:(NSArray *)originalUrls
{
    ZXPhotosView *photosView = [self photosView];
    photosView.thumbnailUrlsArray = thumbnailUrls;
    photosView.originalUrlsArray = originalUrls;
    return photosView;
}



// 没用
+ (instancetype)photosViewWithImages:(NSMutableArray *)images
{
    return [[self alloc] initPhotosViewWithImages:images];
}


- (instancetype)initPhotosViewWithImages:(NSMutableArray *)images
{
    if (self = [super init])
    {
        self.images = images;
    }
    return self;
}


//- (void)setPhotoWidth:(CGFloat)photoWidth
//{
//    _photoWidth = photoWidth;
//    self.photoModelArray= self.photoModelArray;
//    
//    // 刷新布局
//    [self layoutSubviews];
//}
//
//- (void)setPhotoHeight:(CGFloat)photoHeight
//{
//    _photoHeight = photoHeight;
//    self.photoModelArray= self.photoModelArray;
//    // 刷新布局
//    [self layoutSubviews];
//}
//


//这里的单张图片计算规则，还需要改动；
- (CGSize)getSinglePhotoViewLayoutWithOrignialSize:(CGSize)size
{
//    NSLog(@"%@",self);
    CGFloat maxImageHeight = LCDScale_5Equal6_To6plus(200);
    CGFloat maxImageWidth = LCDScale_5Equal6_To6plus(200);
    //    140
    
    CGFloat width =0.f;
    CGFloat height =0.f;
    
    if (size.width < size.height) {
        
        height = size.height> maxImageHeight ? maxImageHeight:size.height;
        width = size.width *height/size.height;
    }
    else if(size.height < size.width)
    {
        width =size.width> maxImageWidth?maxImageWidth:size.width;
        height =size.height*width/size.width ;
    }
    else {
        width =size.width>maxImageWidth?maxImageWidth :size.width;
        height = width;
    }
    return CGSizeMake(width, height);
}


- (void)setOriginalUrlsArray:(NSArray *)originalUrlsArray
{
    _originalUrlsArray = originalUrlsArray;
    
    // 设置模型链接
    [self setPhotosUrl];
}

- (void)setThumbnailUrlsArray:(NSArray *)thumbnailUrlsArray
{
    _thumbnailUrlsArray = thumbnailUrlsArray;
    
    // 设置模型链接
    [self setPhotosUrl];
}

- (void)setPhotosUrl
{
    // 取出图片最多个数
    NSInteger maxPhotosCount = self.thumbnailUrlsArray.count > self.originalUrlsArray.count ? self.thumbnailUrlsArray.count : self.originalUrlsArray.count;
    NSMutableArray *photosMArray = [NSMutableArray array];
    for (NSInteger i = 0; i < maxPhotosCount; i++)
    {
        // 创建模型
        ZXPhoto *photo = [[ZXPhoto alloc] init];
        // 赋值
        photo.original_pic = i < self.originalUrlsArray.count ? self.originalUrlsArray[i] : nil;
        photo.thumbnail_pic = i < self.thumbnailUrlsArray.count ? self.thumbnailUrlsArray[i] : nil;
        // 添加模型
        [photosMArray addObject:photo];
    }
    // 刷新
    self.photoModelArray = photosMArray;
}

- (void)setItemViewCornerRadius:(void(^)(UIView* itemView))photoItemViewBlock
{
    if (photoItemViewBlock)
    {
        _photoModelItemViewBlock = photoItemViewBlock;
    }
}

- (void)setPhotoModelArray:(NSArray *)photoModelArray
{
    _photoModelArray  = photoModelArray;
    // 设置图片状态
    self.photosState = ZXPhotosViewStateDidCompose;

    //获取最多显示几张图片
    NSInteger photoCount = self.photoMaxCount<photoModelArray.count?self.photoMaxCount:photoModelArray.count;
//    NSInteger photoCount = self.photoMaxCount;

    // 当UIButton不够的时候，才需要创建；
    while (self.cellMArray.count < photoCount) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [btn addTarget:self action:@selector(clickPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.photoModelItemViewBlock)
        {
            self.photoModelItemViewBlock(btn);
        }
        [self addSubview:btn];
        [self.cellMArray addObject:btn];
    }

//    __weak __typeof(self)weakSelf = self;
    [self.cellMArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIButton *photoView = (UIButton *)obj;
        photoView.tag = idx;

        if (idx < photoModelArray.count)
        {
            photoView.hidden = NO;
            // 设置图片
            id photoItem = [photoModelArray objectAtIndex:idx];

            if ([photoItem isKindOfClass:[ZXPhoto class]])
            {
                ZXPhoto *zxPhoto = (ZXPhoto*)photoItem;
                NSURL *url = [NSURL URLWithString:zxPhoto.thumbnail_pic];
                [photoView sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:AppPlaceholderImage];
            }
           
        }else{
            photoView.hidden = YES;
        }

    }];
}


- (void)clickPhotoAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(zx_photosView:didSelectWithIndex:photosArray:)])
    {
        [self.delegate zx_photosView:self didSelectWithIndex:sender.tag photosArray:_photoModelArray];
    }
    else if ([self.delegate respondsToSelector:@selector(zx_photosView:didSelectWithIndex:photosArray:userInfo:)])
    {
        [self.delegate zx_photosView:self didSelectWithIndex:sender.tag photosArray:_photoModelArray userInfo:_userInfo];
    }
}
/*
- (void)setImages:(NSMutableArray<UIImage *> *)images
{
    // 图片大于规定数字（取前九张）
    if (images.count > self.imagesMaxCountWhenWillCompose) {
        NSRange range = NSMakeRange(0, self.imagesMaxCountWhenWillCompose);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        images = [NSMutableArray arrayWithArray:[images objectsAtIndexes:set]];
    };
    _images = images;
  
//    // 移除添加图片按钮
//    [self.addImageButton removeFromSuperview];
    
    self.photosState = ZXPhotosViewStateWillCompose;
    NSInteger imageCount = images.count;
    
//  添加相应的图片
//  [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    while (self.cellMArray.count < imageCount) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [self.cellMArray addObject:btn];
    }

//    while (self.subviews.count < imageCount) { // UIImageView不够，需要创建
//        PYPhotoView *photoView = [[PYPhotoView alloc] init];
//        photoView.photosView = self;
//        [self addSubview:photoView];
//    }

    __weak __typeof(self)weakSelf = self;
    
    [self.cellMArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *photoView = (UIButton *)obj;
        photoView.tag = idx;
        
        if (idx < weakSelf.images.count) {
            photoView.hidden = NO;
            [photoView setBackgroundColor:[UIColor orangeColor]];
            [photoView setImage:[images objectAtIndex:idx] forState:UIControlStateNormal];
            
        }else{
            photoView.hidden = YES;
        }
        
    }];

    if (_images.count ==0)
    {
        if (![self.promptLab isDescendantOfView:self])
        {
            [self addSubview:self.promptLab];
        }
        self.promptLab.hidden = NO;
    }
    else
    {
        self.promptLab.hidden = YES;
    }
}
*/

// 每次需要重新布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 取消内边距
    self.contentInset = UIEdgeInsetsZero;
    
    //根据photoMaxCount最大值 来判定 获取显示几张图片；
    NSInteger photoCount = 0;
    if (self.photosState == ZXPhotosViewStateDidCompose)
    {
        photoCount = self.photoModelArray.count<self.photoMaxCount?self.photoModelArray.count:self.photoMaxCount;
    }
    else
    {
        photoCount = self.images.count<self.imagesMaxCountWhenWillCompose?self.images.count:self.imagesMaxCountWhenWillCompose;
    }
   
    //获取判定需要几列
    NSInteger maxCol =self.photosMaxColoum;
    if (self.photosState==ZXPhotosViewStateDidCompose && photoCount ==4 && self.autoLayoutWithWeChatSytle)
    {
        maxCol = 2;
    }
    
    //调整图片位置
    __block CGFloat zx_x;
    __block CGFloat zx_y;
    __weak __typeof(self)weakSelf = self;
    [self.cellMArray enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger rowIndex = idx / maxCol;
        NSInteger columnIndex = idx % maxCol;
        zx_x = columnIndex *(weakSelf.photoWidth+weakSelf.photoMargin);
        zx_y = rowIndex *(weakSelf.photoHeight + weakSelf.photoMargin);
        btn.frame = CGRectMake(floorf(zx_x), floorf(zx_y),floorf(weakSelf.photoWidth), floorf(weakSelf.photoHeight));
        
    }];
    
    /*
    //设置发布图片时 额外的button位置，scrollView的size；
    if (self.images.count < self.imagesMaxCountWhenWillCompose && self.photosState == ZXPhotosViewStateWillCompose) {
        
        if (![self.addImageButton isDescendantOfView:self])
        {
            [self addSubview:self.addImageButton];
        }
        NSInteger rowIndex = self.images.count / maxCol;
        NSInteger columnIndex = self.images.count % maxCol;
        zx_x = columnIndex *(_photoWidth+_photoMargin);
        zx_y = rowIndex *(_photoHeight + _photoMargin);

        self.addImageButton.frame = CGRectMake(floorf(zx_x), floorf(zx_y), floorf(_photoWidth), floorf(_photoHeight));
        
    }
    */
    // 设置contentSize和 self.size
    // 取出size
    CGSize size = [self sizeWithPhotoCount:photoCount photosState:self.photosState];
    self.contentSize = size;
    CGFloat width = size.width + self.zx_x > LCDW ? LCDW - self.zx_x : size.width;
    self.zx_size = CGSizeMake(width, size.height);
    
}



/*
//添加图片按钮
- (UIButton *)addImageButton
{
    if (!_addImageButton) {
        UIButton *addImageBtn = [[UIButton alloc] init];
        UIImage *addImage = [UIImage imageNamed:ZXAddImageName];
        [addImageBtn setBackgroundImage:addImage forState:UIControlStateNormal];
        [addImageBtn addTarget:self action:@selector(addImageDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _addImageButton = addImageBtn;
    }
    return _addImageButton;
}


- (UILabel *)promptLab
{
    if (!_promptLab)
    {
        UILabel *promptLab = [[UILabel alloc] init];
        promptLab.numberOfLines = 0;
        promptLab.textColor = UIColorFromRGB(153.f, 153.f, 153.f);
        promptLab.font = [UIFont systemFontOfSize:14];
       
        _promptLab = promptLab;
    }
    return _promptLab;
}



//点击添加图片调用此方法
- (void)addImageDidClicked:(id)sender
{
//    发出添加图片的通知
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    userInfo[PYAddImageDidClickedNotification] = self.images;
//    NSNotification *notifaction = [[NSNotification alloc] initWithName:PYAddImageDidClickedNotification object:nil userInfo:userInfo];
//    [[NSNotificationCenter defaultCenter] postNotification:notifaction];
    
    if ([self.delegate respondsToSelector:@selector(photosView:didAddImageClickedWithImages:)])
    {
        [self.delegate photosView:self didAddImageClickedWithImages:self.images];
    }
}
 
 - (void)reloadDataWithImages:(NSMutableArray *)images
 {
 [self setImages:_images];
 }
*/


- (CGSize)sizeWithPhotoCount:(NSInteger)count  photosState:(ZXPhotosViewState)state
{
    // 0张图片
    if (count ==0)
    {
        if (state == ZXPhotosViewStateDidCompose)
        {
            return CGSizeMake(0.f, 0.f);
        }
        return self.frame.size;
    }
    
    NSInteger photoCount = 0;
    if (state ==ZXPhotosViewStateWillCompose)
    {
        if (count < self.imagesMaxCountWhenWillCompose)
        {
            count++;
        }
        //根据条件获取最多几条数据
        photoCount = count<self.imagesMaxCountWhenWillCompose?count:self.imagesMaxCountWhenWillCompose;
    }
    else
    {
        //根据条件获取最多几条数据
        photoCount = count<self.photoMaxCount?count:self.photoMaxCount;
    }
    NSInteger columns = 0; // 列数
    NSInteger rows = 0; // 行数
    CGFloat photosViewW = 0;
    CGFloat photosViewH = 0;
    //获取需要几列
    NSInteger maxCol =self.photosMaxColoum;
    //已经发布
    if (state ==ZXPhotosViewStateDidCompose)
    {
        if (self.photoModelArray.count >0 && self.autoLayoutWithWeChatSytle)
        {
           maxCol = photoCount==4?2:maxCol;
        }
    }
    columns = (photoCount >= maxCol) ? maxCol : photoCount;
    //计算有几行的简单方法
    rows =   (photoCount + maxCol - 1) / maxCol;
    
    //计算宽度／高度
    photosViewW = columns * self.photoWidth + (columns - 1) * self.photoMargin;
    photosViewH = rows * self.photoHeight + (rows - 1) * self.photoMargin;
    

    return CGSizeMake(ceilf(photosViewW), ceilf(photosViewH));
}






// 处理事件传递，当点击scrollView的时候，不应该反馈这个事件传递是有效的；点击scrollView的空白区域应该让父视图自己响应事件；
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return  CGRectContainsPoint(self.bounds, point);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self])
    {
        return nil;
    }
    return view;
}
@end

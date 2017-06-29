//
//  ZXManyImgIconsView.m
//  YiShangbao
//
//  Created by simon on 17/6/3.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXManyImgIconsView.h"


static CGFloat const  ZXPhotoMargin = 6;   // 图片之间的默认间距
static CGFloat const  ZXPhotoWidth = 15;    // 图片的默认宽度
static CGFloat const  ZXPhotoHeight = 15;   // 图片的默认高度
static NSInteger const ZXPhotosMaxColoum = 10;  // 图片每行默认最多个数
static NSInteger const ZXPhotoMaxCount = 9; //默认最多显示9张

@interface ZXManyImgIconsView ()

@property (nonatomic, strong) NSMutableArray *cellMArray;

@end

@implementation ZXManyImgIconsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    if (self = [super init]) {
        // 初始化
        self.imgIconMargin =LCDScale_iphone6_Width(ZXPhotoMargin) ;
        self.imgIconWidth = LCDScale_iphone6_Width(ZXPhotoWidth);
        self.imgIconHeight =LCDScale_iphone6_Width(ZXPhotoHeight);
        self.imgIconMaxCount = ZXPhotoMaxCount;
        self.photosMaxColoum = ZXPhotosMaxColoum;
//        self.imagesMaxCountWhenWillCompose = ZXImagesMaxCountWhenWillCompose;
//        self.showsVerticalScrollIndicator = NO;
//        self.showsHorizontalScrollIndicator = NO;
//        self.pagingEnabled = NO;
//        self.autoLayoutWithWeChatSytle = YES;
//        self.photosState = ZXPhotosViewStateDidCompose;
        
        self.cellMArray = [NSMutableArray array];
        //        self.backgroundColor = [UIColor orangeColor];
        //        self.contentInset = UIEdgeInsetsMake(5.f, 0.f, 5.f, 0.f);
        
    }
    return self;
}

- (instancetype)zxManyImgIconsViewWithThumbnailPicUrls:(NSArray *)thumbnailUrls
{
    if (self == [super init])
    {
        self.thumbnailUrlsArray = thumbnailUrls;
    }
    return self;
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
    NSInteger photoCount = self.thumbnailUrlsArray.count > self.imgIconMaxCount? self.imgIconMaxCount: self.thumbnailUrlsArray.count;
    
    // 当UIButton不够的时候，才需要创建；
    while (self.cellMArray.count < photoCount) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        [self.cellMArray addObject:imageView];
    }
    
    [self.cellMArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *imageView = (UIImageView  *)obj;
        if (idx < photoCount) {
            imageView.hidden = NO;
            // 设置图片
            NSString * urlStr = [self.thumbnailUrlsArray objectAtIndex:idx];
            NSURL *url = [NSURL URLWithString:urlStr];
            [imageView sd_setImageWithURL:url];
            
        }else{
            imageView.hidden = YES;
        }
        
    }];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    // 取消内边距
    
    //根据photoMaxCount最大值 来判定 获取显示几张图片；
    NSInteger photoCount = self.thumbnailUrlsArray.count<self.imgIconMaxCount?self.thumbnailUrlsArray.count:self.imgIconMaxCount;
    
    //获取判定需要几列
    NSInteger maxCol =self.photosMaxColoum;
     
    //调整图片位置
    __block CGFloat zx_x;
    __block CGFloat zx_y;
    [self.cellMArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger rowIndex = idx / maxCol;
        NSInteger columnIndex = idx % maxCol;
        zx_x = columnIndex *(_imgIconWidth+_imgIconMargin);
        zx_y = rowIndex *(_imgIconHeight + _imgIconMargin);
        view.frame = CGRectMake(floorf(zx_x), floorf(zx_y),floorf( _imgIconWidth), floorf(_imgIconHeight));
        
    }];
    
    
    // 设置contentSize和 self.size
    // 取出size
    CGSize size = [self sizeWithIconsViewCount:photoCount];
    CGFloat width = size.width + self.zx_x > LCDW ? LCDW - self.zx_x : size.width;
    self.zx_size = CGSizeMake(width, size.height);
    
}


- (CGSize)sizeWithIconsViewCount:(NSInteger)count
{
    // 0张图片
    if (count ==0)
    {
        return CGSizeMake(0.f, 0.f);
    }
    
    NSInteger photoCount = 0;
    //根据条件获取最多几条数据
    photoCount = count<self.imgIconMaxCount?count:self.imgIconMaxCount;
    
    NSInteger columns = 0; // 列数
    NSInteger rows = 0; // 行数
    CGFloat photosViewW = 0;
    CGFloat photosViewH = 0;
    //获取需要几列
    NSInteger maxCol =self.photosMaxColoum;
    columns = (photoCount >= maxCol) ? maxCol : photoCount;
    //计算有几行的简单方法
    rows =   (photoCount + maxCol - 1) / maxCol;
    
    //计算宽度／高度
    photosViewW = columns * self.imgIconWidth + (columns - 1) * self.imgIconMargin;
    photosViewH = rows * self.imgIconHeight + (rows - 1) * self.imgIconMargin;
    
    return CGSizeMake(ceilf(photosViewW), ceilf(photosViewH));
}
@end

//
//  ZXAddPicViewCell.m
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAddPicViewCell.h"
#import "ZXAddPicCollectionConst.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import <Photos/Photos.h>

@interface ZXAddPicViewCell ()

@property (nonatomic, strong) ZXPhoto *model;

- (void)setModelData:(ZXPhoto *)data indexPath:(NSIndexPath *)indexPath isContainVideo:(BOOL)flag;
@end

@implementation ZXAddPicViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deleteBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.deleteBtn setBackgroundColor:[UIColor blueColor]];
    
    self.imageView.contentMode =UIViewContentModeScaleAspectFill;
    self.imageViewCornerRadius = 6.f;
    self.videoCoverView.hidden = YES;
    
    //默认添加长按手势； 6.20 修改新增
    if ([[UIDevice currentDevice] systemVersion].floatValue< ZXAddPicCollectionView_SYSTEMVERSION) {
         [self addGestureRecognizer:self.longPressGesture];
    }
}

- (UILongPressGestureRecognizer *)longPressGesture
{
    if (!_longPressGesture) {
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        _longPressGesture = gesture;
    }
    return _longPressGesture;
}

- (void)setImageViewCornerRadius:(CGFloat)imageViewCornerRadius
{
    _imageViewCornerRadius = imageViewCornerRadius;
    [self setView:self.imageView cornerRadius:imageViewCornerRadius borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
}


- (void)setView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    
    view.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}


- (void)setData:(id)data indexPath:(NSIndexPath *)indexPath isContainVideo:(BOOL)flag
{
    if ([data isKindOfClass:[UIImage class]])
    {
        self.imageView.image = (UIImage *)data;
    }
    else if ([data isKindOfClass:[ZXPhoto class]])
    {
        ZXPhoto *photo = (ZXPhoto *)data;
        if (photo.type == ZXAssetModelMediaTypePhoto ||photo.type == ZXAssetModelMediaTypeCustom)
        {
            NSURL *url = [NSURL URLWithString:photo.thumbnail_pic];
            [self.imageView sd_setImageWithURL:url placeholderImage:AppPlaceholderImage];
        }
        else if (photo.type == ZXAssetModelMediaTypeVideo)
        {
            NSURL *url = [NSURL URLWithString:photo.videoURLString];
            [self setImageView:self.imageView withURL:url placeholderImage:AppPlaceholderImage];
        }
        [self setModelData:photo indexPath:indexPath isContainVideo:flag];
    }
}

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
}

// 一旦执行这个，视频图片就有可能加载有问题；
- (void)setModelData:(ZXPhoto *)data indexPath:(NSIndexPath *)indexPath isContainVideo:(BOOL)flag
{
    self.model = data;
    if ([self.model isKindOfClass:[ZXPhoto class]])
    {
        [self refreshIndexPath:indexPath isContainVideo:flag];
    }
}


- (void)refreshIndexPath:(NSIndexPath *)indexPath isContainVideo:(BOOL)flag
{
    [self addContentViewIfNotExist];
    
    [self.customCellCoverView refresh:self.model indexPath:indexPath isContainVideo:flag];
    [self.customCellCoverView setNeedsLayout];
}

- (void)addContentViewIfNotExist
{
    if (!self.customCellCoverView)
    {
        id<ZXAddPicCellLayoutConfigSource> layoutConfig = [[ZXAddPicViewKit sharedKit] cellLayoutConfig];
        NSString *contentViewClass = [layoutConfig cellContent:self.model];
        NSAssert([contentViewClass length] > 0, @"should offer cell content class name");
        Class clazz = NSClassFromString(contentViewClass);
        ZXAddPicCellBaseCoverView *contentView = [[clazz alloc] initContentView];
        NSAssert(contentView, @"can not init content view");
        self.customCellCoverView = contentView;

//        _customCellCoverView.backgroundColor = [UIColor orangeColor];
        [self setView:self.customCellCoverView cornerRadius:self.imageViewCornerRadius borderWidth:0.5f borderColor:nil];
        
        [self.contentView insertSubview:self.customCellCoverView belowSubview:self.deleteBtn];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutBubbleView];

}

- (void)layoutBubbleView
{
//    和imageView一样大
    self.customCellCoverView.frame = CGRectMake(0, CGRectGetMinY(self.imageView.frame), CGRectGetWidth(self.contentView.frame)-10, CGRectGetHeight(self.contentView.frame)-CGRectGetMinY(self.imageView.frame));
}


#pragma mark - 长按手势

// 每个cell的手势 设置禁用与否/6.20 修改新增
- (void)setLongPressGestureRecognizersWithCanMoveItem:(BOOL)flag
{
    if ([[UIDevice currentDevice] systemVersion].floatValue >= ZXAddPicCollectionView_SYSTEMVERSION)
    {
        return;
    }
    NSArray *gestureRecognizers = self.gestureRecognizers;
    if (gestureRecognizers.count >0)
    {
        [gestureRecognizers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[UILongPressGestureRecognizer class]])
            {
                UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)obj;
                if ([[UIDevice currentDevice] systemVersion].floatValue<ZXAddPicCollectionView_SYSTEMVERSION && flag)
                {
                    
                    longPress.enabled = YES;
                }
                else
                {
                    longPress.enabled = NO;
                }
            }
        }];
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    if ([self.delegate respondsToSelector:@selector(zxAddPicViewCellDelegateWithLongPressAction:)])
    {
        [self.delegate zxAddPicViewCellDelegateWithLongPressAction:longPress];
    }
}
@end

//
//  ImageEditView.m
//  Baby
//
//  Created by simon on 16/2/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "ImageEditView.h"

@interface ImageEditView ()

@property(nonatomic,strong)UIImage *tempImg;

@end

@implementation ImageEditView
@synthesize imageView= _imageView;
@synthesize scrollView = _scrollView;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initImageView];
    }
    return self;
}

- (BOOL)isHadImage
{
    return _hadImage;
}


- (void)setImageViewData:(UIImage *)img
{
    if (self.imageView.image ==nil)
    {
        self.imageView.image= img;
        self.hadImage = YES;
        
        self.imageView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        
        self.scrollView.contentSize =img.size;
        self.tempImg = img;
//        NSLog(@"%@",NSStringFromCGRect(self.bounds));
    }
}


- (void)initImageView
{
    self.backgroundColor = [UIColor grayColor];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];

    self.imageView = [[UIImageView alloc] init];
    self.imageView.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView setMaximumZoomScale:1.0];

   
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor colorWithWhite:0.88 alpha:1]];
//    [btn setTitle:@"添加照片" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"m_editPicBg"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    self.selectBtn = btn;
    
}

//修改imageEditView的约束为frame
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame =self.bounds;
    self.selectBtn.frame =self.bounds;
    
    if (self.tempImg)
    {
        CGFloat miniWidthScale = CGRectGetWidth(self.bounds)/self.tempImg.size.width;
        CGFloat miniHeightScale = CGRectGetHeight(self.bounds)/self.tempImg.size.height;
        //        NSLog(@"%@,%@",@(miniWidthScale),@(miniHeightScale));
        float minimumScale =  miniWidthScale>miniHeightScale?miniWidthScale:miniHeightScale;//0.08--0.04
        [self.scrollView setMinimumZoomScale:minimumScale];
        if (CGRectGetHeight(self.bounds)<100)
        {
            [self.scrollView setZoomScale:(minimumScale+0.1)];
        }
        else
        {
            [self.scrollView setZoomScale:0.5];
        }

    }
  
}

- (void)addImage:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(imageEditViewPickerWithButton:editView:)])
    {
        [self.delegate imageEditViewPickerWithButton:sender editView:self];
    }
}


- (void)removePickerBtn
{
    [self.selectBtn removeFromSuperview];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
//    NSLog(@"%@",self.imageView);
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
//    NSLog(@"%@",@(scale));
    [scrollView setZoomScale:scale animated:YES];
}

@end

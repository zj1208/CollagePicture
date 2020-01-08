//
//  ZXAddProPicCollectionCell.m
//  YiShangbao
//
//  Created by simon on 17/3/3.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAddProPicCollectionCell.h"
#import "UIButton+WebCache.h"
#import "ZXAddBigPicCollectionView.h"
@implementation ZXAddProPicCollectionCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
      [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addProductPicView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self addProductPicView];
        
    }
    return self;
}

- (void)addProductPicView
{
    ZXAddProPicView * titleView1 = [[[NSBundle mainBundle] loadNibNamed:AddProductPicViewNib owner:self options:nil] firstObject];
    [self addSubview:titleView1];
    [titleView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
        
    }];
    self.itemView = titleView1;
}


- (void)setData:(id)data
{
    __weak __typeof(&*self)weakSelf = self;

    if ([data isEqual:[NSNull null]])
    {
        [self.itemView.picBtn sd_setImageWithURL:nil forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            weakSelf.itemView.origContainerView.hidden = [weakSelf.itemView.picBtn currentImage]?YES:NO;
            weakSelf.itemView.deleteBtn.hidden = !weakSelf.itemView.origContainerView.hidden;
        }];
    }
    else
    {
        self.itemView.origContainerView.hidden =YES;
        ZXPhoto *photo = (ZXPhoto *)data;
        NSURL *picURL = [NSURL URLWithString:photo.thumbnail_pic];
        [self.itemView.picBtn sd_setImageWithURL:picURL forState:UIControlStateNormal placeholderImage:nil options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            weakSelf.itemView.deleteBtn.hidden = !weakSelf.itemView.origContainerView.hidden;
        }];
    }
}

- (IBAction)fileOwnerDeleteBtnAction:(UIButton *)sender {
    
    NSLog(@"删除照片2");
    
    
}

@end

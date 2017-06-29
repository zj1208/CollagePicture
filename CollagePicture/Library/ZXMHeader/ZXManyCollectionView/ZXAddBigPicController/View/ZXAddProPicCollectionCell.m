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
    ZXAddProPicView * titleView1 = [[[NSBundle mainBundle] loadNibNamed:AddProductPicViewNib owner:self options:nil] lastObject];
    [self addSubview:titleView1];
    [titleView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
        
    }];
    self.itemView = titleView1;
}


- (void)setData:(id)data
{
    
    if ([data isEqual:[NSNull null]])
    {
        [self.itemView.picBtn sd_setImageWithURL:nil forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            _itemView.origContainerView.hidden = [_itemView.picBtn currentImage]?YES:NO;
            _itemView.deleteBtn.hidden = !_itemView.origContainerView.hidden;
        }];
    }
    else
    {
         _itemView.origContainerView.hidden =YES;
        ZXPhoto *photo = (ZXPhoto *)data;
        NSURL *picURL = [NSURL URLWithString:photo.thumbnail_pic];
        [self.itemView.picBtn sd_setImageWithURL:picURL forState:UIControlStateNormal placeholderImage:nil options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            
            _itemView.deleteBtn.hidden = !_itemView.origContainerView.hidden;
            
        }];
    }
}

- (IBAction)fileOwnerDeleteBtnAction:(UIButton *)sender {
    
    NSLog(@"删除照片2");
    
    
}

@end

//
//  ZXAddPicViewCell.m
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAddPicViewCell.h"
#import "ZXAddPicCollectionConst.h"


@implementation ZXAddPicViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deleteBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.deleteBtn setBackgroundColor:[UIColor blueColor]];
    
    self.imageView.contentMode =UIViewContentModeScaleAspectFill;
    self.imageViewCornerRadius = 6.f;
    [self setView:self.imageView cornerRadius:self.imageViewCornerRadius borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    self.videoCoverView.hidden = YES;
    
    //6.20 修改新增
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPressGesture];
    self.longPress = longPressGesture;
}




- (void)setView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    
    view.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}

// 一旦执行这个，视频图片就有可能加载有问题；
- (void)setData:(ZXPhoto *)data indexPath:(NSIndexPath *)indexPath isContainVideo:(BOOL)flag
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
    
    [_customContentView refresh:self.model indexPath:indexPath isContainVideo:flag];
    [_customContentView setNeedsLayout];
}

- (void)addContentViewIfNotExist
{
    
    if (_customContentView == nil)
    {
        id<ZXAddPicCellLayoutConfigSource> layoutConfig = [[ZXAddPicViewKit sharedKit] cellLayoutConfig];
        NSString *contentViewClass = [layoutConfig cellContent:self.model];
        NSAssert([contentViewClass length] > 0, @"should offer cell content class name");
        Class clazz = NSClassFromString(contentViewClass);
        ZXAddPicBaseContentView *contentView = [[clazz alloc] initContentView];
        NSAssert(contentView, @"can not init content view");
        _customContentView = contentView;

//        _customContentView.backgroundColor = [UIColor orangeColor];
        [self setView:_customContentView cornerRadius:self.imageViewCornerRadius borderWidth:0.5f borderColor:nil];
        
        [self.contentView insertSubview:_customContentView belowSubview:self.deleteBtn];
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
    self.customContentView.frame = CGRectMake(0, CGRectGetMinY(self.imageView.frame), CGRectGetWidth(self.contentView.frame)-10, CGRectGetHeight(self.contentView.frame)-CGRectGetMinY(self.imageView.frame));
}


// 每个cell的手势 设置禁用与否/6.20 修改新增
- (void)makeGestureRecognizersWithCanMoveItem:(BOOL)flag
{
    NSArray *gestureRecognizers = self.gestureRecognizers;
    NSLog(@"%@",self.gestureRecognizers);
    if (gestureRecognizers.count >0)
    {
        [gestureRecognizers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[UILongPressGestureRecognizer class]])
            {
                UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)obj;
                if ([[UIDevice currentDevice] systemVersion].floatValue<12 && flag)
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
    if ([self.delegate respondsToSelector:@selector(zxLongPressAction:)])
    {
        [self.delegate zxLongPressAction:longPress];
    }
}
@end

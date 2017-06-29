//
//  ZXAddProPicView.m
//  YiShangbao
//
//  Created by simon on 17/2/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAddProPicView.h"

@implementation ZXAddProPicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    
    [self bringSubviewToFront:self.deleteBtn];
    
//    self.backgroundColor = [UIColor clearColor];
//    [self.picBtn setBackgroundColor:[UIColor whiteColor]];
    self.picBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self setView:self.picBtn cornerRadius:8.f borderWidth:1.f borderColor:nil];
    self.origContainerView.backgroundColor = [UIColor whiteColor];
    [super awakeFromNib];
}



- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView * view = [super hitTest:point withEvent:event];
    if ([view isEqual:self.deleteBtn])
    {
        return view;
    }
    if ([self.picBtn currentImage])
    {
        return nil;
    }
    return self.picBtn;
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
//{
//    return CGRectContainsPoint(self.bounds, point);
//}


- (void)setView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    
    view.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}



- (IBAction)deleteBtnAction:(UIButton *)sender {
    

    if ([self.delegate respondsToSelector:@selector(zxDeleteBtnAction:)])
    {
        [self.delegate zxDeleteBtnAction:sender];
    }
    [self.picBtn setImage:nil forState:UIControlStateNormal];
    self.origContainerView.hidden = [self.picBtn currentImage];
    self.deleteBtn.hidden = !self.origContainerView.hidden;
}
@end

//
//  ZXAssistiveTouch.m
//  YiShangbao
//
//  Created by simon on 17/4/11.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAssistiveTouch.h"

#ifndef LCDW
#define LCDW ([[UIScreen mainScreen] bounds].size.width)
#define LCDH ([[UIScreen mainScreen] bounds].size.height)
//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#define LCDScale_iPhone6(X)    ((X)*LCDW/375)
#endif


@implementation ZXAssistiveTouch

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)showAssistiveTouchAddedTo:(UIView *)view animated:(BOOL)animated
{
    ZXAssistiveTouch *hud = [[self alloc] initWithView:view];
    [view addSubview:hud];
//    [hud showAnimated:animated];
    return hud;
}


+ (ZXAssistiveTouch *)assistiveTouchForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (ZXAssistiveTouch *)subview;
        }
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:CGRectMake(LCDW-60, LCDH-49-100, 50, 50)];
}

#pragma mark - Lifecycle

- (void)commonInit {
  
     [self setupViews];

    
    //        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
    //        [_button addGestureRecognizer:pan];

}

- (void)setupViews
{
    //让它一直存在
    //        self.windowLevel = UIWindowLevelAlert +1;
    //        [self makeKeyAndVisible];
    self.layer.cornerRadius = CGRectGetWidth(self.bounds)/2;
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    //如果在这里添加事件，可以全局使用
    //        [_button addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];

}





//按钮事件
-(void)choose
{
}

- (void)changePostion:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self];
    
    CGRect originalFrame = self.frame;
    if (originalFrame.origin.x >=0 && originalFrame.origin.x+originalFrame.size.width <=LCDW)
    {
        originalFrame.origin.x += point.x;
    }
    if (originalFrame.origin.y >= 64 && originalFrame.origin.y+originalFrame.size.height <= LCDH-49)
    {
        originalFrame.origin.y += point.y;
    }
    self.frame = originalFrame;
    
    [pan setTranslation:CGPointZero inView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _button.enabled = NO;
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
    }
    else
    {
        CGRect frame = self.frame;
        //记录是否越界
        BOOL isOver = NO;
        
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
            isOver = YES;
        }
        else if (frame.origin.x+frame.size.width > LCDW)
        {
            frame.origin.x = LCDW - frame.size.width;
            isOver = YES;
        }
        
        if (frame.origin.y < 0) {
            frame.origin.y = 0;
            isOver = YES;
        } else if (frame.origin.y+frame.size.height > LCDH) {
            frame.origin.y = LCDH - frame.size.height;
            isOver = YES;
        }
        if (isOver) {
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = frame;
            }];
        }
        _button.enabled = YES;
    }
}
@end


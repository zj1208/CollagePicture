//
//  ZXInputBarView.m
//  Baby
//
//  Created by simon on 16/2/23.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "ZXInputBarView.h"

#ifndef UIColorFromRGB
#define UIColorFromRGB(A,B,C)  [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]
#endif

@interface ZXInputBarView ()

@property (nonatomic, strong) UIView *putView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end


@implementation ZXInputBarView


- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self setupLaysubviews];
        [self registerForKeyboardNotifications];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self)
    {
        [self setupLaysubviews];
        [self registerForKeyboardNotifications];
    }
    return self;
}

- (void)setupLaysubviews
{
//    self.putView = [[UIView alloc] init];
//    self.putView.backgroundColor = UIColorFromRGB(213.,228.,229.);
    self.backgroundColor = UIColorFromRGB(213.,228.,229.);
    
    self.textView = [[ZXPlaceholdTextView  alloc] init];
    self.textView.placeholder =nil;
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 4;
    
//    [self.putView addSubview: self.textView];
//    [self addConstraint:self.textView toItem:self.putView];

    [self addSubview: self.textView];
    [self addConstraint:self.textView toItem:self];
}


- (void)addConstraint:(UIView *)item toItem:(UIView *)superView
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0)
    {
        UILayoutGuide *layoutGuide_superView = superView.layoutMarginsGuide;
        //  设置View的top 与 superView的top的间距 = magrin 8
        NSLayoutConstraint *constraint_top = [item.topAnchor constraintEqualToAnchor:layoutGuide_superView.topAnchor];
        NSLayoutConstraint *constraint_bottom = [item.bottomAnchor constraintEqualToAnchor:layoutGuide_superView.bottomAnchor];
        NSLayoutConstraint *constraint_leading = [item.leadingAnchor constraintEqualToAnchor:layoutGuide_superView.leadingAnchor];
        NSLayoutConstraint *constraint_centerX = [item.centerXAnchor constraintEqualToAnchor:layoutGuide_superView.centerXAnchor];
        [NSLayoutConstraint activateConstraints:@[constraint_top,constraint_bottom,constraint_leading,constraint_centerX]];
    }
    else
    {
        //top 间距
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:8];
//        [superView addConstraint:constraint1];
        constraint1.active = YES;
        
        //Y的center
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
//        [superView addConstraint:constraint2];
        constraint2.active = YES;
        
        //右间距
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1 constant:-6];
//        [superView addConstraint:constraint3];
        constraint3.active = YES;
        
        //x的center
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
//        [superView addConstraint:constraint4];
        constraint4.active = YES;
    }
}

- (void)showInputBarView
{
    [self showInputBarViewWithIndexPath:nil];
}

- (void)showInputBarViewWithIndexPath:(nullable NSIndexPath *)aIndexPath
{
    UIWindow *view = [[[UIApplication sharedApplication] delegate] window];
    ZXOverlay *overlay = [[ZXOverlay alloc] initWithFrame:view.frame];
    overlay.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    overlay.delegate = self;
    [view addSubview:overlay];
//    [overlay addSubview:self.putView];
//    self.putView.hidden = YES;
//    self.putView.frame =CGRectMake(0, CGRectGetMaxY(view.frame)-50, CGRectGetWidth(view.frame), 50);
    [overlay addSubview:self];
    self.hidden = YES;
    self.frame =CGRectMake(0, CGRectGetMaxY(view.frame)-50, CGRectGetWidth(view.frame), 50);
    if ([self.textView canBecomeFirstResponder])
    {
        [self.textView becomeFirstResponder];
    }
    if (aIndexPath)
    {
        self.indexPath = aIndexPath;
    }
}


- (void)zxOverlaydissmissAction
{
    if ([self.textView isFirstResponder])
    {
        [self.textView resignFirstResponder];
    }
}



#pragma mark-KeyboardNotification
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
//    self.putView.hidden = NO;
    self.hidden = NO;

    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = rect.size.height;
    __weak __typeof(&*self)weakSelf = self;

    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
//        weakSelf.putView.transform = CGAffineTransformMakeTranslation(0, -ty);  //纯代码
        weakSelf.transform = CGAffineTransformMakeTranslation(0, -ty);  //纯代码

    }];
}


#pragma mark 键盘即将退出—与上面方法对应；
- (void)keyboardWillHide:(NSNotification *)noti
{
    
    __weak __typeof(&*self)weakSelf = self;
//    self.putView.hidden = YES;
    self.hidden = YES;
    
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:duration animations:^{
        
//        weakSelf.putView.transform = CGAffineTransformIdentity; //纯代码
//        weakSelf.putView.superview.alpha = 0;
        weakSelf.transform = CGAffineTransformIdentity; //纯代码
        weakSelf.superview.alpha = 0;
        
    } completion:^(BOOL finished) {
        
//        if ([weakSelf.putView.superview isKindOfClass:[ZXOverlay class]])
//        {
//            [weakSelf.putView.superview removeFromSuperview];
//        }
//        [weakSelf.putView removeFromSuperview];
        if ([weakSelf.superview isKindOfClass:[ZXOverlay class]])
        {
            [weakSelf.superview removeFromSuperview];
        }
        [weakSelf removeFromSuperview];
        
    }];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
//        NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
//        if ([textView.text stringByTrimmingCharactersInSet:whitespace].length==0)
//        {
//            return NO;
//        }
        if ([textView isFirstResponder])
        {
            [textView resignFirstResponder];
            if ([self.delegate respondsToSelector:@selector(zxInputBarViewSendContentWithInputView:text:indexPath:)])
            {
                [self.delegate zxInputBarViewSendContentWithInputView:self text:textView.text indexPath:self.indexPath];
                textView.text = nil;
            }
        }
    }
    
    return YES;
}

@end

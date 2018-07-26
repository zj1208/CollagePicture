//
//  ZXPlaceholdTextView.h
//  YiShangbao
//
//  Created by simon on 17/4/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  待优化：（1）当文本内容所需要的contentSize超过textView当前的frame，滑动时候的文本会在顶部越过，如同inset效果，边距没有了，占位符lable文字内容超过textView的frame时候也如此； 其它应用也如此，不知道是否需要优化？

//  2018.4.27 修改举例注释
//  2018.5.24 block 造成的循环引用；还有海狮调用的一些没有释放；
//  7.4 修改约束便利方法，bottom增加小于等于10间距；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXPlaceholdTextView;

typedef void (^TextDidChangeBlock)(ZXPlaceholdTextView *textView,NSUInteger remainCount);

@interface ZXPlaceholdTextView : UITextView



@property (nonatomic, copy, nullable) NSString *placeholder;

@property (nonatomic, strong, nullable) UIColor *placeholderColor;

@property (nonatomic, assign) NSUInteger maxCharacters;


-(void)setMaxCharacters:(NSUInteger)maxLength textDidChange:(TextDidChangeBlock)limitBlock;

@end

NS_ASSUME_NONNULL_END
/*
 
 @property (weak, nonatomic) IBOutlet ZXPlaceholdTextView *textView;
 @property (weak, nonatomic) IBOutlet UILabel *remainLab;
 @property (weak, nonatomic) IBOutlet UIView *containerTextView;

 
- (void)viewDidLoad
{
 
    [self.containerTextView zx_setCornerRadius:2.f borderWidth:1.f borderColor:UIColorFromRGB_HexValue(0xE1E1E1)];

    self.textView.text = nil;
    _remainLab.text =@"还可输入200字";
    self.textView.placeholder = @"请输入规格尺寸，多个尺寸用“逗号”分隔；";
    WS(weakSelf);
 
    [self.textView setMaxCharacters:200 textDidChange:^(ZXPlaceholdTextView *textView, NSUInteger remainCount) {
 
        // NSLog(@"%ld",remainCount);
        weakSelf.remainLab.text = [NSString stringWithFormat:@"还可输入%ld字",remainCount];
    }];
 
}
*/

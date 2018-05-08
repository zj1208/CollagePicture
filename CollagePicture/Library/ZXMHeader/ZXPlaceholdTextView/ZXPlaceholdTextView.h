//
//  ZXPlaceholdTextView.h
//  YiShangbao
//
//  Created by simon on 17/4/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  2018.4.27 修改举例注释

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
 
    [self.containerTextView zh_setCornerRadius:2.f borderWidth:1.f borderColor:UIColorFromRGB_HexValue(0xE1E1E1)];

    self.textView.text = nil;
    _remainLab.text =@"还可输入200字";
    self.textView.placeholder = @"请输入规格尺寸，多个尺寸用“逗号”分隔；";
    [self.textView setMaxCharacters:200 textDidChange:^(ZXPlaceholdTextView *textView, NSUInteger remainCount) {
 
        // NSLog(@"%ld",remainCount);
        _remainLab.text = [NSString stringWithFormat:@"还可输入%ld字",remainCount];
    }];
 
}
*/

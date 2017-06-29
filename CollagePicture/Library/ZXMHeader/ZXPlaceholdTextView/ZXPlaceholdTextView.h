//
//  ZXPlaceholdTextView.h
//  YiShangbao
//
//  Created by simon on 17/4/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXPlaceholdTextView;

typedef void (^TextDidChangeBlock)(ZXPlaceholdTextView *textView,NSUInteger remainCount);

@interface ZXPlaceholdTextView : UITextView



@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, assign) NSUInteger maxCharacters;


-(void)setMaxCharacters:(NSUInteger)maxLength textDidChange:(TextDidChangeBlock)limitBlock;
@end

/*
- (void)viewDidLoad
{
    self.textView.text = nil;
    _remainLab.text =@"还可输入200字";
    self.textView.placeholder = @"请输入规格尺寸，多个尺寸用“逗号”分隔；";
    [self.textView setMaxCharacters:200 textDidChange:^(ZXPlaceholdTextView *textView, NSUInteger remainCount) {
 
        // NSLog(@"%ld",remainCount);
        _remainLab.text = [NSString stringWithFormat:@"还可输入%ld字",remainCount];
    }];
 
}
*/

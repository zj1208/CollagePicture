//
//  ZXPlaceholdTextView.m
//  YiShangbao
//
//  Created by simon on 17/4/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXPlaceholdTextView.h"



@interface ZXPlaceholdTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) UILabel *countLabel;

@property(copy,nonatomic) TextDidChangeBlock textDidChangeBlock;

@end




@implementation ZXPlaceholdTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
//  [self commonInit];
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // 垂直方向上永远有弹簧效果
    self.alwaysBounceVertical = YES;
    // 默认字体
    self.font = [UIFont systemFontOfSize:15];
    // 默认的占位文字颜色
    self.placeholderColor = [UIColor colorWithRed:194.f/255.0f green:194.f/255.0f blue:194.f/255.0f alpha:1.0f];
    // 监听文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginAndEndEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginAndEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
    [self setupViews];
}

- (void)setupViews
{
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.font = self.font;
    [self addSubview:placeholderLabel];
    
    _placeholderLabel = placeholderLabel;
    // 默认的占位文字颜色
    _placeholderLabel.textColor =self.placeholderColor;
    
    [self addConstraint:_placeholderLabel toSuperviewItem:self];

}

- (void)addConstraint:(UIView *)item toSuperviewItem:(UIView *)superView
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:10];
    [self addConstraint:constraint1];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1 constant:5];
    [self addConstraint:constraint3];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self addConstraint:constraint4];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)setMaxCharacters:(NSUInteger)maxLength textDidChange:(TextDidChangeBlock)limitBlock
{
    if (maxLength>0)
    {
        _maxCharacters = maxLength;
    }
    if (limitBlock)
    {
        _textDidChangeBlock=limitBlock;
    }
}



#pragma mark-dealloc 移除通知

- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- textView编辑的三种通知

- (void)textBeginAndEndEditing:(id)notification
{
//    if ([self isFirstResponder])
//    {
//        self.placeholderLabel.hidden = YES;
//    }
//    else
//    {
//        self.placeholderLabel.hidden = self.hasText;
//    }
}

- (void)textDidChange:(id)noti
{
//    if ([self isFirstResponder])
//    {
//        if (self.hasText)
//        {
//            self.placeholderLabel.hidden = YES;
//        }
//    }
//    else
//    {
//        self.placeholderLabel.hidden = self.hasText;
//    }
    self.placeholderLabel.hidden = self.hasText;
    
    NSString *lang = [[self.nextResponder textInputMode] primaryLanguage]; // 键盘输入模式
    if (self.maxCharacters >0)
    {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        if ([lang isEqualToString:@"zh-Hans"])
        {
            UITextRange *selectedRange = [self markedTextRange];
            //获取高亮部分
            UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position)
            {
                if (self.text.length > self.maxCharacters) {
                    self.text = [self.text substringToIndex:self.maxCharacters];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else
            {
                
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else
        {
            if (self.text.length > self.maxCharacters)
            {
                self.text = [ self.text substringToIndex:self.maxCharacters];
            }
        }
//        void (^limint)(ZXPlaceholdTextView*textView) =_textDidChangeBlock;

        _textDidChangeBlock(self,self.maxCharacters - [self.text length]);
 
    }

}


#pragma mark - 设置文本，字体，占位文本，占位文本颜色

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
    
    [self setNeedsLayout];
}


- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self setNeedsLayout];
}


- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setText:(NSString *)text
{
    //先回调text，才能改变系统内置属性；
    [super setText:text];
    [self textDidChange:nil];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self textDidChange:nil];
}
@end

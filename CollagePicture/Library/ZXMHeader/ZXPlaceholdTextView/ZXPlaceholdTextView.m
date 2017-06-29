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
//    [self commonInit];
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self commonInit];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self commonInit];
    return self;
}

- (void)commonInit {
    // 垂直方向上永远有弹簧效果
    self.alwaysBounceVertical = YES;
    // 默认字体
    self.font = [UIFont systemFontOfSize:15];
    // 默认的占位文字颜色
    // self.placeholderColor = [UIColor grayColor];
    // 监听文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginAndEndEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginAndEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
    [self setupViews];
//    [self layoutIfNeeded];
}

- (void)setupViews
{
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.font = self.font;
    
    //        placeholderLabel.zx_x = 4;
    //        placeholderLabel.zx_y = 7;
    [self addSubview:placeholderLabel];
    _placeholderLabel = placeholderLabel;
//    _placeholderLabel.text = @"uoruoiureour";
    // 默认的占位文字颜色
    _placeholderLabel.textColor = UIColorFromRGB_HexValue(0xC2C2C2);
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.mas_top).offset(7);
        make.left.mas_equalTo(self.mas_left).offset(4);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(100);
        
    }];

//    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-7);
//        make.left.mas_equalTo(self.mas_left).offset(10);
//        make.centerX.mas_equalTo(self.mas_centerX);
//        
//        
//    }];

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

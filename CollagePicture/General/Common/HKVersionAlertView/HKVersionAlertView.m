//
//  HKVersionAlertView.m
//  测试demo
//
//  Created by 何可 on 2017/4/12.
//  Copyright © 2017年 mac. All rights reserved.
//

static const void *TzgLeftActionBlockKey = &TzgLeftActionBlockKey;
static const void *TzgRightActionBlockKey = &TzgRightActionBlockKey;

#define AlertPadding 25
#define MessagePadding 50
#define MenuHeight 44

#define AlertHeight 330
#define AlertWidth ([UIScreen mainScreen].bounds.size.width-95)

#import "HKVersionAlertView.h"

@implementation HKVersionAlertView
-(instancetype)initWithMessage:(NSString *)message version:(NSString *)version closeButton:(BOOL)close{
    self = [super init];
    if (self) {
        _message = message;
        _version = version;
        _closeBool = close;
        [self buildViews];
    }
    return self;
}


-(void)buildViews{
    //添加背景
    self.frame = [self screenBounds];
    _coverView = [[UIView alloc] initWithFrame:[self topView].bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0;
    _coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[self topView] addSubview:_coverView];
    
    //更新提示框
    _alertView = [[UIView alloc] init];
//    _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AlertWidth, AlertHeight)];
//    _alertView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _alertView.layer.cornerRadius = 10;
    _alertView.layer.masksToBounds = YES;
    _alertView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_alertView];
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@330);
        make.width.equalTo(@280);
    }];
    
    //更新提示图
    _imageView = [[UIImageView alloc] init];
//    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -15, 280, 134)];
//    _imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-165);
    _imageView.image = [UIImage imageNamed:@"bg_xinbanben_tittle"];
    [self addSubview:_imageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_alertView.mas_top).offset(-10);
        make.centerX.equalTo(_alertView.mas_centerX);
        make.width.equalTo(@280);
        make.height.equalTo(@121.5);
    }];
    
    _labelVersion = [[UILabel alloc] init];
    [self addSubview:_labelVersion];
    _labelVersion.font = [UIFont systemFontOfSize:15];
    _labelVersion.textColor = [UIColor colorWithRed:0.98 green:0.33 blue:0.33 alpha:1];
    _labelVersion.text = [NSString stringWithFormat:@"V%@",_version];
    
    [_labelVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_imageView.mas_bottom).offset(-22);
        make.right.equalTo(_imageView.mas_left).offset(90);
    }];
    
    
    //设置更新内容样式
    if (_message) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_message];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];//设置行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_message length])];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [_message length])];
        
        CGFloat labelHeight = [self heightWithString:_message style:paragraphStyle font:[UIFont systemFontOfSize:14] width:232];
        _labelMessage = [[UILabel alloc] init];
        _labelMessage =  [[UILabel alloc]initWithFrame:CGRectMake(AlertPadding, 110, 232, labelHeight)];
        _labelMessage.font = [UIFont systemFontOfSize:14];//内容字体
        _labelMessage.textColor = [UIColor blackColor];//内容颜色
        _labelMessage.textAlignment = NSTextAlignmentCenter;//内容字段格式
        _labelMessage.attributedText = attributedString;
        _labelMessage.numberOfLines = 0;
        _labelMessage.lineBreakMode = NSLineBreakByCharWrapping;
        [_alertView addSubview:_labelMessage];
        [_labelMessage sizeToFit];
        
//        [_labelMessage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_imageView.mas_bottom);
//            make.centerX.equalTo(_alertView.mas_centerX);
//            make.width.equalTo(@232);
//            make.height.equalTo(@(labelHeight));
//        }];
        
        [_alertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(111.5+20+20+45+30+labelHeight));
        }];
    }
    
    
    //确认按钮
    _confirmButton = [[UIButton alloc] init];
    [_alertView addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(_alertView.mas_bottom).offset(-30);
    }];
    [_confirmButton setImage:[UIImage imageNamed:@"btn_xinbanben"] forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
   
    
    //关闭按钮
    if (_closeBool) {
//        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"btn_xinbanbenclose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_alertView.mas_bottom).offset(10);
            make.centerX.equalTo(self.mas_centerX);
            make.height.equalTo(@50);
            make.width.equalTo(@50);
        }];
    }

    

}

- (void)addConfirmButton:(ButtonBlock)buttonAction{
    objc_setAssociatedObject(self, TzgLeftActionBlockKey, buttonAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)addCloseButton:(ButtonBlock)buttonAction{
    objc_setAssociatedObject(self, TzgRightActionBlockKey, buttonAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)confirmButtonAction{
    ButtonBlock block = objc_getAssociatedObject(self, TzgLeftActionBlockKey);
    if (block) {
        block();
    }
}

- (void)closeButtonAction{
    [self dismiss];
    
    ButtonBlock block = objc_getAssociatedObject(self, TzgRightActionBlockKey);
    if (block) {
        block();
    }
}
#pragma mark - 字段格式
- (CGFloat)heightWithString:(NSString*)string style:(NSMutableParagraphStyle *)style font:(UIFont *)font width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:style};
    return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}

#pragma mark - show and dismiss
- (CGRect)screenBounds
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGRectMake(0, 0, screenWidth, screenHeight);
}

-(UIView*)topView{
    return  [[[UIApplication sharedApplication] delegate] window];
}
- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];
    
    [[self topView] addSubview:self];
//    [self showAnimation];
}

- (void)dismiss {
    [self hideAnimation];
}

- (void)showAnimation {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.5;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_alertView.layer addAnimation:popAnimation forKey:nil];
}

- (void)hideAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        _coverView.alpha = 0.0;
        _alertView.alpha = 0.0;
        _imageView.alpha = 0.0;
        _labelVersion.alpha = 0.0;
        _closeButton.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end

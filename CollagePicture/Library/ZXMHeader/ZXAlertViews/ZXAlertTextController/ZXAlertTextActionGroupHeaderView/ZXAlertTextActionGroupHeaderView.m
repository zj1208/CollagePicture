//
//  ZXAlertTextActionGroupHeaderView.m
//  MobileCaiLocal
//
//  Created by 朱新明 on 2020/2/17.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import "ZXAlertTextActionGroupHeaderView.h"
#import "Masonry.h"

@implementation ZXAlertTextActionGroupHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:LCDScale_iPhone6(20) weight:UIFontWeightSemibold];
        label.textColor = [UIColor colorWithRed:52.f/255 green:55.f/255 blue:58.f/255 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:LCDScale_iPhone6(20) weight:UIFontWeightSemibold];
        label.textColor = [UIColor colorWithRed:52.f/255 green:55.f/255 blue:58.f/255 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        _messageLabel = label;
    }
    return _messageLabel;
}

- (void)setUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).with.offset(LCDScale_iPhone6(20));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).with.offset(LCDScale_iPhone6(20));
    }];
        
}


- (void)creatMessageLabel:(NSString *)message
{
    if (message) {
        [self addSubview:self.messageLabel];
        
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.mas_left).with.offset(LCDScale_iPhone6(20));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(LCDScale_iPhone6(20));
        }];
    }
}

- (CGFloat)getHeaderHeight
{
//    return CGRectGetMaxY(self.messageLabel.frame);
    return LCDScale_iPhone6(68.f);
}
@end

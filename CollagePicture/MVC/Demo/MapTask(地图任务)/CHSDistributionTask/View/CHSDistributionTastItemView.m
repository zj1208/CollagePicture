//
//  CHSDistributionTastItemView.m
//  CollagePicture
//
//  Created by simon on 2020/4/30.
//  Copyright © 2020 zxm. All rights reserved.
//

#import "CHSDistributionTastItemView.h"

@interface CHSDistributionTastItemView ()

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *timeIconImageView;
@property (nonatomic, strong) UIImageView *tastIconImageView;
@property (nonatomic, strong) UIImageView *locationIconImageView;


@end

@implementation CHSDistributionTastItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self zx_setBorderWithShadowWithCornerRadius:10 borderWidth:1 borderColor:nil];
    [self zx_setShadowColor:[UIColor zx_colorWithHexString:@"#D7DCE4"] shadowOpacity:0.94 shadowOffset:CGSizeMake(0, 0) shadowRadius:3];
    [self addSubview:self.photoImageView];
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(LCDScale_iPhone6(12));
        make.top.mas_equalTo(self.mas_top).offset(LCDScale_iPhone6(15));
        make.width.height.mas_equalTo(LCDScale_iPhone6(48));
    }];
    
    [self.photoImageView addSubview:self.shopIdLabel];
    [self.shopIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.photoImageView.mas_left);
        make.centerX.mas_equalTo(self.photoImageView.mas_centerX);
        make.bottom.mas_equalTo(self.photoImageView.mas_bottom);
        make.height.mas_equalTo(LCDScale_iPhone6(15));
    }];
    
    [self addSubview:self.mapBtn];
    
    [self.mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-LCDScale_iPhone6(15-4));
        make.centerY.mas_equalTo(self.photoImageView.mas_centerY);
        make.width.height.mas_equalTo(LCDScale_iPhone6(32+8));
    }];
    
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.photoImageView.mas_right).offset(LCDScale_iPhone6(5));
        make.centerY.mas_equalTo(self.photoImageView.mas_centerY);
        make.right.mas_lessThanOrEqualTo(self.mapBtn.mas_left).offset(-LCDScale_iPhone6(15));
    }];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.photoImageView.mas_left);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.photoImageView.mas_bottom).offset(LCDScale_iPhone6(15));
    }];
    
    [self addSubview:self.timeIconImageView];
    [self.timeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.line.mas_left);
        make.top.mas_equalTo(self.line.mas_bottom).offset(LCDScale_iPhone6(15));
    }];
    
    [self addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.timeIconImageView.mas_right).offset(2);
        make.centerY.mas_equalTo(self.timeIconImageView.mas_centerY);
        make.right.mas_lessThanOrEqualTo(self.mas_right).offset(-LCDScale_iPhone6(15));
    }];
    
    [self addSubview:self.tastIconImageView];
    [self.tastIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.line.mas_left);
        make.top.mas_equalTo(self.timeIconImageView.mas_bottom).offset(LCDScale_iPhone6(11));
    }];
    [self addSubview:self.tastLab];
    [self.tastLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.tastIconImageView.mas_right).offset(2);
        make.centerY.mas_equalTo(self.tastIconImageView.mas_centerY);
    }];
    
    [self addSubview:self.tastDetaiBtn];
    [self.tastDetaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.tastLab.mas_right).offset(LCDScale_iPhone6(10));
        make.centerY.mas_equalTo(self.tastIconImageView.mas_centerY);
    }];
    
    [self addSubview:self.locationIconImageView];
    [self.locationIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(self.line.mas_left);
        make.top.mas_equalTo(self.tastIconImageView.mas_bottom).offset(LCDScale_iPhone6(11));
        make.width.height.mas_equalTo(20);
    }];

    [self addSubview:self.locationLab];
    [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(self.locationIconImageView.mas_right).offset(2);
        make.top.mas_equalTo(self.locationIconImageView.mas_top);
        make.right.mas_lessThanOrEqualTo(self.mas_right).offset(-LCDScale_iPhone6(15));
    }];
    
    
    [self addSubview:self.doBtn];
    [self.doBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.mas_equalTo(LCDScale_iPhone6(150));
        make.height.mas_equalTo(LCDScale_iPhone6(40));
        make.right.mas_equalTo(self.mas_right).offset(-LCDScale_iPhone6(15));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-LCDScale_iPhone6(15));
    }];
    
    [self addSubview:self.callBtn];
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).offset(22);
        make.width.mas_equalTo(46);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-LCDScale_iPhone6(15));
        make.centerY.mas_equalTo(self.doBtn.mas_centerY);
    }];
    
    [self addGestureRecognizer:[self tapGesture]];
}

- (UIImageView *)photoImageView
{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        [_photoImageView zx_setBorderWithCornerRadius:5 borderWidth:1 borderColor:nil];
        #ifdef DEBUG
        _photoImageView.backgroundColor =[UIColor colorWithWhite:0.9 alpha:1];
        #endif
    }
    return _photoImageView;
}

- (UILabel *)shopIdLabel
{
    if (!_shopIdLabel) {
        UILabel *lab  = [[UILabel alloc] init];
        lab.font = [UIFont zx_systemFontOfScaleSize:9];
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = [UIColor colorWithWhite:0 alpha:0.65];
#ifdef DEBUG
        lab.text = @"122333";
#endif
        _shopIdLabel = lab;
    }
    return _shopIdLabel;
}
- (UIButton *)mapBtn
{
    if (!_mapBtn) {
        UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"map_icon"] forState:UIControlStateNormal];
        _mapBtn = btn;
    }
    return _mapBtn;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        UILabel *lab  = [[UILabel alloc] init];
        lab.numberOfLines = 2;
        lab.font = [UIFont zx_systemFontOfScaleSize:16];
        lab.textColor = [UIColor zx_colorWithHexString:@"#333333"];
#ifdef DEBUG
        lab.text = @"菜划算进货阿里麻麻中心店";
#endif
        _titleLab = lab;
    }
    return _titleLab;
}

- (UIView *)line
{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor zx_colorWithHexString:@"#EEEEEE"];
    }
    return _line;
}

- (UIImageView *)timeIconImageView
{
    if (!_timeIconImageView) {
        UIImageView *view  = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"map_time_icon"];
        _timeIconImageView = view;
    }
    return _timeIconImageView;
}

- (UILabel *)timeLab
{
    if (!_timeLab) {
        UILabel *lab  = [[UILabel alloc] init];
        lab.font = [UIFont zx_systemFontOfScaleSize:14];
        lab.textColor = [UIColor zx_colorWithHexString:@"#333333"];
#ifdef DEBUG
        lab.text = @"03-21 07:00~9:00";
#endif
        _timeLab = lab;
    }
    return _timeLab;
}

- (UIImageView *)tastIconImageView
{
    if (!_tastIconImageView) {
        UIImageView *view  = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"map_tast_icon"];
        _tastIconImageView = view;
    }
    return _tastIconImageView;
}

- (UILabel *)tastLab
{
    if (!_tastLab) {
        UILabel *lab  = [[UILabel alloc] init];
        lab.font = [UIFont zx_systemFontOfScaleSize:14];
        lab.textColor = [UIColor zx_colorWithHexString:@"#333333"];
#ifdef DEBUG
        lab.text = @"待配送";
#endif
        _tastLab = lab;
    }
    return _tastLab;
}


- (UIButton *)tastDetaiBtn
{
    if (!_tastDetaiBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *att = [[NSAttributedString alloc] initWithString:@"有待取件任务" attributes:@{NSForegroundColorAttributeName:[UIColor zx_colorWithHexString:@"#FF861B"],NSFontAttributeName:[UIFont zx_systemFontOfScaleSize:14],NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
        [btn setAttributedTitle:att forState:UIControlStateNormal];
        btn.hidden = YES;
        _tastDetaiBtn = btn;
    }
    return _tastDetaiBtn;;
}

- (UIImageView *)locationIconImageView
{
    if (!_locationIconImageView) {
        UIImageView *view  = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"map_location_icon"];
        _locationIconImageView = view;
    }
    return _locationIconImageView;
}

- (UILabel *)locationLab
{
    if (!_locationLab) {
        UILabel *lab  = [[UILabel alloc] init];
        lab.numberOfLines = 2;
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = [UIFont zx_systemFontOfScaleSize:14];
        lab.textColor = [UIColor zx_colorWithHexString:@"#333333"];
#ifdef DEBUG
        lab.text = @"浙江省杭州市滨江区网商路阿里 中心3栋606室";
#endif
        _locationLab = lab;
    }
    return _locationLab;
}


- (UIButton *)doBtn
{
    if (!_doBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *att = [[NSAttributedString alloc] initWithString:@"确认送达" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont zx_systemFontOfScaleSize:16]}];
        [btn setAttributedTitle:att forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor zx_colorWithHexString:@"#307DF4"];
        [btn zx_setBorderWithCornerRadius:10 borderWidth:1 borderColor:nil];
        _doBtn = btn;
    }
    return _doBtn;
}

- (UIButton *)callBtn
{
    if (!_callBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIFont *font = [UIFont zx_systemFontOfScaleSize:10];
        NSAttributedString *att = [[NSAttributedString alloc] initWithString:@"电话联系" attributes:@{NSForegroundColorAttributeName:[UIColor zx_colorWithHexString:@"#333333"]}];
        [btn setAttributedTitle:att forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"map_location_icon"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = font;
        _callBtn = btn;
    }
    return _callBtn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.callBtn zx_centerVerticalImageAndTitleWithSpace:5];
}

- (UITapGestureRecognizer *)tapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerAction:)];
    return tapGesture;
}

- (void)tapRecognizerAction:(UITapGestureRecognizer *)gesture
{
    if (self.itemClickBlock) {
        self.itemClickBlock();
    }
}

- (void)setData:(id)data
{
    BOOL flag = YES;
    if ([data isKindOfClass:[NSDictionary class]]) {
        flag = [data[@"status"]integerValue] == 1 ?YES:NO;
    }
    self.doBtn.userInteractionEnabled =flag;
    self.doBtn.alpha = flag?1:0.4;
    NSString *title = flag ? @"确认送达":@"已完成";
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont zx_systemFontOfScaleSize:16]}];
    [self.doBtn setAttributedTitle:att forState:UIControlStateNormal];
    self.tastLab.text = flag ? @"待配送" : @"已完成";
    self.tastDetaiBtn.hidden = flag;
}
@end


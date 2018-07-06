//
//  TableViewUnfoldFooterView.m
//  YiShangbao
//
//  Created by simon on 2018/4/27.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "TableViewUnfoldFooterView.h"

@implementation TableViewUnfoldFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.arrUpImageView.hidden = YES;
}

- (IBAction)footerBtnAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    self.arrUpImageView.hidden = !btn.selected;
    self.arrDownImageView.hidden = btn.selected;
    if (!self.arrUpImageView.hidden)
    {
        self.titleLab.text = NSLocalizedString(@"收回", nil);
    }
    else
    {
        self.titleLab.text = NSLocalizedString(@"完善更多信息", nil);
    }
    if (self.footerActionBlock)
    {
        self.footerActionBlock(btn);
    }
}
@end

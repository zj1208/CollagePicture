//
//  ZXActionTitleView.h
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：设置左侧button按钮，图片+文字，可以添加action事件； 可以自定义设置左侧边距；
//
//  2018.01.10
//  增加注释；

#import <UIKit/UIKit.h>

static NSString *const nibName_ZXActionTitleView = @"ZXActionTitleView";


@interface ZXActionTitleView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btn;

//设置button左边间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnLayoutLeft;

+ (id)viewFromNib;
@end


/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section ==0)
    {
        ZXActionTitleView * titleView = [[[NSBundle mainBundle] loadNibNamed:@"ZXActionTitleView" owner:self options:nil] firstObject];
        [titleView.btn setTitle:@"让客流量暴增100倍的方法>>" forState:UIControlStateNormal];
        [titleView.btn setTitleColor:UIColorFromRGB_HexValue(0x00A3EE) forState:UIControlStateNormal];
        titleView.backgroundColor =WYUISTYLE.colorBGgrey;
        [titleView.btn addTarget:self action:@selector(titleViewAction:) forControlEvents:UIControlEventTouchUpInside];
        return titleView;
    }
    
    if (section ==5)
    {
        ZXActionTitleView * titleView = [[[NSBundle mainBundle] loadNibNamed:@"ZXActionTitleView" owner:self options:nil] firstObject];
        [titleView.btn setTitle:@"带*为必填项" forState:UIControlStateNormal];
        titleView.backgroundColor =WYUISTYLE.colorBGgrey;
        titleView.btn.userInteractionEnabled = NO;
        return titleView;
    }
    return nil;
}

*/

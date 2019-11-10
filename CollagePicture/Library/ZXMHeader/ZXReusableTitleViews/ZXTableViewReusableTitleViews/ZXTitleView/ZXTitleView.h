//
//  ZXTitleView.h
//  YiShangbao
//
//  Created by simon on 16/12/8.
//  Copyright © 2016年 com.Microants. All rights reserved.
//
//  简介：设置左侧图标+标题文字； 与左侧边距是12，可以删除左侧图标，文字离左侧边距依然是12；
//       默认Xib的背景色是透明的；
//
//  2018.03.19
//  增加底部线条；

#import <UIKit/UIKit.h>
#import "ZXCenterTitleView.h"
#import "ZXActionTitleView.h"
#import "ZXActionAdditionalTitleView.h"

static NSString *const nibName_ZXTitleView = @"ZXTitleView";


@interface ZXTitleView : UIView

// 左侧文字
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

// 左侧图标
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

// 底部线条,默认隐藏
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

//设置textlabel与superView左对齐的约束偏移,默认constant=12;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabLeadingSuperViewLayoutConstraint;


+ (id)viewFromNib;


@end



/*
 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==2)
    {
        ZXTitleView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXTitleView owner:self options:nil] firstObject];
        view.textLabel.text =@"常用标签";
        view.textLabel.font = [UIFont systemFontOfSize:14];
        view.backgroundColor =tableView.backgroundColor;
        return view;
    }
    return [[UIView alloc] init]; //如果有组头高度，则返回view，以免默认背景颜色和tableView（自己设置了背景色）不同；
}

// 如果不要左边的图片; [view.leftImageView removeFromSuperview];
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataMArray.count ==0)
    {
        return [[UIView alloc] init];
    }
    ZXTitleView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXTitleView owner:self options:nil] firstObject];
    NSString *string = [NSString stringWithFormat:@"今日新增%@位粉丝，共%@位粉丝关注商铺!",_todayAddCount,_totalCount];
    view.textLabel.text =string;
    view.textLabel.font = [UIFont systemFontOfSize:12];
    [view.leftImageView removeFromSuperview];
    view.backgroundColor =tableView.backgroundColor;
    return view;
}
*/

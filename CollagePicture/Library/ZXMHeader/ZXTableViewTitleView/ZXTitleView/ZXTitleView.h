//
//  ZXTitleView.h
//  YiShangbao
//
//  Created by simon on 16/12/8.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXCenterTitleView.h"
#import "ZXActionTitleView.h"
#import "ZXActionAdditionalTitleView.h"

static NSString *const nibName_ZXTitleView = @"ZXTitleView";

// 设置左侧图标+标题文字； 可以删除左侧图标；
@interface ZXTitleView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@end



/*
 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==2)
    {
        ZXTitleView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXTitleView owner:self options:nil] firstObject];
        view.titleLab.text =@"常用标签";
        view.titleLab.font = [UIFont systemFontOfSize:14];
        view.backgroundColor =WYUISTYLE.colorBGgrey;
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
    view.titleLab.text =string;
    view.titleLab.font = [UIFont systemFontOfSize:12];
    [view.leftImageView removeFromSuperview];
    view.backgroundColor =WYUISTYLE.colorBGgrey;
    return view;
}
*/

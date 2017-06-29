//
//  WYTitleView.h
//  YiShangbao
//
//  Created by Lance on 16/12/8.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXCenterTitleView.h"
#import "ZXActionTitleView.h"

static NSString *nibName_WYTitleView = @"WYTitleView";


@interface WYTitleView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@end

/*
 //如果不要左边的图片，添加
 [view.leftImageView removeFromSuperview];
 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==2)
    {
        WYTitleView * view = [[[NSBundle mainBundle] loadNibNamed:@"WYTitleView" owner:self options:nil] lastObject];
        view.titleLab.text =@"常用标签";
        view.titleLab.font = [UIFont systemFontOfSize:14];
        view.backgroundColor =WYUISTYLE.colorBGgrey;
        return view;
        
    }
    return [[UIView alloc] init]; //如果有组头高度，则返回view，以免默认背景颜色和tableView（自己设置了背景色）不同；
}
*/


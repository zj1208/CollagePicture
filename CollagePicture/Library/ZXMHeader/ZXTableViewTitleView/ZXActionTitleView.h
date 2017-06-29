//
//  ZXActionTitleView.h
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *nibName_ZXActionTitleView = @"ZXActionTitleView";


@interface ZXActionTitleView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btn;

//设置button左边间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnLayoutLeft;
@end

/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section ==0)
    {
        ZXActionTitleView * titleView = [[[NSBundle mainBundle] loadNibNamed:@"ZXActionTitleView" owner:self options:nil] lastObject];
        [titleView.btn setTitle:@"让浏览器暴增100倍的方法?" forState:UIControlStateNormal];
        titleView.backgroundColor =WYUISTYLE.colorBGgrey;
        [titleView.btn addTarget:self action:@selector(titleViewAction:) forControlEvents:UIControlEventTouchUpInside];
        return titleView;
    }
    return nil;
}

*/

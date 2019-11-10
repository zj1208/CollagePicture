//
//  ZXCenterTitleView.h
//  YiShangbao
//
//  Created by simon on 17/4/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：设置中间button按钮，图片+文字，按钮左右二边有0.5高度的线条； 可以自定义设置按钮宽度，线条是否隐藏；
//
//  2018.01.10
//  增加注释；

#import <UIKit/UIKit.h>

static NSString *const nibName_ZXCenterTitleView = @"ZXCenterTitleView";


@interface ZXCenterTitleView : UIView

// 中间按钮：可以设置图标+文字
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;

// 中间按钮宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerBtnWidthLayout;


@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;

// 设置隐藏线条
@property (nonatomic, assign) BOOL hideLineView;


+ (id)viewFromNib;
@end


//

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section ==2)
    {
        ZXCenterTitleView * view = [[[NSBundle mainBundle] loadNibNamed:@"ZXCenterTitleView" owner:self options:nil] firstObject];
        [view.centerBtn setTitle:@"上传照片" forState:UIControlStateNormal];
        [view.centerBtn setImage:[UIImage imageNamed:@"pic_shanghcuanzhaopian"] forState:UIControlStateNormal];
        view.centerBtnWidthLayout.constant = 80.f;
        [view.centerBtn zh_centerHorizontalImageAndTitleWithSpace:10.f];
        view.centerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        view.backgroundColor =WYUISTYLE.colorBGgrey;
        return view;
        
    }
    return [[UIView alloc] init];
}
 
 */

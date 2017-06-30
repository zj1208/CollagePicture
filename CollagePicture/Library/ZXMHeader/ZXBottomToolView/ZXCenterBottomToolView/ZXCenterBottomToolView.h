//
//  ZXCenterBottomToolView.h
//  YiShangbao
//
//  Created by simon on 17/2/26.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *nibName_ZXCenterBottomToolView = @"ZXCenterBottomToolView";


@interface ZXCenterBottomToolView : UIView

//按钮上下，左右居中显示
@property (weak, nonatomic) IBOutlet UIButton *onlyCenterBtn;

//左边距,居中显示
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerBtnLeadingLayout;

//上边距，居中显示
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerBtnTopLayout;
@end


//没有预先放底部栏父视图的时候；要调整tableView之间的约束；
/*
 
 
- (void)addBottomView
{
    ZXCenterBottomToolView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXCenterBottomToolView owner:self options:nil] lastObject];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(0);
        make.left.mas_equalTo(self.view.mas_left).with.offset(0);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(LCDScale_iphone6_Width(49.f));
    }];
    [view.onlyCenterBtn setTitle:@"发送给采购商" forState:UIControlStateNormal];
    [view.onlyCenterBtn setImage:[UIImage imageNamed:@"发送给采购商"] forState:UIControlStateNormal];
    [view.onlyCenterBtn addTarget:self action:@selector(postDataAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(view.mas_top).with.offset(0);
    }];
    
}
 
*/

//预先放好底部容器view的时候－推荐这种方法；


/*
- (void)setUI
{
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = WYUISTYLE.colorBGgrey;
    
    [self.tableView registerNib:[UINib nibWithNibName:Xib_CommonTradePersonalCell bundle:nil] forCellReuseIdentifier:reuse_personalCell];
    
    [self addBottomView];
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = 60.f;
    self.tableView.contentInset = inset;
    
    //再设置scrollView的指示inset 60
}

- (void)addBottomView
{
    //  [self.bottomContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.bottomContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    ZXCenterBottomToolView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXCenterBottomToolView owner:self options:nil] lastObject];
    view.backgroundColor = [UIColor clearColor];
    [self.bottomContainerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.bottomContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    view.centerBtnLeadingLayout.constant = LCDScale_5Equal6_To6plus(15.f);
    view.centerBtnTopLayout.constant = LCDScale_5Equal6_To6plus(8.f);
    //单独打电话按钮
    UIImage *backgroundImage2 = [WYUTILITY getCommonVersion2RedGradientImageWithSize:view.onlyCenterBtn.frame.size];
    [view.onlyCenterBtn setBackgroundImage:backgroundImage2 forState:UIControlStateNormal];
    [view.onlyCenterBtn setTitle:@"在线沟通" forState:UIControlStateNormal];
    [view.onlyCenterBtn setImage:[UIImage imageNamed:@"im"] forState:UIControlStateNormal];
    [view.onlyCenterBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];

    [view.onlyCenterBtn addTarget:self action:@selector(bottomCenterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
*/

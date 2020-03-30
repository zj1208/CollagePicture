//
//  ZXCenterTitleHeaderFooterView.h
//  MobileCaiLocal
//
//  Created by 朱新明 on 2020/2/18.
//  Copyright © 2020 com.Chs. All rights reserved.
//
//  简介：一个中间按钮【文字+图标】，左右各一条线的UI库组件；可以设置线条与按钮的间距，也可以设置线条与边缘的边距。默认userInteractionEnabled = NO;

//  2020.3.27 修改默认不可交互；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCenterTitleHeaderFooterView : UITableViewHeaderFooterView

/// 中间按钮：可以设置图标+文字
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;

/// 中间按钮宽度大于等于多少；有时候不需要设置宽度，只需要自适应宽带;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerBtnGreaterWidthLayout;

///左边线条
@property (weak, nonatomic) IBOutlet UIView *leftLine;
///右边线条
@property (weak, nonatomic) IBOutlet UIView *rightLine;

///线条与中间内容的间距-左&右
@property (nonatomic, assign) CGFloat lineToCenterBtnSpace;

///线条与父视图的间距-左&右
@property (nonatomic, assign) CGFloat lineToSuperMargin;


/// 设置隐藏线条
@property (nonatomic, assign) BOOL hideLineView;

/// 设置线条高度
@property (nonatomic, assign) CGFloat lineHeight;

+ (id)viewFromNib;

@end

NS_ASSUME_NONNULL_END


/*
-(UITableView *)tableView
{
    if (!_tableView) {

        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        view.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        view.separatorColor = [UIColor zx_colorWithHexString:@"#EEEEEE"];
        view.backgroundColor = [UIColor zx_colorWithHexString:@"#F5F5F5"];
        //组头-猜你喜欢
        [view registerNib:[UINib nibWithNibName:NSStringFromClass([ZXCenterTitleHeaderFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([ZXCenterTitleHeaderFooterView class])];
        _tableView = view;
    }
    return _tableView;
}
*/
/*
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.youLikeItem.count == 0?0.01:49;
}
    
-(nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   if (section == 3 && self.youLikeItem.count > 0)
   {
       ZXCenterTitleHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([ZXCenterTitleHeaderFooterView class])];
       [self headerViewWithIntroduceSetDataWithHeaderView:view];
       return view;
   }
   return nil;
}
 - (void)headerViewWithIntroduceSetDataWithHeaderView:(ZXCenterTitleHeaderFooterView *)view
 {
     [view.centerBtn setTitle:@"猜你喜欢" forState:UIControlStateNormal];
     [view.centerBtn setTitleColor:[UIColor zx_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
     view.centerBtn.titleLabel.font = [UIFont zx_systemFontOfScaleSize:18];
     view.lineToCenterBtnSpace = LCDScale_iPhone6(21);
     view.lineToSuperMargin = LCDScale_iPhone6(16);
 }
*/

//
//  ZXLeftTitleRActionHFooterView.h
//  MobileCaiLocal
//
//  Created by 朱新明 on 2020/2/18.
//  Copyright © 2020 com.Chs. All rights reserved.
//
//  简介：默认背景是透明的；
//  2020.11.24 优化
//  2020.12.08 增加leftTitleBtnToLineEdgeBottom属性，可以调整限制btn的高度。


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXLeftTitleRActionHFooterView : UITableViewHeaderFooterView

///左边按钮
@property (weak, nonatomic) IBOutlet UIButton *leftTitleBtn;

///右边按钮
@property (weak, nonatomic) IBOutlet UIButton *rightTitleBtn;

///底线
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

///设置左边按钮-左边距;默认16
@property (nonatomic, assign) CGFloat leftTitleBtnMarginLeft;
///设置左边按钮-上边距；默认0；
@property (nonatomic, assign) CGFloat leftTitleBtnMarginTop;

//设置左边按钮与line的间距，默认0；
@property (nonatomic, assign) CGFloat leftTitleBtnToLineEdgeBottom;

///设置右边按钮-右间距;默认16
@property (nonatomic, assign) CGFloat rightTitleBtnMarginRight;





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
       [view registerNib:[UINib nibWithNibName:NSStringFromClass([ZXLeftTitleRActionHFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([ZXLeftTitleRActionHFooterView class])];
        _tableView = view;
    }
    return _tableView;
}
*/
/*
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.youLikeItem.count == 0?0.01:44;
}
    
-(nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   if (section == 2 && self.shopCartModel.invalidList.count >0)
   {
       ZXLeftTitleRActionHFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([ZXLeftTitleRActionHFooterView class])];
       [self headerViewWithInvalidSetDataWithHeaderView:view];
        return view;
   }
     return nil;
}
- (void)headerViewWithInvalidSetDataWithHeaderView:(ZXLeftTitleRActionHFooterView *)view
{
    [view.leftTitleBtn setTitle:[NSString stringWithFormat:@"%ld件失效商品",self.shopCartModel.invalidList.count] forState:UIControlStateNormal];
     view.leftTitleBtn.userInteractionEnabled = NO;
     [view.rightTitleBtn setTitle:@"清空失效商品" forState:UIControlStateNormal];
     [view.rightTitleBtn setTitleColor:[UIColor zx_colorWithHexString:@"#FF4C00"] forState:UIControlStateNormal];
     [view.rightTitleBtn addTarget:self action:@selector(cleanInvalidGoodsBtnActoin:) forControlEvents:UIControlEventTouchUpInside];
}
*/

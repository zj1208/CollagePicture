//
//  ZXTableViewUnfoldFooterView.h
//  YiShangbao
//
//  Created by simon on 2018/4/27.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  简介：可以用于tableView底部视图+收回/展开效果； 只需要对动态伸缩那几组做刷新处理，其它尽量不刷新；
//  9.11 增加注释

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXTableViewUnfoldFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIImageView *arrUpImageView;

@property (weak, nonatomic) IBOutlet UIImageView *arrDownImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIButton *footerActionBtn;

@property (nonatomic, copy) void(^footerActionBlock)(UIButton *footerBtn);

- (IBAction)footerBtnAction:(id)sender;

@end

NS_ASSUME_NONNULL_END

/*
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableView.tableFooterView.zx_height = 115;
}
#pragma mark-底部视图+收回/展开

- (void)addFooterView
{
    ZXTableViewUnfoldFooterView *footerView = [ZXTableViewUnfoldFooterView zx_viewFromNib];
    footerView.backgroundColor = self.tableView.backgroundColor;
    self.tableView.tableFooterView = footerView;
    WS(weakSelf);
 
    footerView.footerActionBlock = ^(UIButton *footerBtn) {
        
        [MobClick event:kUM_b_product_moreinfo];
        
        weakSelf.unfoldTable = footerBtn.selected;
        
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 2)] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView endUpdates];
    };
     if (self.controllerDoingType ==ControllerDoingType_EditProduct)
     {
         self.tableView.tableFooterView.hidden = YES;
     }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
            
        case 2:return 4; break;
        case 3:return self.isUnfoldTable?3:0; break;
        case 4:return self.isUnfoldTable?2:0; break;
            
        default:return 1;
            break;
    }
    return 0;
}
*/

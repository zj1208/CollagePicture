//
//  ZXAlertChoseController.m
//  YiShangbao
//
//  Created by simon on 2017/9/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAlertChoseController.h"
#import "AlertChoseTableViewCell/AlertChoseTableViewCell.h"
#import "AlertTextFieldCell/AlertTextFieldCell.h"
#import "UIScrollView+ZXCategory.h"


#ifndef LCDW
#define LCDW ([[UIScreen mainScreen] bounds].size.width)
#define LCDH ([[UIScreen mainScreen] bounds].size.height)
#endif

#ifndef SCREEN_MAX_LENGTH
#define SCREEN_MAX_LENGTH (MAX(LCDW, LCDH))
#define SCREEN_MIN_LENGTH (MIN(LCDW, LCDH))
#endif

//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#ifndef LCDScale_iPhone6
#define LCDScale_iPhone6(X)    ((X)*SCREEN_MIN_LENGTH/375)
#endif


@interface ZXAlertChoseController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *cancleButton;

@property (weak, nonatomic) IBOutlet UIButton *doButton;


@property (nonatomic, copy) NSString *textViewText;
@end

@implementation ZXAlertChoseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUI];
  
}

- (void)setUI
{
    self.titleLabel.text =self.alertTitle;
    self.textViewPlaceholder = @"请输入其它原因";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AlertChoseTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AlertChoseTableViewCell class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AlertTextFieldCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AlertTextFieldCell class])];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.addTextField)
    {
        return self.titles.count+1;
    }
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.addTextField && indexPath.row == self.titles.count)
    {
        return LCDScale_iPhone6(70.f);
    }
    return LCDScale_iPhone6(40.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.addTextField && indexPath.row == self.titles.count)
    {
        AlertTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AlertTextFieldCell class]) forIndexPath:indexPath];
        cell.textView.delegate = self;
        cell.textView.placeholder = self.textViewPlaceholder;
        [cell.accessoryBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    AlertChoseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AlertChoseTableViewCell class]) forIndexPath:indexPath];
    [cell.selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row < self.titles.count)
    {
        cell.titleLabel.text = [self.titles objectAtIndex:indexPath.row];
    }
    return cell;
}


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Action

/// 选择按钮-选中行
- (void)selectBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    CGPoint point = btn.center;
    point = [self.tableView convertPoint:point fromView:btn.superview];
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:point];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

///取消
- (IBAction)cancleButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - textViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSIndexPath *indexPath_textView = [self zh_getIndexPathFromTableViewOrCollectionView:self.tableView withConvertView:textView];

    if (indexPath.row != indexPath_textView.row)
    {
        [self.tableView selectRowAtIndexPath:indexPath_textView animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.textViewText = textView.text;
}

#pragma mark - 确定
///确定
- (IBAction)doButtonAction:(id)sender {
    
    NSIndexPath *selectIndexPath = [self.tableView indexPathForSelectedRow];
    NSString *selectContent = nil;
    if (self.addTextField && selectIndexPath.row == self.titles.count)
    {
        if ([NSString zhIsBlankString:self.textViewText])
        {
            [MBProgressHUD zx_showError:self.textViewPlaceholder toView:nil];
            return;
        }
        selectContent = self.textViewText;
    }
    else
    {
        selectContent = [self.titles objectAtIndex:selectIndexPath.row];
    }
    __weak __typeof(self)weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        
         if ([weakSelf.btnActionDelegate respondsToSelector:@selector(zx_alertChoseController:clickedButtonAtIndex:content:userInfo:)])
         {
             [weakSelf.btnActionDelegate zx_alertChoseController:weakSelf clickedButtonAtIndex:selectIndexPath.row content:selectContent userInfo:weakSelf.userInfo];
         }
    }];
}

#pragma mark - 获取NSIndexPath

- (nullable NSIndexPath *)zh_getIndexPathFromTableViewOrCollectionView:(UIScrollView *)scrollView  withConvertView:(nullable UIView *)view
{
    CGPoint point = view.center;
    point = [scrollView convertPoint:point fromView:view.superview];
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        UITableView *tableView = (UITableView *)scrollView;
        NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:point];
        return indexPath;
    }
    if ([scrollView isKindOfClass:[UICollectionView class]])
    {
        UICollectionView *tableView = (UICollectionView *)scrollView;
        NSIndexPath* indexPath = [tableView indexPathForItemAtPoint:point];
        return indexPath;
    }
    return nil;
}

@end

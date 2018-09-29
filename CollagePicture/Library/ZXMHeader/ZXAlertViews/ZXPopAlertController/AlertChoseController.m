//
//  AlertChoseController.m
//  YiShangbao
//
//  Created by simon on 2017/9/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AlertChoseController.h"
#import "AlertChoseTableCell.h"
#import "AlertTextFieldCell.h"
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
#ifndef LCDScale_iPhone6_Width
#define LCDScale_iPhone6_Width(X)    ((X)*SCREEN_MIN_LENGTH/375)
#endif


@interface AlertChoseController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *cancleButton;

@property (weak, nonatomic) IBOutlet UIButton *doButton;


@property (nonatomic, copy) NSString *textViewText;
@end

@implementation AlertChoseController

static NSString * const reuse_Cell  = @"Cell";
static NSString * const reuse_TextFieldCell  = @"TextFieldCell";


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
    
    [self.tableView registerNib:[UINib nibWithNibName:nibName_AlertChoseTableCell bundle:nil] forCellReuseIdentifier:reuse_Cell];
    [self.tableView registerNib:[UINib nibWithNibName:nibName_AlertTextFieldCell bundle:nil] forCellReuseIdentifier:reuse_TextFieldCell];
    
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
        return _titles.count+1;
    }
    return _titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==_titles.count)
    {
        return LCDScale_iPhone6_Width(70.f);
    }
    return LCDScale_iPhone6_Width(40.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row ==_titles.count && self.addTextField)
    {
        AlertTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_TextFieldCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.delegate = self;
        cell.textView.placeholder = self.textViewPlaceholder;
        [cell.accessoryBtn addTarget:self action:@selector(accessoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    AlertChoseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_Cell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell.accessoryBtn addTarget:self action:@selector(accessoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row<_titles.count)
    {
        cell.titleLabel.text = [_titles objectAtIndex:indexPath.row];
    }
    return cell;
}

//- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)accessoryBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSIndexPath *indexPath = [self.tableView zh_getIndexPathFromTableViewOrCollectionViewWithConvertView:btn];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
}

- (IBAction)cancleButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSIndexPath *textIndexPath = [self zh_getIndexPathFromTableViewOrCollectionView:self.tableView withConvertView:textView];

    if (indexPath.row != textIndexPath.row)
    {
        [self.tableView selectRowAtIndexPath:textIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    _textViewText = textView.text;
}


- (IBAction)doButtonAction:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString *selectContent = nil;
    if (self.addTextField && indexPath.row ==_titles.count)
    {
        if ([NSString zhIsBlankString:_textViewText])
        {
            [MBProgressHUD zx_showError:self.textViewPlaceholder toView:nil];
            return;
        }
        selectContent = _textViewText;
    }
    else
    {
        selectContent = [_titles objectAtIndex:indexPath.row];
    }
    WS(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
        
         if ([_btnActionDelegate respondsToSelector:@selector(zx_alertChoseController:clickedButtonAtIndex:content:userInfo:)])
         {
             [_btnActionDelegate zx_alertChoseController:weakSelf clickedButtonAtIndex:indexPath.row content:selectContent userInfo:_userInfo];
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

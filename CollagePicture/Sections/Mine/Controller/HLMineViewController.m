//
//  HLMineViewController.m
//  HappyLottery
//
//  Created by 蔡叶超 on 6/27/17.
//  Copyright © 2017 cyc. All rights reserved.
//

#import "HLMineViewController.h"
#import "HLMineTableHeaderView.h"


@interface HLMineViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) HLMineTableHeaderView *headerView;

@property (nonatomic, strong) NSArray<NSArray <NSString *>*> *textArr;
@property (nonatomic, strong) NSArray<NSArray <NSString *>*> *imageArr;


@end

@implementation HLMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.textArr = @[@[@"账户", @"修改密码"], @[@"关于开心彩票", @"给我评分"], @[@"清除缓存"]];
    self.imageArr = @[@[@"m_account", @"m_changePass"], @[@"m_about", @"m_goStore", @"m_update"], @[@"m_cleanCache"]];
    
    [self setupUI];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupUI {
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.headerView = (HLMineTableHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"HLMineTableHeaderView" owner:nil options:nil] firstObject];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    self.tableView.tintColor = [UIColor darkGrayColor];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    cell.textLabel.text = self.textArr[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.textArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textArr[section].count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

@end

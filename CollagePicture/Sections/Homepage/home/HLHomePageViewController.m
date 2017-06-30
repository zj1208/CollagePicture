//
//  HLHomePageViewController.m
//  HappyLottery
//
//  Created by 蔡叶超 on 6/27/17.
//  Copyright © 2017 cyc. All rights reserved.
//

#import "HLHomePageViewController.h"
#import "HLThreeDimensionalViewController.h"
#import "HLLotteryInfoViewController.h"


#import "HLLotteryModel.h"

#import "HLHomePageLotteryCell.h"
#import "HLHomePageADHeaderView.h"

@interface HLHomePageViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonnull, strong) UITableView *tableView;
@property (nonatomic, strong) HLHomePageADHeaderView *headerView;



@property (strong, nonatomic) NSMutableArray<HLLotteryModel *> *lotteryModels;

@end

@implementation HLHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupUI];
    
    
    
    [self fetchData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setupUI {
    self.navigationItem.title = @"我的";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // self.title 底部的tabbar会有字
    self.navigationItem.title = @"彩票";
    
    self.headerView = [[HLHomePageADHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [self.headerView setAdLinks:@[@"3D", @"11xuan5"]];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)fetchData {

    self.lotteryModels = [[NSMutableArray alloc] init];
    NSArray *categorys = @[@"3D", @"11选5", @"大乐透", @"双色球"];
    NSArray *imageNames = @[@"3D", @"11xuan5", @"daletou", @"shuangseqiu"];
    NSArray *infos = @[@"", @"", @"", @"", @"" ];
    
    for (int i = 0 ; i < categorys.count; i ++) {
        HLLotteryModel *model = [[HLLotteryModel alloc] init];
        model.imageName = imageNames[i];
        model.category = categorys[i];
        model.info = infos[i];
        [self.lotteryModels addObject:model];
        
    }
    
    [self.tableView reloadData];

}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLHomePageLotteryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHomePageLotteryCell"];
    if (cell == nil) {
        cell = (HLHomePageLotteryCell *)[[[NSBundle mainBundle] loadNibNamed:@"HLHomePageLotteryCell" owner:nil options:nil] firstObject];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    HLLotteryModel *model = self.lotteryModels[indexPath.row];
    cell.textLabel.text = model.category;
    cell.imageView.image = [UIImage imageNamed:model.imageName];
    cell.detailTextLabel.text = model.info;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lotteryModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    if (indexPath.row == 0) {
        HLThreeDimensionalViewController *threeDvc = [[UIStoryboard storyboardWithName:@"Lottery" bundle:nil] instantiateViewControllerWithIdentifier:@"HLThreeDimensionalViewController"];
        [self.navigationController pushViewController:threeDvc animated:TRUE];
        return;
    }
    
    
    HLLotteryInfoViewController *infovc = [[UIStoryboard storyboardWithName:@"Lottery" bundle:nil] instantiateViewControllerWithIdentifier:@"HLLotteryInfoViewController"];
    if (indexPath.row == 0) {
        infovc.category = _3D;
    } else if (indexPath.row == 1) {
        infovc.category = _11xuan5;
    } else if (indexPath.row == 2) {
        infovc.category = _daletou;
    } else if (indexPath.row == 3) {
        infovc.category = _shuangseqiu;
    }
    [self.navigationController pushViewController:infovc animated:TRUE];
    
}

@end

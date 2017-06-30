//
//  HLThreeDimensionalViewController.m
//  HappyLottery
//
//  Created by 蔡叶超 on 6/28/17.
//  Copyright © 2017 cyc. All rights reserved.
//

#import "HLThreeDimensionalViewController.h"
#import "HLIssueSelectedViewController.h"

@interface HLThreeDimensionalViewController ()
@property (weak, nonatomic) IBOutlet UILabel *no1Label;
@property (weak, nonatomic) IBOutlet UILabel *no2Label;
@property (weak, nonatomic) IBOutlet UILabel *no3Label;
// 期号
@property (weak, nonatomic) IBOutlet UILabel *issueNoLabel;

@end

@implementation HLThreeDimensionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    
    self.title = @"3D";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[ UIImage imageNamed:@"nav_rule"] style:UIBarButtonItemStyleDone target:self action:@selector(tapNavRightRuleBtn:)];
    
    
}

- (void)tapNavRightRuleBtn:(UIBarButtonItem *)item {
    [[[UIAlertView alloc] initWithTitle:@"查看规则" message:@"规则如下" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

/// 期号选择点击
- (IBAction)tapIssueSelectedBtn:(UIButton *)sender {
    HLIssueSelectedViewController *vc = [[UIStoryboard storyboardWithName:@"Lottery" bundle:nil] instantiateViewControllerWithIdentifier:@"HLIssueSelectedViewController"];
    vc.modalPresentationStyle =  UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:TRUE completion:nil];
    
    vc.selectedBlock = ^(NSInteger index) {
        self.issueNoLabel.text = [NSString stringWithFormat:@"第%ld期", index];
    };
    
}

@end

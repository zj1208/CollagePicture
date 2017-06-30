//
//  HLLotteryInfoViewController.m
//  CollagePicture
//
//  Created by 蔡叶超 on 6/29/17.
//  Copyright © 2017 simon. All rights reserved.
//

#import "HLLotteryInfoViewController.h"

#import "HLIssueSelectedViewController.h"
#import "Lettery_11xuan5View.h"
#import "Lettery_daletouView.h"
#import "Lettery_shuangseqiuView.h"


@interface HLLotteryInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *lotteryCategoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *issueNoLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation HLLotteryInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    if (self.category == _3D) {
        self.title = @"3D";
        self.lotteryCategoryImageView.image = [UIImage imageNamed:@"3D"];
    } else if (self.category == _11xuan5) {
        self.title = @"11选5";
         self.lotteryCategoryImageView.image = [UIImage imageNamed:@"11xuan5"];
        Lettery_11xuan5View *l_11xuan5View = [Lettery_11xuan5View xibView];
        [self.contentView addSubview:l_11xuan5View];
        [l_11xuan5View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView);
        }];
    } else if (self.category == _daletou) {
        self.title = @"大乐透";
        self.lotteryCategoryImageView.image = [UIImage imageNamed:@"daletou"];
        Lettery_daletouView *l_daletouView = [Lettery_daletouView xibView];
        [self.contentView addSubview:l_daletouView];
        [self.contentView setMj_h:180];
        [self.view setNeedsUpdateConstraints];
        [l_daletouView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView);
        }];
    } else if (self.category == _shuangseqiu) {
        self.title = @"双色球";
        self.lotteryCategoryImageView.image = [UIImage imageNamed:@"shuangseqiu"];
        Lettery_shuangseqiuView *l_shuangseqiuView = [Lettery_shuangseqiuView xibView];
        [self.contentView addSubview:l_shuangseqiuView];
        [self.contentView setMj_h:180];
        [self.view setNeedsUpdateConstraints];
        [l_shuangseqiuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView);
        }];
    }
    
    
    
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

//
//  HLFoundViewController.m
//  HappyLottery
//
//  Created by 蔡叶超 on 6/27/17.
//  Copyright © 2017 cyc. All rights reserved.
//

#import "HLFoundViewController.h"
#import "HLChooseScrollView.h"
#import "HLNewsViewController.h"

@interface HLFoundViewController ()<HLChooseScrollViewDelegate, HLChooseScrollViewDataSource, UIScrollViewDelegate>
@property (strong, nonatomic) HLChooseScrollView *chooseView;
@property (nonatomic, strong) UIScrollView *newsScrollView;


@property (nonatomic, strong) NSArray<NSString *> *categorys;
@end

@implementation HLFoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categorys = @[@"3D", @"11选5", @"大乐透", @"七乐彩", @"双色球"];
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = TRUE;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = FALSE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    CGFloat chooseViewH = 80.0;
    self.chooseView = [[HLChooseScrollView alloc] initWithFrame:CGRectMake(0, 10, LCDW, chooseViewH)];
    self.chooseView.delegate = self;
    self.chooseView.dataSource = self;
    [self.view addSubview:self.chooseView];
    
    self.newsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, chooseViewH, LCDW, self.view.mj_h - chooseViewH)];
    self.newsScrollView.contentSize = CGSizeMake(self.categoryArr.count * LCDW, self.newsScrollView.mj_h);
    self.newsScrollView.pagingEnabled = TRUE;
    self.newsScrollView.delegate = self;
    [self.view addSubview:self.newsScrollView];
    
    for (int i = 0; i < self.categoryArr.count; i ++) {
        HLNewsViewController *vc = [[HLNewsViewController alloc] init];
        [self.newsScrollView addSubview:vc.view];
        [self addChildViewController:vc];
        vc.newsName = self.categoryArr[i];
        vc.view.frame = CGRectMake(i * self.newsScrollView.mj_w, 0, LCDW, self.newsScrollView.mj_h);
//        __weak __typeof(self)weakSelf = self;
        vc.selectedBlock = ^(HLNewsViewController *vc, NSInteger selectIndex) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您点击了消息" message:@"....." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        };
    }
    
    
}

#pragma mark- HLChooseScrollViewDelegate, HLChooseScrollViewDataSource 
- (NSArray<NSString *> *)categoryArr {
    return self.categorys;
}

- (void)chooseScrollView:(HLChooseScrollView *)view DidSelected:(NSInteger)index {
    [UIView animateWithDuration:0.25 animations:^{
        self.newsScrollView.contentOffset = CGPointMake(index * LCDW, 0);
    }];
    

}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger count = scrollView.contentOffset.x / LCDW;
    [self.chooseView setSelecetedIndex:count];
    
    
}

@end

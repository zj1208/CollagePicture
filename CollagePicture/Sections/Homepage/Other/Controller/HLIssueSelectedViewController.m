//
//  HLIssueSelectedViewController.m
//  HappyLottery
//
//  Created by 蔡叶超 on 6/28/17.
//  Copyright © 2017 cyc. All rights reserved.
//

#import "HLIssueSelectedViewController.h"

@interface HLIssueSelectedViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *issuePickerView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation HLIssueSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



- (IBAction)tapSureBtn:(UIButton *)sender {
    if (self.selectedBlock != nil) {
        self.selectedBlock([self.issuePickerView selectedRowInComponent:0]);
    }
    [self dismissViewControllerAnimated:FALSE completion:nil];
}

#pragma mark- UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 100;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"第%ld期", row];
}

@end

//
//  FullTextViewController.m
//  CollagePicture
//
//  Created by simon on 16/12/20.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "FullTextViewController.h"

@interface FullTextViewController ()

@property (nonatomic, strong) UITextView *textView;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *barTitle;

@end

@implementation FullTextViewController

- (instancetype)initWithBarTitle:(nullable NSString *)aTitle{
    self = [super init];
    if (self)
    {
        self.barTitle = aTitle;
        [self addTextView];
    }
    return self;
}

//@"test.wps" :@"application/msword"
- (void)loadTextPathOfResource:(nullable NSString *)name ofType:(nullable NSString *)ext
{
    NSString *content = [self getStringWithContentsOfResource:name ofType:ext];
    self.textView.text = content;
}

- (void)loadLocalUserServiceAgreementOfFixResourceWithCompany:(nullable NSString *)company appName:(nullable NSString *)aAppName
{
    NSString *content = [self getStringWithContentsOfResource:@"UserServiceAgreement" ofType:@"txt"];
    NSString *newContent = [content copy];
    if (company)
    {
          newContent = [content stringByReplacingOccurrencesOfString:@"**公司" withString:company];
    }
    if (aAppName)
    {
          newContent = [newContent stringByReplacingOccurrencesOfString:@"我请客" withString:aAppName];
    }
    self.textView.text = newContent;
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
}


- (NSString *)getStringWithContentsOfResource:(nullable NSString *)name ofType:(nullable NSString *)ext
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    if (!path)
    {
        NSLog(@"没有这个路径的文件");
        return nil;
    }
    NSError *error = nil;
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!error)
    {
        return content;
    }
    else
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.barTitle;

}

- (void)addTextView
{
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.frame textContainer:nil];
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:14];
    self.textView = textView;
    [self.view addSubview:self.textView];
    
}



-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ([UIMenuController sharedMenuController])
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
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

@end

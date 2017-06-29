//
//  FullTextViewController.m
//  CollagePicture
//
//  Created by 朱新明 on 16/12/20.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "FullTextViewController.h"

@interface FullTextViewController ()
@property (nonatomic,strong)UITextView *textView;
/**
 *  标题
 */
@property(nonatomic,copy)NSString *barTitle;
@end

@implementation FullTextViewController

- (instancetype)initWithBarTitle:(NSString *)aTitle{
    self = [super init];
    if (self)
    {
        self.barTitle = aTitle;
        [self addTextView];
        
    }
    return self;
}

//@"test.wps" :@"application/msword"
- (void)loadTextPathOfResource:(NSString *)name ofType:(NSString *)ext
{
    if (!name)
    {
        NSLog(@"参数不够");
        return;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.textView.text = content;
   
}

- (void)loadUserServiceAgreementPathOfResource:(NSString *)name ofType:(NSString *)ext company:(NSString *)company appName:(NSString *)aAppName
{
    if (!name)
    {
        NSLog(@"参数不够");
        return;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
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

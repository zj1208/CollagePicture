//
//  PrivacyListController.m
//  CollagePicture
//
//  Created by simon on 16/12/5.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "PrivacyListController.h"
#import "ZXWebViewController.h"
@interface PrivacyListController ()
@property (nonatomic,copy)NSArray *dataArray;
@end

@implementation PrivacyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = NSLocalizedString(@"隐私权政策", nil);
    [self getJsonData];
    self.tableView.tableFooterView = [[UIView alloc] init];

}

- (void)getJsonData
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ZXPrivacyPolicy" ofType:@"json"];
    //    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSLog(@"%lu",(unsigned long)data.length);
    NSError *error = nil;
    NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    self.dataArray = [dic objectForKey:@"list"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *modelDic = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text =[modelDic objectForKey:@"title"];
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.dataArray count]>0)
    {
        NSDictionary *modelDic = [self.dataArray objectAtIndex:indexPath.row];
        NSString *content = [modelDic objectForKey:@"content"];
        NSString *content2 = [content stringByReplacingOccurrencesOfString:@"**" withString:APP_Name];
        ZXWebViewController *vc = [[ZXWebViewController alloc] initWithBarTitle:[modelDic objectForKey:@"title"]];
        [vc loadLocalText:content2];
        [self.navigationController pushViewController:vc animated:YES];
    }
  
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation




@end

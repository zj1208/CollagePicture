//
//  CopyrightController.m
//  CollagePicture
//
//  Created by simon on 16/12/2.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "CopyrightController.h"

#import "CopyrightCell.h"

#import "ZXWebViewController.h"
@interface CopyrightController ()

@property (nonatomic,copy)NSArray *copyrightArray;

@end

//http://choosealicense.com/licenses/mit/

@implementation CopyrightController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = NSLocalizedString(@"版权信息", nil);

    self.copyrightArray = [self getCopyrightArrayFromBundleResource];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.copyrightArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CopyrightCell *cell = (CopyrightCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.copyrightArray.count>0)
    {
        id data = [self.copyrightArray objectAtIndex:indexPath.row];
        [cell.nameBtn addTarget:self action:@selector(goGithubViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.licenseBtn addTarget:self action:@selector(goLicenseViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell setData:data];
    }
    // Configure the cell...
    
    return cell;
}


- (NSArray *)getCopyrightArrayFromBundleResource
{
    NSString *path =  [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"copyright.plist"];
    NSDictionary *styleDict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (styleDict)
    {
        NSArray *subViewArray = [styleDict objectForKey:@"copyrightList"];
        return subViewArray;
    }
    return nil;
}



- (void)goGithubViewAction:(UIButton *)sender
{
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    NSDictionary *dic = [self.copyrightArray objectAtIndex:indexPath.row];
   
    ZXWebViewController *webController = [[ZXWebViewController alloc] initWithBarTitle:[dic objectForKey:@"name"]];
    [webController loadWebPageWithURLString:[dic objectForKey:@"homepage"]];
    [self.navigationController pushViewController:webController animated:YES];
}


- (void)goLicenseViewAction:(UIButton *)sender
{
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    NSDictionary *dic = [self.copyrightArray objectAtIndex:indexPath.row];
    NSString *licenseAdress = [self getLicenseAddressWithLicenseName:[dic objectForKey:@"license"]];
    ZXWebViewController *webController = [[ZXWebViewController alloc] initWithBarTitle:[dic objectForKey:@"license"]];
    [webController loadWebPageWithURLString:licenseAdress];
    [self.navigationController pushViewController:webController animated:YES];

}


- (NSString *)getLicenseAddressWithLicenseName:(NSString *)name
{
    if ([name isEqualToString:@"Apache v2.0"])
    {
        return @"http://choosealicense.com/licenses/apache-2.0/";
    }
    else if ([name isEqualToString:@"MIT License"])
    {
        return @"http://choosealicense.com/licenses/mit/";
    }
    return nil;
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

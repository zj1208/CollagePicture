//
//  TemplateListController.m
//  CollagePicture
//
//  Created by simon on 16/9/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "TemplateListController.h"
#import <BmobSDK/Bmob.h>
#import "TemplateListCell.h"
@interface TemplateListController ()<UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)NSMutableArray *dataMArray;

@property(nonatomic)NSInteger pageNo;
@property (nonatomic)UILocalNotification *notification;
@end

@implementation TemplateListController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",NSHomeDirectory());
    // Uncomment the following line to preserve selection between presentations
     self.clearsSelectionOnViewWillAppear = NO;
//    self.testBarItem.enabled = NO;
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.dataMArray = [NSMutableArray array];
    

    // Do any additional setup after loading the view.
    [self headerRefresh];
    

//    ZX_NSLog_ClassAllPropertyAndValue(self.collectionView);
    ZX_NSLog_ClassMethodListName(self);
    
}



#pragma mark - 下拉刷新/上拉加载更多
/**
 *  下拉刷新
 */
- (void)headerRefresh
{
    WS(weakSelf);
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        BmobQuery *bquery1 = [BmobQuery queryWithClassName:@"templateList"];
//        BmobQuery *bquery1 = [BmobQuery queryWithClassName:@"mall_banner"];
        bquery1.limit = kHTTP_minPageSize;
        [bquery1 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            //失败的时候不在主线程返回
            NSLog(@"%@",[NSThread currentThread]);
            if (error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    [weakSelf.collectionView.mj_header endRefreshing];
                    [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
                });
              
            }
            else
            {
                [self.dataMArray removeAllObjects];
                [self.dataMArray addObjectsFromArray:array];
                NSLog(@"bmobArray:%@",array);
                [self.collectionView reloadData];
                
                _pageNo = 1;
                [weakSelf.collectionView.mj_header endRefreshing];
                [weakSelf.collectionView.mj_footer endRefreshing];
                
                [weakSelf footerWithRefreshing];
                if ([array count]<kHTTP_minPageSize)
                {
                    [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                }

            }
        }];
   
    }];
    [self.collectionView.mj_header beginRefreshing];
  
}
- (void)footerWithRefreshing
{
    if (self.dataMArray.count==0)
    {
        if (self.collectionView.mj_footer)
        {
            self.collectionView.mj_footer = nil;
        }
        return;
    }
    WS(weakSelf);
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSLog(@"%@",@(_pageNo));
        
        BmobQuery *bquery1 = [BmobQuery queryWithClassName:@"templateList"];
        //        BmobQuery *bquery1 = [BmobQuery queryWithClassName:@"mall_banner"];
        bquery1.limit = kHTTP_minPageSize;
        bquery1.skip = kHTTP_minPageSize*_pageNo;
        [bquery1 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            //失败的时候不在主线程返回
            NSLog(@"%@",[NSThread currentThread]);
            if (error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.collectionView.mj_footer endRefreshing];
                    [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
                });
                
            }
            else
            {
                [self.dataMArray addObjectsFromArray:array];
                NSLog(@"bmobArray:%@",array);
                [self.collectionView reloadData];
                [weakSelf.collectionView.mj_footer endRefreshing];
                
                _pageNo ++;
                if ([array count]<kHTTP_minPageSize)
                {
                    [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                }

            }
        }];

        
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataMArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TemplateListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    if (self.dataMArray.count>0)
    {
        BmobObject *model = (BmobObject *)[self.dataMArray objectAtIndex:indexPath.item];
        
        [cell setData:model];
    }


    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(LCDW-10, LCDScale_iPhone6_Width(160));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 5, 10, 5);
}
#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     BmobObject *model = (BmobObject *)[self.dataMArray objectAtIndex:indexPath.item];
    [self pushStoryboardViewControllerWithStoryboardName:@"Main" identifier:SBID_MakingPhotoController withData:@{@"templateType":[model objectForKey:@"type"]}];
}


/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/



#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)shareTestAction:(UIBarButtonItem *)sender {
    
    
}
@end

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
#import "ZXEmptyViewController.h"

@interface TemplateListController ()<UICollectionViewDelegateFlowLayout,ZXEmptyViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataMArray;

@property (nonatomic) NSInteger pageNo;

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic) UILocalNotification *notification;

@end

@implementation TemplateListController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",NSHomeDirectory());
    // Uncomment the following line to preserve selection between presentations
     self.clearsSelectionOnViewWillAppear = NO;
    [self setUI];
    [self setData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    UIGestureRecognizer *rg  =self.navigationController.interactivePopGestureRecognizer;
}
- (void)setUI
{

}

- (ZXEmptyViewController *)emptyViewController
{
    if (!_emptyViewController) {
        _emptyViewController =[[ZXEmptyViewController alloc] init];
        _emptyViewController.delegate = self;
    }
    return _emptyViewController;
}

- (void)setData
{
    self.dataMArray = [NSMutableArray array];
    [self headerRefresh];
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - 下拉刷新/上拉加载更多
/**
 *  下拉刷新
 */
- (void)headerRefresh
{
    WS(weakSelf);
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
   
        [weakSelf requestHeaderData];
    }];
}

- (void)requestHeaderData
{
    WS(weakSelf);
    BmobQuery *bquery1 = [BmobQuery queryWithClassName:@"templateList"];
    //        BmobQuery *bquery1 = [BmobQuery queryWithClassName:@"mall_banner"];
    bquery1.limit = kHTTP_minPageSize;
    [bquery1 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //回调都是在主线程
        NSLog(@"%@",[NSThread currentThread]);
        if (error)
        {
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count>0?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
        }
        //主线程
        else
        {
            [weakSelf.dataMArray removeAllObjects];
            [weakSelf.dataMArray addObjectsFromArray:array];
            NSLog(@"bmobArray:%@",array);
            
            [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count>0?YES:NO error:nil emptyImage:[UIImage imageNamed:@"粉丝"] emptyTitle:@"粉丝多了以后好处可多了！\n 你可以拿给别人炫耀有这么多粉丝啊，\n去分享你的名片让别人关注即可成为你的粉丝" updateBtnHide:YES];
            [weakSelf.collectionView reloadData];
            
            weakSelf.pageNo = 1;
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            
            
            [weakSelf footerWithRefreshingMorePage:weakSelf.dataMArray.count/kHTTP_minPageSize == 1 ?YES:NO];
        }
    }];
}

- (void)zxEmptyViewUpdateAction
{
    [self.collectionView.mj_header beginRefreshing];
}

- (void)footerWithRefreshingMorePage:(BOOL)flag
{
    if (!flag)
    {
        if (self.collectionView.mj_footer)
        {
            self.collectionView.mj_footer = nil;
        }
        return;
    }
    WS(weakSelf);
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf requestFooterData];
    }];
}

- (void)requestFooterData
{
    NSLog(@"%@",@(self.pageNo));
    WS(weakSelf);
    BmobQuery *bquery1 = [BmobQuery queryWithClassName:@"templateList"];
    //        BmobQuery *bquery1 = [BmobQuery queryWithClassName:@"mall_banner"];
    bquery1.limit = kHTTP_minPageSize;
    bquery1.skip = kHTTP_minPageSize*self.pageNo;
    [bquery1 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        NSLog(@"%@",[NSThread currentThread]);
        if (error)
        {
            [weakSelf.collectionView.mj_footer endRefreshing];
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }
        else
        {
            [self.dataMArray addObjectsFromArray:array];
            NSLog(@"bmobArray:%@",array);
            [self.collectionView reloadData];
            [weakSelf.collectionView.mj_footer endRefreshing];
            
            weakSelf.pageNo ++;
            if ([array count]<kHTTP_minPageSize)
            {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }];
}



#pragma mark - Navigation



#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataMArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TemplateListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    BmobObject *model = (BmobObject *)[self.dataMArray objectAtIndex:indexPath.item];    
    [cell setData:model];
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
    UIGestureRecognizer *rg  =self.navigationController.interactivePopGestureRecognizer;

     BmobObject *model = (BmobObject *)[self.dataMArray objectAtIndex:indexPath.item];
    [self zx_pushStoryboardViewControllerWithStoryboardName:@"Main" identifier:SBID_MakingPhotoController withData:@{@"templateType":[model objectForKey:@"type"]}];
}



// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


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



@end

//
//  SearchResultsController.m
//  CollagePicture
//
//  Created by 朱新明 on 2019/10/25.
//  Copyright © 2019 simon. All rights reserved.
//

#import "SearchResultsController.h"
#import "ZXEmptyViewController.h"

@interface SearchResultsController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,ZXEmptyViewControllerDelegate>

@property (nonatomic, copy) NSString *searchTitle;

@property (nonatomic,strong) NSMutableArray *dataMArray;

@property (nonatomic) NSInteger pageNo;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic) id next;

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;
@end

@implementation SearchResultsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self setData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)setUI
{
    self.textField.font = [UIFont systemFontOfSize:13];
    [self.textField zx_setBorderWithCornerRadius:10 borderWidth:1 borderColor:[UIColor zx_colorWithHexString:@"EDEFF0"]];
    self.textField.textPositionAdjustment = UIOffsetMake(12, 0);
    self.collectionView.backgroundColor = [UIColor zx_colorWithHexString:@"#f3f3f3"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];

    self.collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectionViewFlowLayout.minimumInteritemSpacing = 9;
    self.collectionViewFlowLayout.minimumLineSpacing = 10;
    
//    UIImage *image = [UIImage imageNamed:@"icon_search_field_bg"];
//    UIImage *resizableImage = [image resizableImageWithCapInsets: UIEdgeInsetsMake(0, image.size.width/2, 0, image.size.width/2)];
//    self.textField.background = resizableImage;
    [self.carBtn setImage:[UIImage imageNamed:@"icon_car"]];
    [self.carBtn setBadgeContentInsetY:2.f badgeFont:[UIFont systemFontOfSize:11]];
    self.carBtn.badgeLabelContentOffest = CGPointMake(0, -5);
 
//    self.emptyViewController.contentOffest = CGSizeMake(0, 100);
    self.emptyViewController.view.frame = CGRectMake(0, HEIGHT_NAVBAR, LCDW, LCDH-HEIGHT_NAVBAR);
}

- (ZXEmptyViewController *)emptyViewController
{
    if (!_emptyViewController) {
        
        ZXEmptyViewController *emptyVC = [[ZXEmptyViewController alloc] init];
        emptyVC.delegate = self;
        _emptyViewController = emptyVC;
    }
    return _emptyViewController;
}


- (void)setData{
    
    self.dataMArray = [NSMutableArray array];
    [self headerRefresh];
}

- (void)headerRefresh
{
    WS(weakSelf);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestHeaderData];
    }];
}




- (void)requestSearchDataWithText:(NSString *)text{
 
    self.searchTitle = text;
    self.textField.text = text;
    if (self.dataMArray.count>0) {
        [self.dataMArray removeAllObjects];
        [self.collectionView reloadData];
    }
    [self.collectionView.mj_header beginRefreshing];
}


- (void)requestHeaderData
{
  
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
    
}

#pragma mark -
- (IBAction)goBackAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textFieldEditingBegainAction:(id)sender {
    
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    if ([self.delegate respondsToSelector:@selector(textFieldEditingBegainActionWithSearchTitle:)]) {
        [self.delegate textFieldEditingBegainActionWithSearchTitle:self.textField.text];
    }
}

- (IBAction)carBtnAction:(id)sender {
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = floorf((LCDW-self.collectionViewFlowLayout.sectionInset.left-self.collectionViewFlowLayout.sectionInset.right-self.collectionViewFlowLayout.minimumInteritemSpacing)/2);
    return CGSizeMake(width, floorf((width *281)/173));
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 需要重构RootViewController,不然穿插跳转每次都需要遍历查找tabBarController
//    HomeTypeModels * model = [self.dataMArray objectAtIndex: indexPath.item];
//    
//    TTGoodsDetailViewController * next = [[TTGoodsDetailViewController alloc]init];
//    next.goodsId = model.goodsId;
//    next.storehouseCode = model.storehouseCode;
//    next.goodsDetailType = GoodsDetailTypeSearch;
//    [self.navigationController pushViewController:next animated:YES];
//    NSString *url = [NSString stringWithFormat:@"microants://productDetail?productId=%@&storehouseCode=%@",model.goodsId,model.storehouseCode];
//    [[UtilityRouter shareInstance]routerWithName:url withSoureController:self];
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

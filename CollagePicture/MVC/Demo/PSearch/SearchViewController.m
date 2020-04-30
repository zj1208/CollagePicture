//
//  SearchViewController.m
//  CollagePicture
//
//  Created by 朱新明 on 2019/10/24.
//  Copyright © 2019 simon. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCollectionReusableView.h"
#import "SearchCollectionHistoryCell.h"
#import "SearchCollectionViewCell.h"
#import "SearchCollectionViewHotCell.h"
#import "SearchCollectionViewLeftHotCell.h"
#import "TMDiskManager.h"
#import "SearchTitleModel.h"
#import "ZXCollectionViewLeftAlignedLayout.h"
#import "SearchSuggestionViewController.h"
#import "SearchResultsController.h"
#import "HomeViewController.h"

static NSString * const reuse_HeaderViewIdentifier = @"Header";
static NSString * const reuse_FooterViewIdentifier = @"Footer";

@interface SearchViewController ()<UISearchBarDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,SearchResultsControllerDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) TMDiskManager *diskManager;
@property (nonatomic, strong) NSMutableArray *searchHistoryMArray;
@property (nonatomic, strong) NSMutableArray *dataMArray;
@property (nonatomic, strong) SearchSuggestionViewController *suggestionController;
@property (nonatomic, strong) SearchResultsController *resultsController;
@property (nonatomic, strong) UIViewController *currentController;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    // Do any additional setup after loading the view.
    [self setData];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
// 不管searchResult还是自己，push离开（搜索模块）后pop回来，父视图控制器一定会回调；
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

    __block BOOL isContainSearchResults = NO;
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SearchResultsController class]]) {
            isContainSearchResults = YES;
        }
    }];
    if (!isContainSearchResults) {
        [self.searchBar becomeFirstResponder];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)dealloc
{
    
}


#pragma mark - setUI

- (void)setUI
{
    self.view.backgroundColor = [UIColor zx_colorWithHexString:@"#f3f3f3"];
    self.navigationItem.titleView = self.searchBar;
    
    [self.navigationController zx_navigationBar_removeShadowImage];

    [self.view addSubview:self.collectionView];
    
    [self addChildController];
}

- (void)addChildController
{
    [self addChildViewController:self.suggestionController];
    [self.view addSubview:self.suggestionController.view];
    [self.suggestionController didMoveToParentViewController:self];
    self.suggestionController.view.frame = self.view.frame;
    self.currentController = self.suggestionController;
    
    self.suggestionController.view.hidden = YES;
    // 点击冥想词回调搜索-跳转到搜索详情3
    WS(weakSelf);
    self.suggestionController.didSelectCellBlock = ^(NSIndexPath * _Nonnull indexPath, NSString * _Nonnull suggestionTitle) {
        
        [weakSelf addHistoryDataToArrayWithObject:suggestionTitle];
        
        [weakSelf.searchBar resignFirstResponder];

        weakSelf.resultsController.view.hidden = NO;
        
        [weakSelf addChildViewController:weakSelf.resultsController];
         //我可以自己设置二个来回动画哦
         UIViewAnimationOptions  animationOption =UIViewAnimationOptionTransitionCrossDissolve;

         [weakSelf transitionFromViewController:weakSelf.suggestionController toViewController:weakSelf.resultsController duration:0.2f options:animationOption animations:nil completion:^(BOOL finished) {

             //关闭finished判断，不然有时候会NO；
             [weakSelf.resultsController didMoveToParentViewController:weakSelf];
             [weakSelf.suggestionController willMoveToParentViewController:nil];
             [weakSelf.suggestionController removeFromParentViewController];

         }];
        
        [weakSelf.resultsController requestSearchDataWithText:suggestionTitle];
        
    };
}


- (SearchResultsController *)resultsController
{
    if (!_resultsController) {
        _resultsController = (SearchResultsController *)[self zx_getControllerWithStoryboardName:@"SearchStoryboard" controllerWithIdentifier:NSStringFromClass([SearchResultsController class])];
        _resultsController.delegate = self;
    }
    return _resultsController;
}
- (SearchSuggestionViewController *)suggestionController
{
    if (!_suggestionController) {
        
        _suggestionController = [[SearchSuggestionViewController alloc] init];
    }
    return _suggestionController;
}
- (UISearchBar *)searchBar
{
    if (!_searchBar)
    {
        UISearchBar *bar = [[UISearchBar alloc] init];
        bar.searchBarStyle = UISearchBarStyleMinimal;
        bar.tintColor = UIColorFromRGB(54.f, 180.f, 77.f);
        bar.placeholder = @"输入商品关键词搜索商品";
        [bar sizeToFit];
        bar.delegate = self;
        bar.barTintColor = [UIColor clearColor];
        bar.showsCancelButton = YES;
        
        [bar setImage:[UIImage imageNamed:@"ic_searchBar_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        UIButton *cancelBtn = [bar valueForKey:@"cancelButton"];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [cancelBtn setTitleColor:UIColorFromRGB(52.f, 55.f, 58.f) forState:UIControlStateNormal];
        
        UIImage *image = [UIImage imageNamed:@"icon_searchText_bg"];
        UIImage *resizableImage = [image resizableImageWithCapInsets: UIEdgeInsetsMake(0, image.size.width/2, 0, image.size.width/2)];
        [bar setSearchFieldBackgroundImage:resizableImage forState:UIControlStateNormal];
        bar.searchTextPositionAdjustment = UIOffsetMake(2, 0);
        
        if (@available(iOS 13.0, *)) {
            bar.searchTextField.textColor = [UIColor blackColor];
            bar.searchTextField.font = [UIFont systemFontOfSize:13];
        }else
        {
            [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]]
             setDefaultTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor blackColor]}];
        }
        _searchBar = bar;
    }
    return _searchBar;
}



- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        ZXCollectionViewLeftAlignedLayout *flowLayout = [[ZXCollectionViewLeftAlignedLayout alloc] init];
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        collection.backgroundColor = [UIColor whiteColor];
        collection.delegate = self;
        collection.dataSource = self;
        collection.keyboardDismissMode =  UIScrollViewKeyboardDismissModeOnDrag;
        collection.alwaysBounceVertical = YES;
        UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([SearchCollectionReusableView class]) bundle:nil];
        [collection registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuse_HeaderViewIdentifier];
        [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuse_FooterViewIdentifier];
        UINib *cellHistoryNib = [UINib nibWithNibName:NSStringFromClass([SearchCollectionHistoryCell class]) bundle:nil];
        [collection registerNib:cellHistoryNib forCellWithReuseIdentifier:@"HistoryCell"];
        UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([SearchCollectionViewCell class]) bundle:nil];
        [collection registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
        
        UINib *cellHotNib = [UINib nibWithNibName:NSStringFromClass([SearchCollectionViewHotCell class]) bundle:nil];
        [collection registerNib:cellHotNib forCellWithReuseIdentifier:@"HotCell"];
        UINib *cellLeftHotNib = [UINib nibWithNibName:NSStringFromClass([SearchCollectionViewLeftHotCell class]) bundle:nil];
          [collection registerNib:cellLeftHotNib forCellWithReuseIdentifier:@"LeftHotCell"];
        _collectionView = collection;
    }
    return _collectionView;
}


#pragma mark - setData
- (void)setData
{
    self.searchHistoryMArray =  [self.diskManager getData];
    
    SearchTitleModel *model = [SearchTitleModel new];
    model.groupName = @"才划算杭州滨江店 实时热搜";
    model.ifPaging = YES;
    
    SearchTitleModelSub *modelSub = [SearchTitleModelSub new];
    modelSub.name = @"香蕉";
    modelSub.preIcon = @"http://192.168.31.200:3000/api/user/avatar?uid=213";
    modelSub.suffIcon = @"";
    modelSub.bgColor = @"";
    
    SearchTitleModelSub *modelSub1 = [SearchTitleModelSub new];
     modelSub1.name = @"牛奶";
     modelSub1.preIcon = @"";
     modelSub1.suffIcon = @"http://192.168.31.200:3000/api/user/avatar?uid=213";
     modelSub1.bgColor = @"FFF3F3";
    model.worlds = [NSArray arrayWithObjects:modelSub,modelSub1, nil];

    [self.dataMArray addObject:model];
    
      SearchTitleModel *model1 = [SearchTitleModel new];
      model1.groupName = @"实时热搜";
      model1.ifPaging = NO;
      
      SearchTitleModelSub *model1Sub1 = [SearchTitleModelSub new];
      model1Sub1.name = @"鸡蛋";
      model1Sub1.preIcon = @"";
      model1Sub1.suffIcon = @"";
     model1Sub1.bgColor = @"";
    model1Sub1.appUrl = @"mic";

    model1.worlds = [NSArray arrayWithObjects:model1Sub1, nil];
    
    [self.dataMArray addObject:model1];
    
    [self.collectionView reloadData];

}

- (NSMutableArray *)searchHistoryMArray
{
    if (!_searchHistoryMArray) {
        _searchHistoryMArray = [NSMutableArray array];
    }
    return _searchHistoryMArray;
}

- (NSMutableArray *)dataMArray
{
    if (!_dataMArray) {
        _dataMArray = [NSMutableArray array];
    }
    return _dataMArray;
}


- (TMDiskManager *)diskManager
{
    if (!_diskManager) {
        
        _diskManager = [[TMDiskManager alloc] initWithObjectKey:TMDSearchHistoryKey];
    }
    return _diskManager;
}

#pragma mark - SearchResultsControllerDelegate
//searchViewController在搜索结果来回切换的时候依然一直展示着；所以需要自己设置bar隐藏
- (void)textFieldEditingBegainActionWithSearchTitle:(NSString *)searchTitle
{
    [self addChildViewController:self.suggestionController];
    self.searchBar.text = searchTitle;
    
    [self.navigationController setNavigationBarHidden:NO];

    self.suggestionController.view.hidden = YES;
     UIViewAnimationOptions  animationOption =UIViewAnimationOptionTransitionCrossDissolve;

     [self transitionFromViewController:self.resultsController toViewController:self.suggestionController duration:0.2f options:animationOption animations:nil completion:^(BOOL finished) {

         [self.suggestionController didMoveToParentViewController:self];
         [self.resultsController willMoveToParentViewController:nil];
         [self.resultsController removeFromParentViewController];

     }];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.searchBar canBecomeFirstResponder]) {
            [self.searchBar becomeFirstResponder];
        }
    });
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if([searchBar isFirstResponder])
    {
        [searchBar resignFirstResponder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 点击搜索按钮-根据searchBar的text搜索-跳转到搜索详情2
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *text = [NSString zhFilterInputTextWithWittespaceAndLine:searchBar.text];
    if ([NSString zhIsBlankString:text]) {
        return ;
    }

    UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"];
    cancelBtn.enabled = YES;
    
    [self addHistoryDataToArrayWithObject:searchBar.text];
    [self goToSearchResultControllerWithSearchTitle:text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *text = [NSString zhFilterInputTextWithWittespaceAndLine:searchText];
    if ([NSString zhIsBlankString:text]) {
        self.suggestionController.view.hidden = YES;
        return;
    }
    
//    [self requestSuggestionWithText:searchText];
//    请求冥想词数组
    NSArray *arr = @[@"123",@"1899912",@"8712",@"09809812",@"00812481"];
    if (arr.count >0) {
        self.suggestionController.searchText = text;
        self.suggestionController.searchSuggestionsArray = arr;
        self.suggestionController.view.hidden = NO;
    }
    else
    {
        self.suggestionController.view.hidden = YES;
    }
}

#pragma mark -
- (void)addHistoryDataToArrayWithObject:(id)obj
{
    if ([self.searchHistoryMArray containsObject:obj])
    {
        NSInteger index = [self.searchHistoryMArray indexOfObject:obj];
        [self.searchHistoryMArray removeObjectAtIndex:index];
        [self.searchHistoryMArray insertObject:obj atIndex:0];
    }
    else
    {
        [self.searchHistoryMArray insertObject:obj atIndex:0];
        if (self.searchHistoryMArray.count>10) {
            [self.searchHistoryMArray removeLastObject];
        }
    }
    [self.diskManager setData:self.searchHistoryMArray];
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataMArray.count+1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.searchHistoryMArray.count;
    }
    SearchTitleModel *titleModel = [self.dataMArray objectAtIndex:section-1];
    return titleModel.worlds.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SearchCollectionHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryCell" forIndexPath:indexPath];
        [cell setData:[self.searchHistoryMArray objectAtIndex:indexPath.item]];
        return cell;
    }
    SearchTitleModel *titleModel = [self.dataMArray objectAtIndex:indexPath.section-1];
    SearchTitleModelSub *titleModelSub = [titleModel.worlds objectAtIndex:indexPath.item];
    if (![NSString zhIsBlankString:titleModelSub.preIcon]) {
        
        SearchCollectionViewLeftHotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LeftHotCell" forIndexPath:indexPath];
        cell.titleLab.text = titleModelSub.name;
        cell.contentView.backgroundColor =[NSString zhIsBlankString:titleModelSub.bgColor]? [UIColor zx_colorWithHexString:@"F5F6F7"]: [UIColor zx_colorWithHexString:titleModelSub.bgColor];
        cell.hotIconImageView.image = [UIImage imageNamed:@"m_cleanCache"];
        return cell;
    }
    else if (![NSString zhIsBlankString:titleModelSub.suffIcon])
    {
        SearchCollectionViewHotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotCell" forIndexPath:indexPath];
        cell.titleLab.text = titleModelSub.name;
        cell.contentView.backgroundColor =[NSString zhIsBlankString:titleModelSub.bgColor]? [UIColor zx_colorWithHexString:@"F5F6F7"]: [UIColor zx_colorWithHexString:titleModelSub.bgColor];
        cell.hotIconImageView.image = [UIImage imageNamed:@"m_cleanCache"];
        return cell;
    }
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.titleLab.text = titleModelSub.name;
    cell.contentView.backgroundColor =[NSString zhIsBlankString:titleModelSub.bgColor]? [UIColor zx_colorWithHexString:@"F5F6F7"]: [UIColor zx_colorWithHexString:titleModelSub.bgColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
     {
         SearchCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuse_HeaderViewIdentifier forIndexPath:indexPath];
         view.backgroundColor = [UIColor whiteColor];
        [view.rightIconBtn addTarget:self action:@selector(rightIconBtnAction:) forControlEvents:UIControlEventTouchUpInside];
         view.rightIconBtn.tag = 200 + indexPath.section;
         view.rightIconBtn.userInteractionEnabled = YES;
         if (indexPath.section ==0)
         {
             view.titleLab.text = @"历史搜索";
             [view.rightIconBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
         }
         else
         {
             SearchTitleModel *titleModel = [self.dataMArray objectAtIndex:indexPath.section-1];
             
             view.titleLab.text = titleModel.groupName;
             if (titleModel.ifPaging)
            {
                 [view.rightIconBtn setImage:[UIImage imageNamed:@"icon_form"] forState:UIControlStateNormal];
            }
            else
            {
                view.rightIconBtn.userInteractionEnabled = NO;
                [view.rightIconBtn setImage:nil forState:UIControlStateNormal];
            }
         }
      
         return view;
     }
     UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuse_FooterViewIdentifier forIndexPath:indexPath];
     view.backgroundColor = self.view.backgroundColor;
     return view;
}

#pragma mark - UICollectionViewDelegateFlowlayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 10, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 13;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.searchHistoryMArray.count == 0 ? CGSizeZero :CGSizeMake(LCDW, 40);
    }
    return CGSizeMake(LCDW, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
         static SearchCollectionHistoryCell *cell =  nil;
         static dispatch_once_t onceToken;
         
         dispatch_once(&onceToken, ^{
             
             if (cell == nil) {
                 cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SearchCollectionHistoryCell class]) owner:nil options:nil][0];
             }
         });
         cell.titleLab.text = [self.searchHistoryMArray objectAtIndex:indexPath.item];
         return [cell sizeForCell];
    }
    SearchTitleModel *titleModel = [self.dataMArray objectAtIndex:indexPath.section-1];
    SearchTitleModelSub *titleModelSub = [titleModel.worlds objectAtIndex:indexPath.item];
    if (![NSString zhIsBlankString:titleModelSub.preIcon] || ![NSString zhIsBlankString:titleModelSub.suffIcon]) {
         
           static SearchCollectionViewHotCell *cell =  nil;
           static dispatch_once_t onceToken1;
         
           dispatch_once(&onceToken1, ^{
             
             if (cell == nil) {
                 cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SearchCollectionViewHotCell class]) owner:nil options:nil][0];
             }
         });
           cell.titleLab.text = titleModelSub.name;
           return [cell sizeForCell];
     }
 
   static SearchCollectionViewCell *cell =  nil;
   static dispatch_once_t onceToken;
   
   dispatch_once(&onceToken, ^{
       
       if (cell == nil) {
           cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SearchCollectionViewCell class]) owner:nil options:nil][0];
       }
   });
   cell.titleLab.text = titleModelSub.name;
   return [cell sizeForCell];
}

#pragma mark - UICollectionViewDelegate

// 点击搜索推荐，历史搜索词等-跳转到搜索详情1
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        id obj = [self.searchHistoryMArray objectAtIndex:indexPath.item];
        [self addHistoryDataToArrayWithObject:obj];
        [self goToSearchResultControllerWithSearchTitle:obj];
    }
    else
    {
        SearchTitleModel *titleModel = [self.dataMArray objectAtIndex:indexPath.section-1];
        SearchTitleModelSub *titleModelSub = [titleModel.worlds objectAtIndex:indexPath.item];
        [self addHistoryDataToArrayWithObject:titleModelSub.name];
        if (![NSString zhIsBlankString:titleModelSub.appUrl]) {
              
            HomeViewController *vc = [[HomeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
//              [self routerWithName:titleModelSub.appUrl navigationItemTitle:titleModelSub.name];
          }
          else
          {
              [self goToSearchResultControllerWithSearchTitle:titleModelSub.name];
          }
    }
}


- (void)goToSearchResultControllerWithSearchTitle:(NSString *)searchTitle
{
    if([self.searchBar isFirstResponder])
    {
        [self.searchBar resignFirstResponder];
    }
     self.resultsController.view.hidden = NO;
     
     [self addChildViewController:self.resultsController];
      //我可以自己设置二个来回动画哦
      UIViewAnimationOptions  animationOption =UIViewAnimationOptionTransitionCrossDissolve;

      [self transitionFromViewController:self.suggestionController toViewController:self.resultsController duration:0.2f options:animationOption animations:nil completion:^(BOOL finished) {

          //关闭finished判断，不然有时候会NO；
          [self.resultsController didMoveToParentViewController:self];
          [self.suggestionController willMoveToParentViewController:nil];
          [self.suggestionController removeFromParentViewController];

      }];
     
     [self.resultsController requestSearchDataWithText:searchTitle];
     
}

#pragma mark - buttonAction
- (void)rightIconBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 200) {
        [self.diskManager removeData];
        [self.searchHistoryMArray removeAllObjects];
        [self.collectionView reloadData];
    }else
    {
//        SearchTitleModel *titleModel = [self.dataMArray objectAtIndex:btn.tag-200-1];
//        [self requestLabelPageDataWithRecommendGroupId:titleModel.groupCode next:titleModel.next];
    }
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

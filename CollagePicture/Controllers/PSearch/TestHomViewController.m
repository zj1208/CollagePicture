//
//  TestHomViewController.m
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/10/30.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "TestHomViewController.h"

#import "PrefectureCollectionCellTypeA.h"
#import "PrefectureCollectionCellTypeB.h"
#import "PrefectureCollectionCellTypeC.h"

static NSString * const reuse_HeaderViewIdentifier = @"Header";
static NSString * const reuse_FooterViewIdentifier = @"Footer";
@interface TestHomViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TestHomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
#pragma mark - setUI

- (void)setUI
{
    self.view.backgroundColor = [UIColor zx_colorWithHexString:@"#f3f3f3"];

    [self.view addSubview:self.collectionView];
    

}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        collection.backgroundColor = self.view.backgroundColor;
        collection.delegate = self;
        collection.dataSource = self;
        collection.keyboardDismissMode =  UIScrollViewKeyboardDismissModeOnDrag;
        collection.alwaysBounceVertical = YES;
        UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([UICollectionReusableView class]) bundle:nil];
        [collection registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuse_HeaderViewIdentifier];
        [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuse_FooterViewIdentifier];
        
        [collection registerClass:[PrefectureCollectionCellTypeA class] forCellWithReuseIdentifier:@"Cell"];
        
        [collection registerClass:[PrefectureCollectionCellTypeB class] forCellWithReuseIdentifier:@"CellB"];
        [collection registerClass:[PrefectureCollectionCellTypeC class] forCellWithReuseIdentifier:@"CellC"];

//        UINib *cellHistoryNib = [UINib nibWithNibName:NSStringFromClass([SearchCollectionHistoryCell class]) bundle:nil];
//        [collection registerNib:cellHistoryNib forCellWithReuseIdentifier:@"HistoryCell"];
//        UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([SearchCollectionViewCell class]) bundle:nil];
//        [collection registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
//
//        UINib *cellHotNib = [UINib nibWithNibName:NSStringFromClass([SearchCollectionViewHotCell class]) bundle:nil];
//        [collection registerNib:cellHotNib forCellWithReuseIdentifier:@"HotCell"];
//        UINib *cellLeftHotNib = [UINib nibWithNibName:NSStringFromClass([SearchCollectionViewLeftHotCell class]) bundle:nil];
//          [collection registerNib:cellLeftHotNib forCellWithReuseIdentifier:@"LeftHotCell"];
        _collectionView = collection;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        PrefectureCollectionCellTypeB *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellB" forIndexPath:indexPath];
        return cell;
    }
    if (indexPath.section == 2) {
        PrefectureCollectionCellTypeC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellC" forIndexPath:indexPath];
        return cell;
    }
    PrefectureCollectionCellTypeA *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowlayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat lWidth = LCDW-20;

    if (indexPath.section == 1 || indexPath.section ==2) {
       
        return CGSizeMake(lWidth, floorf(lWidth*(274.f/355)));
    }
    CGFloat height = floorf(lWidth*(159.f/355));
    return CGSizeMake(lWidth, height);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
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

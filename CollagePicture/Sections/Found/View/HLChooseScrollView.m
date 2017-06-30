//
//  HLChooseScrollView.m
//  HappyLottery
//
//  Created by 蔡叶超 on 6/27/17.
//  Copyright © 2017 cyc. All rights reserved.
//

#import "HLChooseScrollView.h"
#import "HLChooseScrollCollectionCell.h"


@interface HLChooseScrollView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation HLChooseScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowlayout];
        self.collectionView.showsVerticalScrollIndicator = FALSE;
        self.collectionView.showsHorizontalScrollIndicator = FALSE;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"HLChooseScrollCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
        
        
        self.selecetedIndex = 0;
    }
    return self;
}


- (void)setSelecetedIndex:(NSInteger)selecetedIndex {
    _selecetedIndex = selecetedIndex;
    if ([self.collectionView numberOfItemsInSection:0] > selecetedIndex) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:selecetedIndex inSection:0]  animated:TRUE scrollPosition:UICollectionViewScrollPositionTop];
    }
}

- (void)setDataSource:(id<HLChooseScrollViewDataSource>)dataSource {
    
    _dataSource = dataSource;
    [self.collectionView reloadData];
    // 默认选中第一个
    if ([self.collectionView numberOfItemsInSection:0] != 0) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]  animated:TRUE scrollPosition:UICollectionViewScrollPositionTop];
    }
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HLChooseScrollCollectionCell *cell = (HLChooseScrollCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.dataSource categoryArr][indexPath.row];
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(categoryArr)]) {
     
        return [self.dataSource categoryArr].count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    printf("%ld", (long)indexPath.row);
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseScrollView:DidSelected:)]) {
        [self.delegate chooseScrollView:self DidSelected:indexPath.row];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH / 4, collectionView.mj_h - 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}
@end

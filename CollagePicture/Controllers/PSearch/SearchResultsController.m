//
//  SearchResultsController.m
//  CollagePicture
//
//  Created by 朱新明 on 2019/10/25.
//  Copyright © 2019 simon. All rights reserved.
//

#import "SearchResultsController.h"

@interface SearchResultsController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@end

@implementation SearchResultsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
}

- (void)setUI
{
    self.collectionView.backgroundColor = [UIColor zx_colorWithHexString:@"#f3f3f3"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectionViewFlowLayout.minimumInteritemSpacing = 9;
    self.collectionViewFlowLayout.minimumLineSpacing = 10;
}

- (IBAction)goBackAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textFieldEditingBegainAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(textFieldEditingBegainAction)]) {
        [self.delegate textFieldEditingBegainAction];
    }
}

- (void)requestSearchDataWithText:(NSString *)text{
 
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end

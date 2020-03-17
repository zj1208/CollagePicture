//
//  ZXCollectionReusableTitleView.h
//  MobileCaiLocal
//
//  Created by 朱新明 on 2019/11/4.
//  Copyright © 2019 timtian. All rights reserved.
//
// 简介：UICollectionView的组头，纯title展示；
/*
(1)组头/组尾必须从【dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:】回调，即使只需要组头，组尾也必须同时返回，不然崩溃；
(2)必须始终返回有效的视图对象，不能返回nil;不然崩溃；
(3)您可以通过将相应属性的hidden属性设置为YES或将属性的alpha属性设置为0来隐藏视图。要在流布局中隐藏页眉和页脚视图，还可以将这些视图的宽度和高度设置为0。
(4)这个视图的宽度不需要我们设置，始终是colletionView的宽度；
*/

// 2020.3.04 修改注释；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCollectionReusableTitleView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//设置label与superView左对齐的约束偏移,默认constant=10;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabLeadingLayoutConstraint;
//设置label与superView居中对齐的约束偏移,默认constant=0;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabCenterYLayoutConstraint;

@end

NS_ASSUME_NONNULL_END
//用例
/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader){
     
        ZXCollectionReusableTitleView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuse_Header forIndexPath:indexPath];
        headerView.titleLabCenterYLayoutConstraint.constant = 5;
        headerView.titleLabel.font = [UIFont zx_systemFontOfScaleSize:20 weight:UIFontWeightMedium];
        if (self.prefectureMArray.count >0) {
             headerView.titleLabel.text = @"优享专区";
        }
        return headerView;
    }
    UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reuse_Footer" forIndexPath:indexPath];
    return footerView;
}
*/

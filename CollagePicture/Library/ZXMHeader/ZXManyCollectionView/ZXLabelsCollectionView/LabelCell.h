//
//  LabelCell.h
//  YiShangbao
//
//  Created by simon on 17/2/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  2017.12.26
//  修改nibName 常量定义 改为NSStringFromClass；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LabelCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic, assign)CGFloat height;


- (CGSize)sizeForCell;

@end


NS_ASSUME_NONNULL_END

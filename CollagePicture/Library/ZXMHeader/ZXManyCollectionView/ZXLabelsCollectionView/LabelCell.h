//
//  LabelCell.h
//  YiShangbao
//
//  Created by simon on 17/2/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *nibName_LabelCell = @"LabelCell";

@interface LabelCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


- (CGSize)sizeForCell;


@end

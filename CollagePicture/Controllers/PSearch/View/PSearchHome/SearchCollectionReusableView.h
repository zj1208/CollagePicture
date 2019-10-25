//
//  SearchCollectionReusableView.h
//  CollagePicture
//
//  Created by 朱新明 on 2019/10/24.
//  Copyright © 2019 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIButton *rightIconBtn;

@end

NS_ASSUME_NONNULL_END

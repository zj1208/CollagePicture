//
//  ZXAddProPicCollectionCell.h
//  YiShangbao
//
//  Created by simon on 17/3/3.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "ZXAddProPicView.h"
//图片模型
#import "ZXPhoto.h"

@interface ZXAddProPicCollectionCell : UICollectionViewCell



@property (nonatomic, strong)ZXAddProPicView * itemView;


- (void)setData:(id)data;

@end

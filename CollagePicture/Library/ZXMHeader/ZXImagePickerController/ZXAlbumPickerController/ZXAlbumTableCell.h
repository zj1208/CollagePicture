//
//  ZXAlbumTableCell.h
//  FunLive
//
//  Created by simon on 2019/4/23.
//  Copyright © 2019 facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "ZXPHPhotoManager.h"

NS_ASSUME_NONNULL_BEGIN


@class ZXAlbumModel;
@interface ZXAlbumTableCell : UITableViewCell

@property (nonatomic, strong) ZXAlbumModel *albumModel;

@end

NS_ASSUME_NONNULL_END

//
//  ZXAssetModel.h
//  FunLive
//
//  Created by simon on 2019/4/28.
//  Copyright © 2019 facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXAssetModel : NSObject

@end


@interface ZXAlbumModel : NSObject

@property (nonatomic, copy) NSString *title;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property (nonatomic, strong) id result;             ///< PHFetchResult<PHAsset>

//@property (nonatomic, strong) NSArray *models;
//@property (nonatomic, strong) NSArray *selectedModels;
//@property (nonatomic, assign) NSUInteger selectedCount;
//
//是否是“所有照片”
@property (nonatomic, assign) BOOL isCameraRoll;

@end

NS_ASSUME_NONNULL_END

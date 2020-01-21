//
//  AliOSSPicInfoRequest.h
//  YiShangbao
//
//  Created by simon on 17/3/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
// 2017.12.29
// 添加nonnull；

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ZXCompletedBlock)(id _Nullable data,CGSize picSize,NSError *_Nullable error);

@interface AliOSSPicInfoRequest : NSObject



+ (void)ossGetPicInfoWithBasePicURL:(nullable NSString *)baseURL sucess:(nonnull ZXCompletedBlock)complete;

@end

NS_ASSUME_NONNULL_END

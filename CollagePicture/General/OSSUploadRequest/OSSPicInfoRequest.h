//
//  OSSPicInfoRequest.h
//  YiShangbao
//
//  Created by simon on 17/3/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^ZXCompletedBlock)(id _Nullable data,CGSize picSize,NSError *_Nullable error);

@interface OSSPicInfoRequest : NSObject



+ (void)ossGetPicInfoWithBasePicURL:(nullable NSString *)baseURL sucess:(nonnull ZXCompletedBlock)complete;

@end

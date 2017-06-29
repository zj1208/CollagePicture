//
//  UploadGrowOperation.h
//  Baby
//
//  Created by simon on 16/4/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadTable.h"

/**
 *  上传进度block
 *
 *  @param progress progress description
 */
typedef void(^ZXImageUploadProgressBlock)(NSProgress* progress);
/**
 *  上传全部成功
 *
 */
typedef void(^ZXImageUploadCompletedBlock)(NSProgress* progress);
/**
 *  上传单个成功
 *
 *  @param model     成功上传的model
 *  @param imageName 图片http地址
 *  @param imgId     图片id
 */
typedef void(^ZXImageUploadSingleCompletedBlock) (id model,NSString*imageName,NSNumber *imgId);
typedef void (^ZXImageUploadFailureBlock)(NSError *error);


@class UploadGrowOperation;
@protocol MerchantTaskDelegate <NSObject>

- (void) merchantTaskOperationBegainUpload:(UploadGrowOperation *)uploader;

@end

@interface UploadGrowOperation : NSOperation
@property (nonatomic,weak) id<MerchantTaskDelegate>delegate;
@property (nonatomic,strong) UploadTable *uploadTable;


- (id)initWithRequest:(UploadTable *)model
             delegate:(id<MerchantTaskDelegate>)theDelegate
             progress:(ZXImageUploadProgressBlock)progressBlock
       singleComplete:(ZXImageUploadSingleCompletedBlock)signleCompleteBlock
         allCompleted:(ZXImageUploadCompletedBlock)completedBlock
              failure:(ZXImageUploadFailureBlock)failure;

@end

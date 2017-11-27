//
//  UploadGrowOperation.m
//  Baby
//
//  Created by simon on 16/4/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "UploadGrowOperation.h"
//#import <QiniuSDK.h>
#import "AppAPIHelper.h"
//#import "GrowthDataManager.h"
#import "PendingOperations.h"
#import "SDImageCache.h"
#import "UserInfoUDManager.h"
@interface UploadGrowOperation ()

@property (copy,nonatomic) ZXImageUploadProgressBlock progressBlock;
@property (copy,nonatomic) ZXImageUploadCompletedBlock completedBlock;
@property (copy,nonatomic) ZXImageUploadFailureBlock failuerBlock;
@property (nonatomic,copy) ZXImageUploadSingleCompletedBlock singleCompletedBlock;

@property (nonatomic)NSInteger currentIndex;
@end

@implementation UploadGrowOperation
- (id)initWithRequest:(UploadTable *)model
             delegate:(id<MerchantTaskDelegate>)theDelegate
             progress:(ZXImageUploadProgressBlock)progressBlock
       singleComplete:(ZXImageUploadSingleCompletedBlock)signleCompleteBlock
         allCompleted:(ZXImageUploadCompletedBlock)completedBlock
              failure:(ZXImageUploadFailureBlock)failure
{
    if (self = [super init])
    {
        _delegate = theDelegate;
        _uploadTable = model;
        _progressBlock = [progressBlock copy];
        _completedBlock = [completedBlock copy];
        _failuerBlock = [failure copy];
        _singleCompletedBlock =[signleCompleteBlock copy];
        
    }
    return self;
    
}


- (void)main
{
    @autoreleasepool {
        
        self.uploadTable.starting = YES;
        [self uploadImages];
    }
}

/**
 *  上传图片
 */
- (void)uploadImages
{
    if (self.uploadTable.upload_imagesModels.count==0)
    {
        return;
    }
//    NSLog(@"NSThread3=%@",[NSThread currentThread]);//NSThread3=<NSThread: 0x7fdb6b5ab900>{number = 19, name = (null)}

    NSProgress *progress = [NSProgress progressWithTotalUnitCount:self.uploadTable.upload_imagesModels.count];

    WS(weakSelf);
    [self.uploadTable.upload_imagesModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx==0)
        {
            
            [_delegate merchantTaskOperationBegainUpload:weakSelf];
        }

        [progress becomeCurrentWithPendingUnitCount:1];
        [weakSelf workWithModel:obj withProgress:progress];
        [progress resignCurrent];
    }];
        
}



- (void)workWithModel:(GrowthSavePhotoModel *)model withProgress:(NSProgress *)progress
{
    /*
    NSProgress *taskProgress = [NSProgress progressWithTotalUnitCount:100];
    //不管成功与否都提示进度
    [[[AppAPIHelper shareInstance] getThemeModelAPI]putData:model type:model.type subjectId:model.subjectId operationId:model.uploadId  photoTime:model.photoTime progress:^(NSProgress *uploadProgress) {
        
//      ios7-刚一开始返回：uploadProgress=<NSProgress: phase=Loading; state=Waiting; fractionCompleted=1.000000>： completedUnitCount＝32768,totalUnitCount＝0；
//        这个上传iOS7 不回返回上传进度，直接返回错误totalUnitCount ＝－1；；
//      iOS8-刚一开始返回： <NSProgress: 0x7f90fa9ec1e0> : Parent: 0x0 / Fraction completed: 1.0000 / Completed: 32768 of 0;
//        正式上传完成的时候，totalUnitCount ＝99677；会返回n次进度；
//        由于一开始就返回了完成百分比100%，所以为了兼容iOS8必须需要判断；
        
//        NSLog(@"uploadProgress=%@,%lld,%lld",uploadProgress,uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);

        //iOS7 不回返回上传进度，直接返回错误totalUnitCount ＝－1,暂时无法解决；
        if (Device_SYSTEMVERSION<8.0)
        {
//            if (uploadProgress.totalUnitCount!=0 && !uploadProgress.paused &&!uploadProgress.cancelled)
//            {
//                taskProgress.completedUnitCount = uploadProgress.fractionCompleted*100;
//            }
        }
        else
        {
            if (uploadProgress.totalUnitCount>0 &&!uploadProgress.paused &&!uploadProgress.cancelled)
            {
                taskProgress.completedUnitCount = uploadProgress.fractionCompleted*100;
                _progressBlock(progress);
            }
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        _currentIndex++;
        _singleCompletedBlock(model,nil,nil);
        if (Device_SYSTEMVERSION<8.0)
        {
            taskProgress.completedUnitCount = 100;
             _progressBlock(progress);
        }
        if (_currentIndex ==self.uploadTable.upload_imagesModels.count)
        {
            _completedBlock(progress);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        _currentIndex++;
        if (_currentIndex ==self.uploadTable.upload_imagesModels.count)
        {
            _completedBlock(progress);
        }
        _failuerBlock(error);
    }];
     */
}


@end

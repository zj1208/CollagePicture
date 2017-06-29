//
//  PendingOperations.h
//  Baby
//
//  Created by simon on 16/3/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UploadTable.h"
#import "GrowthDataManager.h"
#import "UploadOperationModel.h"
#import "UploadGrowOperation.h"

//上传进度
#define kNOTIFICATION_UPLOAD_Progress           @"kNotificationUploadProgress"
//上传失败
#define kNOTIFICATION_UPLOAD_Failure          @"kNotificationUplaodFailure"
//添加上传队列
#define kNOTIFICATION_UPLOAD_AddOperation      @"kNotificationAddOperation"
//上传完成
#define kNOTIFICATION_UPLOAD_AllFinished          @"kNotificationUplaodAllFinished"
//开始上传
#define kNOTIFICATION_UPLOAD_Begain           @"kNotificationUploadBegain"



@interface PendingOperations : NSObject<MerchantTaskDelegate>
/**
 *  记录哪些已经在队列里了，可以根据albumId等记录
 */
@property(nonatomic,strong)NSMutableDictionary *uploadInProgress;

/**
 *  上传真实数据数组，一个组为一个数据
 */
@property(nonatomic,strong)NSMutableArray *uploadMArray;

@property(nonatomic,strong)NSMutableDictionary *uploadFinishProgress;

/**
 *  队列
 */
@property(nonatomic,strong)NSOperationQueue *uploadQueue;


+(instancetype)getInstance;

/**
 *  根据numId与uploadMArray中的model对象的id比较得到数组中的索引
 *
 *  @param numId numId description
 *
 *  @return return value description
 */
- (NSInteger)zGetIndexFormOperationUploadMArray:(NSNumber *)numId;

/**
 *  data:
 {
	operationId = 2137;
	subjectId = 588;
	type = 1;
	themeId = 42;
 }
 */
- (void)makeDataWithSelectAssets:(NSArray *)assets isOriginal:(BOOL)original reqeustData:(id)data ;


/**
 *  开始上传
 *
 *  @param table table description
 */
- (void)startOperationsForTaskRecord:(UploadTable *)table;

@end

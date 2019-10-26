//
//  PendingOperations.m
//  Baby
//
//  Created by simon on 16/3/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "PendingOperations.h"
#import "Mantle.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <SDWebImage/SDWebImage.h>

@implementation PendingOperations
- (instancetype)init
{
    if (self = [super init])
    {
        self.uploadQueue = [[NSOperationQueue alloc] init];
        self.uploadQueue.name = @"Upload Queue";
        self.uploadQueue.maxConcurrentOperationCount = 1;
        
        self.uploadMArray = [[NSMutableArray alloc] init];
        self.uploadInProgress = [[NSMutableDictionary alloc] init];
    }
    return self;
}



+ (instancetype)sharedInstance
{
    static PendingOperations *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[PendingOperations alloc] init];
        
    });
    return manager;
}

/**
 *  根据uploadId来获取上传队列中数组的索引
 *
 *  @param numId numId description
 *
 *  @return return value description
 */
- (NSInteger)zGetIndexFormOperationUploadMArray:(NSNumber *)numId
{
    __block NSInteger index ;
    [self.uploadMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UploadTable *table = (UploadTable *)obj;
        if ([table.uploadId isEqualToNumber:numId])
        {
            index = idx;
            *stop = YES;
        }
    }];
//    NSLog(@"index=%@",@(index));
    return index;
}


- (void)makeDataWithSelectAssets:(NSArray *)assets isOriginal:(BOOL)original reqeustData:(id)data
{
    if ([data isKindOfClass:[UploadOperationModel class]])
    {
        UploadOperationModel *model = (UploadOperationModel *)data;
        [self uploadGetData:assets withUploadId:model isOriginal:original];
    }
}

/**
 *  根据asset资源数组和uploadId，original创建本地数组数据；
 *
 *  @param assets   asset资源数组
 *  @param operationModel 上传id
 *  @param original 是否压缩
 */
- (void)uploadGetData:(NSArray *)assets withUploadId:(UploadOperationModel *)operationModel isOriginal:(BOOL)original
{
    if (!operationModel || assets.count==0)
    {
        return;
    }
//    _isNeedUpload = YES;
    
    SDImageCache *cache = [SDImageCache sharedImageCache];
//    cache.shouldCacheImagesInMemory=YES;
    
    NSMutableArray *uploadArray = [[NSMutableArray alloc] init];
    [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        @autoreleasepool{
            
            ALAsset *asset = (ALAsset *)obj;
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            UIImage *image = [[UIImage alloc] initWithCGImage:representation.fullResolutionImage scale:representation.scale orientation:(UIImageOrientation)representation.orientation];
            NSLog(@"%@",[asset valueForProperty:ALAssetPropertyDate]);
            NSString *key = [GrowthDataManager getPhotoImageKey:operationModel.operationId sortId:@(idx)];
            if (!original)
            {
//                image =[ZSimageUtil imageWithImageSimple:image compressionRatio:0.3];
            }
            [cache storeImage:image forKey:key completion:nil];
            
            GrowthSavePhotoModel *model = [[GrowthSavePhotoModel alloc] init];
            model.uploadId =operationModel.operationId;
            model.sort = @(idx);
            model.imagePath = key;
            model.width = @(representation.dimensions.width);
            model.height = @(representation.dimensions.height);
            model.photoTime = [asset valueForProperty:ALAssetPropertyDate];
            model.isCompression = !original;
            model.subjectId = operationModel.subjectId;
            model.themeId = operationModel.themeId;
            model.type = operationModel.type;
            [uploadArray addObject:model];
        }
    }];
    //保存显示用的小图
//    cache.shouldCacheImagesInMemory=YES;
    UIImage *firstImg =[UIImage imageWithCGImage:[[assets firstObject]aspectRatioThumbnail]];
    NSString *key = [GrowthDataManager getSDImageCacheSmallImgKey:operationModel.operationId sortId:@(0)];
    [cache storeImage:firstImg forKey:key toDisk:YES completion:nil];

    //把所有GrowthSavePhotoModel保存在本地
    [[GrowthDataManager getInstance]insertData:uploadArray withAlbumId:operationModel.operationId];
    
    //发送通知，告诉准备开始上传了
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATION_UPLOAD_Begain object:nil userInfo:nil];

    UploadTable *table = [[UploadTable alloc] init];
    table.uploadId = operationModel.operationId;
    table.upload_imagesModels = uploadArray;
    table.upload_progressType = UploadProgressType_willUpload;
    [self startOperationsForTaskRecord:table];
}



- (void)startOperationsForTaskRecord:(UploadTable *)table
{
    if (!table.isStarting)
    {
        [self startTaskingForRecord:table];
    }
}




- (void)startTaskingForRecord:(UploadTable *)table
{
    if (![self.uploadInProgress.allKeys containsObject:table.uploadId])
    {
        [self.uploadMArray addObject:table];
        
        if (self.uploadInProgress.allKeys.count>=1)
        {
            UploadTable *record = [[UploadTable alloc] init];
            record.upload_progressType = UploadProgressType_wait;
            record.upload_imagesModels = table.upload_imagesModels;
            record.uploadId = table.uploadId;
            record.starting = YES;
            
            NSInteger index = [self zGetIndexFormOperationUploadMArray:table.uploadId];
            [self.uploadMArray replaceObjectAtIndex:index withObject:record];
            
            NSError *error = nil;
            NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:record error:&error];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATION_UPLOAD_AddOperation object:nil userInfo:dic];
            
            NSLog(@"%@",self.uploadMArray);
        }
        

        [self uploadPicForRecord:table];
    }
}




- (void)uploadPicForRecord:(UploadTable *)table
{
    
    GrowthDataManager *growthManager=  [GrowthDataManager getInstance];
    UploadGrowOperation *operation = [[UploadGrowOperation alloc] initWithRequest:table delegate:self progress:^(NSProgress* progress) {
        
        //上传进度反馈
//        NSLog(@"progress =%@,table =%@",progress,table);
        if (progress.fractionCompleted >=1)
        {
            table.upload_progressType = UploadProgressType_finish;
        }
        else
        {
            table.upload_progressType = UploadProgressType_uploading;
        }
        table.starting = YES;
        table.upload_showProgress = progress.fractionCompleted;
        NSInteger index = [self zGetIndexFormOperationUploadMArray:table.uploadId];
        [self.uploadMArray replaceObjectAtIndex:index withObject:table];
        
        NSError *error = nil;
        NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:table error:&error];
        [self performSelectorOnMainThread:@selector(postNotificationProgress:) withObject:dic waitUntilDone:NO];
        
    } singleComplete:^(id model, NSString *imageName, NSNumber *imgId) {
        //上传完一张，删除一张
        GrowthSavePhotoModel *saveModel = (GrowthSavePhotoModel *)model;
        [growthManager removePhotoModel:saveModel withAlbumId:saveModel.uploadId];
//        [[SDImageCache sharedImageCache]removeImageForKey:saveModel.imagePath];
        [[SDImageCache sharedImageCache]removeImageForKey:saveModel.imagePath withCompletion:nil];
        
    } allCompleted:^(NSProgress* progress) {
        
        //上传失败
        if (progress.fractionCompleted<1.f)
        {
            UploadTable *record = [[UploadTable alloc] init];
            record.upload_progressType = UploadProgressType_willUpload;
            if ([growthManager isCreatTableWithAlbumId:table.uploadId])
            {
                id data = [growthManager getData:table.uploadId];
                NSArray *array = [[NSArray alloc] initWithArray:data];
                record.upload_imagesModels = array;
            }
            record.starting = NO;
            record.uploadId = table.uploadId;
            record.upload_showProgress = progress.fractionCompleted;
            NSError *error = nil;
            NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:record error:&error];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATION_UPLOAD_Failure object:nil userInfo:dic];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATION_UPLOAD_AllFinished object:nil userInfo:nil];

        NSInteger index = [self zGetIndexFormOperationUploadMArray:table.uploadId];
        [self.uploadMArray removeObjectAtIndex:index];
        [self.uploadInProgress removeObjectForKey:table.uploadId];
        
    } failure:^(NSError *error) {
        
        NSLog(@"每张图片上传失败打印：%@",[error localizedDescription]);
        
    }];
    
    [self.uploadInProgress setObject:operation forKey:table.uploadId];
    [self.uploadQueue addOperation:operation];
}


- (void)postNotificationProgress:(id)dic
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATION_UPLOAD_Progress object:nil userInfo:dic];
}


- (void)merchantTaskOperationBegainUpload:(UploadGrowOperation *)operation
{
    NSLog(@"self.pendingOperations.uploadMArray＝%@",[PendingOperations sharedInstance].uploadMArray);
    
    operation.uploadTable.upload_progressType= UploadProgressType_uploading;
    operation.uploadTable.starting= YES;
    operation.uploadTable.upload_showProgress= 0.f;
    
    NSInteger index = [self zGetIndexFormOperationUploadMArray:operation.uploadTable.uploadId];
    [self.uploadMArray replaceObjectAtIndex:index withObject:operation.uploadTable];

    NSError *error = nil;
    NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:operation.uploadTable error:&error];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATION_UPLOAD_Progress object:nil userInfo:dic];
}

@end

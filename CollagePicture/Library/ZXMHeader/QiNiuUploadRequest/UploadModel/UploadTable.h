//
//  UploadTable.h
//  Baby
//
//  Created by simon on 16/3/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


typedef NS_ENUM(NSInteger,UploadProgressType) {
    
    /**
     *  继续上传
     */
    UploadProgressType_willUpload=0,
    /**
     *  正在上传
     */
    UploadProgressType_uploading =1,

    /**
     *  等待上传
     */
    UploadProgressType_wait=2,
    /**
     *  上传失败
     */
    UploadProgressType_faile =3,
    /**
     *  上传成功
     */
    UploadProgressType_finish=4,
    
    /**
     *  不用上传
     */
    UploadProgressType_NOUpload =5
};


@interface UploadTable : MTLModel<MTLJSONSerializing>

@property(nonatomic,strong)NSNumber *uploadId;
@property(nonatomic,strong)NSArray *upload_imagesModels;//图片同步model
@property(nonatomic)UploadProgressType upload_progressType; //UI同步状态
@property(nonatomic)CGFloat upload_showProgress;//显示进度
@property(nonatomic,getter=isStarting)BOOL starting; //任务是否正在进行
@end

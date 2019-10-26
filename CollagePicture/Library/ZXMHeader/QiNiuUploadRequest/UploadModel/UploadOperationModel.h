//
//  UploadOperationModel.h
//  lovebaby
//
//  Created by simon on 16/6/1.
//  Copyright © 2016年 . All rights reserved.
//

#import <Mantle/Mantle.h>

@interface UploadOperationModel : MTLModel<MTLJSONSerializing>
/**
 *  操作记录id
 */
@property (nonatomic,strong) NSNumber *operationId;

/**
 *  主题id，如果是成长集导入图片则返回一个0/ 用于上传的
 */
@property (nonatomic,strong) NSNumber *subjectId;
/**
 *  类型   0：成长集   1：主题
 */
@property (nonatomic,strong) NSNumber *type;

/**
 *  自己设置用的－用于主题判断的
 */
@property (nonatomic,strong) NSNumber *themeId;
@end


/**
 *  成长集上传相册保存本地的model
 */
@interface GrowthSavePhotoModel : MTLModel<MTLJSONSerializing>

/**
 *  上传相册id/操作记录id
 */
@property(nonatomic,strong) NSNumber *uploadId;
/**
 *  图片排序
 */
@property(nonatomic,strong) NSNumber *sort;
/**
 *  本地存储的image
 */
@property(nonatomic,strong) NSString *imagePath;
/**
 *  宽度
 */
@property(nonatomic,strong) NSNumber *width;

/**
 *  高度
 */
@property(nonatomic,strong) NSNumber *height;

/**
 *  创建时间
 */
@property(nonatomic,copy) NSString *photoTime;

/**
 *  是否压缩／用于本地判断的
 */
@property(nonatomic,assign) BOOL isCompression;


/**
 *  主题id，如果是成长集导入图片则返回一个0／因为系统主题id并不是这个subjectId
 */
@property (nonatomic,strong) NSNumber *subjectId;

/**
 *  真正的主题id：我的主题：themeId＝subjectId，系统主题：themeId ！＝subjectId／用于本地判断的
 */
@property (nonatomic,strong) NSNumber *themeId;
/**
 *  类型   0：成长集   1：主题
 */
@property (nonatomic,strong) NSNumber *type;

@end


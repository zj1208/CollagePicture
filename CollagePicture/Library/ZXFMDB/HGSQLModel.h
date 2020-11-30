//
//  HGSQLModel.h
//  RobotCows
//
//  Created by 韩盼盼 on 2017/5/13.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGSQLModel : NSObject
// 可省略, 默认的主键id, 如果需要获取主键id的值, 可在自己的model中添加下面这个属性
@property (nonatomic, assign)NSInteger pkid;
/** 下载：name*/
@property (nonatomic, copy)NSString *down_name;
/** 下载：音频id*/
@property (nonatomic, copy)NSString *down_audioid;
/** 下载：视频id*/
@property (nonatomic, copy)NSString *down_videoid;
/** 下载：专辑id*/
@property (nonatomic, copy)NSString *down_specialid;
/** 下载：图片路径*/
@property (nonatomic, copy)NSString *down_imagePath;
/** 下载：评价星星*/
@property (nonatomic, copy)NSNumber *down_star;
/** 下载：简介*/
@property (nonatomic, copy)NSString *down_intro;
/** 下载：收听音频总数*/
@property (nonatomic, copy)NSString *down_audio_sum;
/** 下载：音频播放时长*/
@property (nonatomic, copy)NSString *down_audio_playdt;
/** 下载：日期*/
@property (nonatomic, copy)NSString *down_datetime;
/** 下载：视频观看总数*/
@property (nonatomic, copy)NSString *down_video_looks;
/** 下载：视频播放时长*/
@property (nonatomic, copy)NSString *down_video_playdt;
/** 下载：专辑集数*/
@property (nonatomic, copy)NSString *down_special_sum;
/** 下载：资源url*/
@property (nonatomic, copy)NSString *down_url;
/** 下载到 本地的路径*/
@property (nonatomic, copy)NSString *down_filename;
/** 下载:点赞数 */
@property (nonatomic,copy) NSString *down_likesum;

/** 下载的类型*/
@property (nonatomic, copy)NSString *down_type;//1 专辑 2 视频


@end

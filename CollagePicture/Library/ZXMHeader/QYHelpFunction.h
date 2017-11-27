//
//  QYHelpFunction.h
//  UI_TableView2
//
//  Created by Ibokan on 12-11-13.
//  Copyright (c) 2012年 Ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString *const QYHelpFunctionVersion ;

@interface QYHelpFunction : NSObject

@end




#pragma mark-
#pragma mark 时间转化相关
/******************************
 StringTimeFormTotalTime
 ******************************/
@interface NSObject(StringTimeFormTotalTime)

#pragma mark- 转换播放器总时间为几时几分几秒的格式
/**
 * @brief  NSInterger型-秒 转换成XX:XX:XX格式或者XX：XX格式 或 XX格式.  主要用在视频／音频播放总时间；
 */
- (NSString*)zhuTime_switchPlayer_second:(NSInteger)aTotalsecond;


/**
 * @brief  转换NSInteger型毫秒为 XX:XX:XX格式或者XX：XX格式 或 XX格式,调用上面的方法；
 * [self zhuTime_switchPlayer_second:totalSeconds];
 */
- (NSString*)zhuTime_switchPlayer_millisecond:(NSInteger)aTotalMillisecond;



#pragma mark-转换文本时间格式[XX:xx.xx]
/**
 * @brief  文本时间格式[XX:xx.xx]转换成 以秒为单位的时间总数.  主要用在歌词文本；
 */
-(NSString*)zhuTime_swithLryTextTimeToSecond_lryTextTime:(NSString*)aTextTime;


/////////////////////////////////////////////////////









/**
 *  @brief  判断theDate时间是否超过当前时间了，默认theDate时间格式aDateFormat为@"yyyy-MM-dd HH:mm:ss"
 *  判断是否超过日期，如果固定时间比当前大，那么还没有过期，return YES；
*/
-(BOOL)zhuTime_largerSinceNow_theTime:(NSString *)theDate  Dateformat:(NSString *)aDateFormat;




////时间转换为 下午3:00，昨天 下午2:20，星期六 上午8:00，和微信一样的效果(没完成，没写完，待写)－主要放在聊天界面(昨天很难判断)
//-(NSString *)zhuTime_similarityWeiXin_SinceNow_FormTheTime:(NSString *)theDate;
//


@end

/////////////////////////////////////////////////////



/************************
 判断本地数据,
 ************************/
@interface NSObject (judeNative)


//根本文件名 返回沙箱下的本地完整路径名
-(NSString*)zhuFile_getFilePath:(NSString*)aFileName;


-(void)zhuFile_saveCache:(NSString *)requestType andDataStr:(NSString*)dataStr;


-(NSString *)zhuFile_getCache:(NSString *)requestType;


//生成文件路径下文件集合列表:包括图片，plist文件，bundle文件等所有
-(void)zhuFile_getDefaultManagerResource;


#pragma mark-计算缓存图片大小-如SDWebImage下的
-(float)zhuFile_checkImageFileTempSize:(NSString *)diskCachePath;



#pragma mark --图片
/**
 *	@brief	浏览头像
 *
 *	@param 	oldImageView 	头像所在的imageView
 */
//+(void)showImage:(UIImageView*)avatarImageView;




@end





#pragma mark-
#pragma mark HttpConnection 过滤json数据，html数据

@interface NSObject (httpConnection)

// *	@brief	过滤jSOn数据中的\斜杠 ,不然没法解析
// *	@param  jsonString  数据是带\斜杠的json数据
// *	@return	返回过滤后的json数据（一般这种情况后台解决，不应该留在客户端）

-(NSString *)FilterJSONString:(NSString *)jsonString;


// *	@brief	过滤html中的<>符号，不过都结合在一起了。比较难看
 //*	@param  html  html数据
 //*	@return

-(NSString *)filterHTML:(NSString *)html;


//+ (NSString *)replaceUnicode:(NSString *)unicodeStr;


@end





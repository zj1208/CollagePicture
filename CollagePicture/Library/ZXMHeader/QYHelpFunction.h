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


//@interface NSObject(StringTimeFormTotalTime)
//
//#pragma mark- 转换播放器总时间为几时几分几秒的格式
///**
// * @brief  NSInterger型-秒 转换成XX:XX:XX格式或者XX：XX格式 或 XX格式.  主要用在视频／音频播放总时间；
// */
//- (NSString*)zhuTime_switchPlayer_second:(NSInteger)aTotalsecond;
//
//
///**
// * @brief  转换NSInteger型毫秒为 XX:XX:XX格式或者XX：XX格式 或 XX格式,调用上面的方法；
// * [self zhuTime_switchPlayer_second:totalSeconds];
// */
//- (NSString*)zhuTime_switchPlayer_millisecond:(NSInteger)aTotalMillisecond;
//
//
//
//#pragma mark-转换文本时间格式[XX:xx.xx]
///**
// * @brief  文本时间格式[XX:xx.xx]转换成 以秒为单位的时间总数.  主要用在歌词文本；
// */
//-(NSString*)zhuTime_swithLryTextTimeToSecond_lryTextTime:(NSString*)aTextTime;
//
//
//
//
//
//
//
//
//
//
//
///**
// *  @brief  判断theDate时间是否超过当前时间了，默认theDate时间格式aDateFormat为@"yyyy-MM-dd HH:mm:ss"
// *  判断是否超过日期，如果固定时间比当前大，那么还没有过期，return YES；
//*/
//-(BOOL)zhuTime_largerSinceNow_theTime:(NSString *)theDate  Dateformat:(NSString *)aDateFormat;
//
//
//
//
//@end
//
//

//
///************************
// 判断本地数据,
// ************************/
//@interface NSObject (judeNative)
//
//
////根本文件名 返回沙箱下的本地完整路径名
//-(NSString*)zhuFile_getFilePath:(NSString*)aFileName;
//
//
//-(void)zhuFile_saveCache:(NSString *)requestType andDataStr:(NSString*)dataStr;
//
//
//-(NSString *)zhuFile_getCache:(NSString *)requestType;
//
//
//
//
//@end




//
//#pragma mark-
//#pragma mark HttpConnection 过滤json数据，html数据
//
//@interface NSObject (httpConnection)
//
//// *    @brief    过滤jSOn数据中的\斜杠 ,不然没法解析
//// *    @param  jsonString  数据是带\斜杠的json数据
//// *    @return    返回过滤后的json数据（一般这种情况后台解决，不应该留在客户端）
//
//-(NSString *)FilterJSONString:(NSString *)jsonString;
//
//
//// *    @brief    过滤html中的<>符号，不过都结合在一起了。比较难看
// //*    @param  html  html数据
// //*    @return
//
//-(NSString *)filterHTML:(NSString *)html;
//
//
////+ (NSString *)replaceUnicode:(NSString *)unicodeStr;
//
//
//@end





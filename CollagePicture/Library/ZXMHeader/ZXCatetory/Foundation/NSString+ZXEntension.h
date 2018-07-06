//
//  NSString+ZXEntension.h
//  
//
//  Created by simon on 15/11/17.
//  Copyright © 2015年 mac. All rights reserved.
//
// 2017.12.20 获取文本占几行空间
// 2018.1.18  新增获取文字所需要的尺寸
// 2018.4.18  新增计算平均item宽带方法
// 2018.5.31  内存优化


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CustomNSString)

//+ (NSString *)zhuDate_getStringFromDate:(NSDate*)date;
/**
 * @brief  转换format格式的日期字符串dateString为 自己设定自己需要格式aDateFormat的字符串（如：@"MM月-dd日 a hh:mm"）.
 *
 * @param  dateString 日期字符串,比如:"2015-03-31 13:32“
 * @param  format     dateString的对应DateFormat格式,比如：dateString的format是@"yyyy-MM-dd hh:mm".
 * @param aDateFormat 想得到的时间格式，如：@"MM月-dd日 a hh:mm".
 
 * 例如 NSString *time = [self zhuTime_switchDateFormatFromString:dateString toDateFormat:@"MM-dd-HH:mm"];
 */

+(NSString *)zhuDate_switchDateString:(NSString *)dateString withDateFormat:(NSString *)format toDateFormat:(NSString *)aDateFormat;


/**
 *  @brief  先根据aDate日期得到与当前时间的时间差,再转换；再通过getDiffentTime:方法，把时间字符串@"yyyy-MM-dd HH:mm:ss"转换为－几分钟前，几小时前，几天前，几个月前.
 *
 *  @param  aDate  系统格式的时间字符串（格式必须是：@"yyyy-MM-dd HH:mm:ss" ）
 *  @return  几分钟前，几小时前，几天前，几个月前
 */

+ (NSString *)zhuDate_GetCurrentTimeDifferenceWithDate:(NSString *)aDate;


/**
 *  @brief  先根据GMT格林威治时间oldTime（111111111）得到当前时间差；
 再通过getDiffentTime:方法，把GMT格林威治时间oldTime（111111111）转换为－几分钟前，几小时前，几天前，几个月前.
 */
+ (NSString *)zhuDate_GetCurrentTimeDifferenceWithGMT_intervalTime:(NSTimeInterval)oldTime;

/**
 时间差
 
 @param cha 格林威治时间与当前的时间差
 @return 返回（刚刚－几分钟前－几小时前－几天前－几月前－几年前）
 */
+ (NSString *)getDiffentTime:(NSTimeInterval)cha;


/**
 根据时间差，换算成（剩余）几天几小时几分

 @param time 需要换算的时间差
 @param flag 是否需要秒
 @return 几天几小时几分；几天几小时几分几秒
 */

+ (NSString *)zhuDate_countDownFromDifferenceTime:(NSTimeInterval)time appendSeconds:(BOOL)flag;



/**
 *  @brief  根据date与当前日期比较,获得年龄大小;
 *          根据比较2个日期返回日历的日期组件,获得比较的year;
 *  @prame timestamp  [[NSDate alloc] initWithTimeIntervalSince1970:[[data birthday] longLongValue]/1000.0]
 */
+ (NSString*)zhuDate_DateToAgeWithTimestamp:(NSDate *)timestamp;



/**
 *	@brief	转换1970建立的格林威治时间轴(如：12342424223) 为aDateformat格式的时间字符串，aDateformat默认设置为@"yyyy-MM-dd"
 
 *	@param  timestamp  服务器给的时间轴,以秒为单位的,如果是毫秒,需要除以1000
 *  @param  aDateformat  转变为时间的格式,如：年月日格式：@"yyyy-MM-dd"
 *	@return	formatter时间格式的时间字符串
 */
+(NSString *)zhuDate_switchFromTimestamp:(NSTimeInterval)timestamp ToDateStringWithFormatter:(NSString*)aDateformat;


/**
 *  @brief 根据生日计算星座
 *
 *  @param date    日期,NSDate *da = [[NSDate alloc] initWithTimeIntervalSince1970:[[model birthday] longLongValue]
 *
 *  @return 星座名称
 */


+ (NSString *)zhDate_CalculateConstellationWith_BirthdayDate:(NSDate *)date;


/**
 根据第几天转换为星期几

 @param dayOfWeek 第几天
 @return 星期几
 */
+ (NSString *)zhDate_WeekdayStr:(NSInteger)dayOfWeek;



/**
 把当前时间几时几分转换为“凌晨”，“上午”，“下午”，“晚上”

 @param time 以时为单位部分
 @param minute 分钟数部分
 @return “凌晨”，“上午”，“下午”，“晚上”
 */
+ (NSString *)zhDate_getPeriodOfTime:(NSInteger)time withMinute:(NSInteger)minute;


/**
 根据格林威治时间与当前时间比对，转换不同格式的时间显示（微信IM格式）；
 昨天上午 几时几分
 @param msglastTime 某个格林威治时间
 @param showDetail 是否要显示过去时间的详情时间：上午 几时几分
 @return 转换后的时间
 */
+ (NSString *)zhDate_showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail;
/**
 *  @brief 转换10进制字符串为16进制格式的字符串;
 *
 *  @param string 10进制字符串
 *
 *  @return 16进制字符串
 */

+ (NSString *)zhHexStringFromString:(NSString *)string;



/**
 *  @brief 获取支持中文编码的字节数,系统NSString默认是UTF16编码,是不支持中文的,计算字符串长度和字节数都不太准;
 *
 *  @param str   字符串
 *
 *  @return 字符串的字节数
 */

+ (NSInteger)zhGetZhonWenLengthOfBytes:(NSString *)str;


/**
 *  @brief 过滤输入的字符串2端的空格和换行符
 *
 *  @param str  原字符串
 *
 *  @return 过滤2端的空格和换行符后的字符串
 */

+ (NSString *)zhFilterInputTextWithWittespaceAndLine:(NSString *)str;



/**
 判断字符串是否为NULL，nil,字符串空

 @param string string description
 @return return value description
 */
+ (BOOL)zhIsBlankString:(nullable NSString *)string;


/**
 *  @brief 过滤字符串中的特殊字符
 *
 *  @param str  原字符串
 *
 *  @return 过滤字符串中的特殊字符之后的字符串
 */

+ (NSString *)zhFilterSpecialCharactersInString:(NSString *)str;


/**
 *  @brief 过滤歌词中特殊字符串-去掉字符串中的空格，过滤两端空格和换行符，过滤特殊字符，转换成小写
 *
 *  @param  str 歌词
 *
 *  @return  过滤之后的歌词
 */
+ (NSString *)zhFilterLyricString:(NSString *)str;


/**
 *  @brief 判断string是否是整数/即是否是纯数字
 *
 *  @param  string  原字符串
 *
 *  @return  YES／NO @"您的密码过于简单，请使用数字+字母的组合"
 */

+ (BOOL)zhIsIntScan:(nullable NSString *)string;


/**
 *  @brief 判断当前时间是否超过date 已经有timeInterval时间;
 *
 *  @param  date  需要比较的时间日期
 *
 *  @return  YES
 */

+ (BOOL)zhData_isLargerDate:(NSDate*)date TimeInterval:(NSTimeInterval)timeInterval;


/**
 *	@brief	密码MD5加密，#import <CommonCrypto/CommonDigest.h>
 *	@param  key 密码
 *	@return	加密后的16进制的密码
 */
+ (NSString *)zhCreatedMD5String:(NSString *)key;


/**
 获取文本占几行空间；

 @param size 有效范围内；
 @param font 字体大小
 @return 几行
 */
- (NSInteger)zhGetNumLinesWithBoundingRectWithSize:(CGSize)size titleFont:(UIFont *)font;


/**
 获取文字所需要的尺寸

 @param text 文字内容
 @param size 显示尺寸范围
 @param font 字体大小
 @return size
 */
+ (CGSize)zhGetBoundingSizeOfString:(NSString *)text WithSize:(CGSize)size font:(UIFont *)font;


/**
 直接绘制文本到某个rect

 @param ctx 上下文
 @param text 文本
 @param rect rect
 @param font font
 */
+ (void)zhDrawTextInContext:(CGContextRef)ctx text:(NSString *)text inRect:(CGRect)rect font:(UIFont *)font;

/**
 key1=value1&key2=value2 组成的有序字符串 MD5加密

 @param dict 无序字典
 @param sortKeys 有序key数组
 @return 返回经过md5加密后的字符串
 */
+ (NSString *)zhCreatMD5StringWithDict:(NSDictionary*)dict sortKeyArray:(NSArray *)sortKeys;

/**
 *	@brief	根据jsonSerialization方法把NSData数据转换为json格式（NSArray／NSDictionary）
 *	@param  string  字典or数组格式的字符串
 *	@return	NSArray 或 NSDictionary
 */
+ (nullable id)zhGetJSONSerializationObjectFormString:(nullable NSString *)string;

+ (nullable id)zhGetJSONSerializationObjectByJsonData:(nullable NSData *)data;

+ (nullable id)zhGetJSONSerializationObjectFormContentsOfFile:(NSString *)path;

/**
 *	@brief	根据jsonSerialization方法把json格式（NSArray／NSDictionary）对象转换为字符串
 */
+ (nullable NSString *)zhGetJSONSerializationStringFromObject:(nullable id)responseObject;


/**
 过滤json字符串的转义字符；

 @param str json原字符串
 @return 过滤后的json字符串
 */
+ (NSString *)zhFilterEscapeCharacterWithJsonString:(NSString *)str;


//根据友盟统计SDK获取UDID，和OpenUDID获取的openUDID一样的；
//+ (NSString *)zhGetUMOpenUDIDString;


#pragma mark-获取[from, to]之间的随机整数。

//  arc4random() % 10： 获取[0－9]的随机数
//  [zhGetRandomNumberWithFrom:2 to 10]:获取[2-10]的随机数;
//  同arc4random_uniform(10):获取[0-10]的随机整数;
- (int)zhGetRandomNumberWithFrom:(int)from to:(int)to;



/**
 计算平均宽度方法
 */
+ (CGFloat)zhGetItemAverageWidthInTotalWidth:(CGFloat)totalWidth columnsCount:(NSUInteger)columnsCount sectionInset:(UIEdgeInsets)inset minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing;

@end

NS_ASSUME_NONNULL_END

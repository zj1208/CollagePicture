//
//  NSObject+ZXJSONCategory.h
//  MerchantBusinessClient
//
//  Created by 朱新明 on 2020/2/2.
//  Copyright © 2020 com.Chs. All rights reserved.
//
//  9.07 json对象转没有空白/缩进,也没有转译符号的NSString；

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZXJSONCategory)


/**
 *    @brief    利用NSJSONSerialization把二进制数据NSData（JSON数据）转换为JSON对象（NSArray／NSDictionary）；
 *    @return    NSArray 或 NSDictionary
 */

+ (nullable id)zx_getJSONSerializationObjectWithJSONData:(nullable NSData *)data;

/**
*    @brief   把json字符串转换为JSON标准对象（NSArray／NSDictionary格式）;
              JSON字符串NSString->转换为NSData（JSON格式数据）-->转换为JSON标准对象（NSArray／NSDictionary格式对象）
*    @param   string  字典or数组格式的字符串,"{\"name\":\"kaixuan_166\"}"
*    @return  NSArray 或 NSDictionary的JSON对象；
*/
+ (nullable id)zx_getJSONSerializationObjectFromString:(nullable NSString *)string;


/// @brief 通用方法：把json数据（NSString或NSData格式）转换为JSON对象（NSArray／NSDictionary格式）；
/// @param json 有可能是NSString格式，NSData格式，原格式；
+ (nullable id)zx_getJSONSerializationObjectFromJSON:(id)json;
/**
*  @brief  把文件的数据NSData（JSON格式数据）转换为JSON标准对象（NSArray／NSDictionary格式）;
*/
+ (nullable id)zx_getJSONSerializationObjectFromContentsOfFile:(NSString *)path;

/**
 *  @brief  把JSON对象（NSArray／NSDictionary格式对象）转换为字符串；
 *          基础数据对象（JSON标准对象）->二进制数据NSData（JSON数据）-->NSString
 *  @param  responseObject  JSON对象（NSArray／NSDictionary格式对象）
 *  @return 传值用的数据格式(没有空白/缩进,也没有转译符号的)的NSString；
 *  注意：在与webView的js传值时，不能使用打印格式NSJSONWritingPrettyPrinted的数据，会报错；
 */
+ (nullable NSString *)zx_getJSONSerializationStringFromJSONObject:(nullable id)responseObject;



/// 把JSON对象（NSArray／NSDictionary格式对象）转换为字符串；支持输出更具可读性的打印格式NSJSONWritingPrettyPrinted的数据
/// @param responseObject responseObject description
/// @param opt opt description
+ (NSString *)zx_getJSONSerializationStringFromJSONObject:(nullable id)responseObject options:(NSJSONWritingOptions)opt;

/**
 过滤JSON字符串的转义字符；

 @param str JSON原字符串,"{\"name\":\"kaixuan_166\"}"
 @return 过滤后的json字符串
 */
+ (NSString *)zx_filterEscapeCharacterWithJsonString:(NSString *)str;


@end

NS_ASSUME_NONNULL_END

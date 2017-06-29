#import <UIKit/UIKit.h>

@interface ChineseToPinyin : NSObject {
    
}

+ (NSString *) pinyinFromChiniseString:(NSString *)string;//中文字符串 转 拼音字符串 后拼音都为大写
+ (char) sortSectionTitle:(NSString *)string; //返回拼音字符串中第一个大写字母


/**
 *@brief 返回26个字母数组；
 */

+ (NSArray *)keyArray;

/**
 *@brief 根据需要排列的所有中文标题或名称，排列成根据字母A－Z分组排序，相应返回26个字母，26个数组的字典；
 */
+ (NSDictionary *)sortedSectionAfterDictionary_sourceTitleArray:(NSArray*)titleArray;

@end
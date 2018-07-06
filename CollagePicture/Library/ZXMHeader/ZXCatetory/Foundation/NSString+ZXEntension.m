//
//  NSString+ZXEntension.m
//  wqk8
//
//  Created by simon on 15/11/17.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "NSString+ZXEntension.h"

#import <CommonCrypto/CommonDigest.h>

#define SECONDS_PER_HOUR (60*60)
#define SECONDS_PER_DAY (24*60*60)
#define SECONDS_PER_MONTH (30*24*60*60)
#define SECONDS_PER_YEAR (365*24*60*60)

static double OnedayTimeIntervalValue = 24*60*60;  //一天的秒数

@implementation NSString (CustomNSString)


+(NSString *)zhuDate_switchDateString:(NSString *)dateString withDateFormat:(NSString *)format toDateFormat:(NSString *)aDateFormat;
{
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    [dateFor setDateFormat:format];
    NSDate *date = [dateFor dateFromString:dateString];
    
    [dateFor setDateFormat:aDateFormat];
    NSString *string = [dateFor stringFromDate:date];
    return string;
    
}

//与当前时间差,
+ (NSString *)zhuDate_GetCurrentTimeDifferenceWithDate:(NSString *)aDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *laDate = [formatter dateFromString:aDate];//string型转换为NSDate型（GMT时间）
    NSTimeInterval cha =ABS([laDate timeIntervalSinceNow]) ;//以当前时间(Now)为基准时间，返回实例保存的时间与当前时间(Now)的时间间隔,是个负数，所以要用abs
    return [NSString getDiffentTime:cha];

}

+ (NSString *)zhuDate_GetCurrentTimeDifferenceWithGMT_intervalTime:(NSTimeInterval)oldTime
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval cha = now - oldTime;
    return [NSString getDiffentTime:cha];
}


+ (NSString *)getDiffentTime:(NSTimeInterval)cha
{
    NSString *timeString = @"";
    // 小于1小时
    if ((cha/SECONDS_PER_HOUR)<1)
    {
        if (cha/60<1)
        {
            timeString = @"刚刚";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f",cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString = [NSString stringWithFormat:@"%@分钟前",timeString];
        }
    }
//    大于等于1小时，小于24小时
    else if ((cha/SECONDS_PER_HOUR)>=1 && (cha/SECONDS_PER_HOUR)<24)
    {
        timeString = [NSString stringWithFormat:@"%f",cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@小时前",timeString];
    }
    else if (cha/SECONDS_PER_DAY>=1 && cha/SECONDS_PER_DAY <30)
    {
        timeString = [NSString stringWithFormat:@"%f",cha/SECONDS_PER_DAY];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@天前",timeString];
    }
    else if (cha/SECONDS_PER_DAY>=30 && cha/SECONDS_PER_DAY <365)
    {
        timeString = [NSString stringWithFormat:@"%f",cha/SECONDS_PER_MONTH];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@个月前",timeString];
    }
    else
    {
        timeString = [NSString stringWithFormat:@"%f",cha/SECONDS_PER_YEAR];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@年前",timeString];
    }
    return timeString;
}


+ (NSString *)zhuDate_countDownFromDifferenceTime:(NSTimeInterval)time appendSeconds:(BOOL)flag
{
    NSMutableString *timeString = [NSMutableString string];
    if (time <=0)
    {
        [timeString appendFormat:@"0天0小时0分"];
        if (flag)
        {
            [timeString appendFormat:@"0秒"];
        }
        return timeString;
    }
    
    int newTime = ABS(time);
    int mon   = newTime/(3600*24*30);
    int days  = (newTime%(3600*24*30))/SECONDS_PER_DAY;
    int hours = ((newTime%(3600*24*30))%SECONDS_PER_DAY)/SECONDS_PER_HOUR;
    int min     = (((newTime%(3600*24*30))%SECONDS_PER_DAY)%SECONDS_PER_HOUR)/60;
    int second = (((newTime%(3600*24*30))%SECONDS_PER_DAY)%SECONDS_PER_HOUR)%60;
    if (mon>0)
    {
        [timeString appendFormat:@"%i月",mon];
    }
    [timeString appendFormat:@"%i天%i小时%i分",days,hours,min];
    if (flag)
    {
        [timeString appendFormat:@"%i秒",second];
    }
    return timeString;
}






+ (NSString*)zhuDate_DateToAgeWithTimestamp:(NSDate *)timestamp
{
    
    NSDate *myDate = timestamp;
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitYear;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:myDate toDate:nowDate options:0];
    long long year = [comps year];
    return [NSString stringWithFormat:@"%lld岁",(long long)year];
}



+(NSString *)zhuDate_switchFromTimestamp:(NSTimeInterval)timestamp ToDateStringWithFormatter:(NSString*)aDateformat
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp ];
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateformat = aDateformat?aDateformat:@"yyyy-MM-dd";
    [formatter setDateFormat:dateformat];
    NSString *strDate = [formatter stringFromDate:date];
    NSString *dateStr = [NSString stringWithString:[strDate description]];
    return dateStr;
    
}

/**
 *  根据生日计算星座
 *
 *  @return 星座名称
 */
+ (NSString *)zhDate_CalculateConstellationWith_BirthdayDate:(NSDate *)date
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //用[NSDate date]可以获取系统当前时间
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    //分割日期字符串
    NSArray *strArr = [dateStr componentsSeparatedByString:@"-"];
    NSInteger month = [strArr[1] integerValue];
    NSInteger day     = [strArr[2] integerValue];
    /**
     *  ************************************************************************
     */
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    if (month<1 || month>12 || day<1 || day>31){
        return @"错误日期格式!";
    }
    
    if(month==2 && day>29)
    {
        return @"错误日期格式!!";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"错误日期格式!!!";
        }
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return [NSString stringWithFormat:@"%@",result];
}

+ (NSString*)zhDate_WeekdayStr:(NSInteger)dayOfWeek
{
    static NSDictionary *daysOfWeekDict = nil;
    daysOfWeekDict = @{@(1):@"星期日",
                       @(2):@"星期一",
                       @(3):@"星期二",
                       @(4):@"星期三",
                       @(5):@"星期四",
                       @(6):@"星期五",
                       @(7):@"星期六",};
    return [daysOfWeekDict objectForKey:@(dayOfWeek)];
}


+ (NSString *)zhDate_getPeriodOfTime:(NSInteger)time withMinute:(NSInteger)minute
{
    NSInteger totalMin = time *60 + minute;
    NSString *showPeriodOfTime = @"";
    if (totalMin > 0 && totalMin <= 5 * 60)
    {
        showPeriodOfTime = @"凌晨";
    }
    else if (totalMin > 5 * 60 && totalMin < 12 * 60)
    {
        showPeriodOfTime = @"上午";
    }
    else if (totalMin >= 12 * 60 && totalMin <= 18 * 60)
    {
        showPeriodOfTime = @"下午";
    }
    else if ((totalMin > 18 * 60 && totalMin <= (23 * 60 + 59)) || totalMin == 0)
    {
        showPeriodOfTime = @"晚上";
    }
    return showPeriodOfTime;
}


+ (NSString *)zhDate_showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail
{
    //今天的时间
    NSDate * nowDate = [NSDate date];
    NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:msglastTime];
    NSString *result = nil;
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];
    
    NSInteger hour = msgDateComponents.hour;
    
    result = [NSString zhDate_getPeriodOfTime:hour withMinute:msgDateComponents.minute];
    if (hour > 12)
    {
        hour = hour - 12;
    }
    if(nowDateComponents.day == msgDateComponents.day) //同一天,显示时间
    {
        result = [[NSString alloc] initWithFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute];
    }
    else if(nowDateComponents.day == (msgDateComponents.day+1))//昨天
    {
        result = showDetail?  [[NSString alloc] initWithFormat:@"昨天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"昨天";
    }
    else if(nowDateComponents.day == (msgDateComponents.day+2)) //前天
    {
        result = showDetail? [[NSString alloc] initWithFormat:@"前天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : @"前天";
    }
    else if([nowDate timeIntervalSinceDate:msgDate] < 7 * OnedayTimeIntervalValue)//一周内
    {
        NSString *weekDay = [NSString zhDate_WeekdayStr:msgDateComponents.weekday];
        result = showDetail? [weekDay stringByAppendingFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : weekDay;
    }
    else//显示日期
    {
        NSString *day = [NSString stringWithFormat:@"%zd-%zd-%zd", msgDateComponents.year, msgDateComponents.month, msgDateComponents.day];
        result = showDetail? [day stringByAppendingFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute]:day;
    }
    return result;
}


+ (NSString *)zhHexStringFromString:(NSString *)string;
{
    
    NSString *hexString =[[NSString alloc] initWithFormat:@"%1lx",(long)[string integerValue]];
    return hexString;
}


+ (NSInteger)zhGetZhonWenLengthOfBytes:(NSString *)str
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return  [str lengthOfBytesUsingEncoding:enc];
}



+ (NSString *)zhFilterInputTextWithWittespaceAndLine:(NSString *)str
{
    NSCharacterSet *whitespaceLine = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
    NSRange spaceRange = [str rangeOfCharacterFromSet:whitespaceLine];
    if (spaceRange.location != NSNotFound)
    {
        str = [str stringByTrimmingCharactersInSet:whitespaceLine];
    }

    return str;
}



+ (BOOL)zhIsBlankString:(nullable NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}

//这个是bug，不能判断nil了
- (BOOL)zhIsBlankString
{
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


+ (NSString *)zhFilterSpecialCharactersInString:(NSString *)str
{
    NSMutableString *trimmedString =[[NSMutableString alloc] initWithString:str];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"~`!@#$%^&*():,./;[]{}-_|+=?<>"];
    for (int i = 0; i<trimmedString.length; i++)
    {
        NSRange range = [trimmedString rangeOfCharacterFromSet:set];
        if ((range.location != NSNotFound))
        {
            [trimmedString deleteCharactersInRange:NSMakeRange(range.location, range.length)];
        }
    }
    return trimmedString;
}



//主要用在音乐歌词搜索
+ (NSString *)zhFilterLyricString:(NSString *)str;
{
    //去除过滤两端空格和换行符
    NSString * str1 = [[NSString zhFilterInputTextWithWittespaceAndLine:str]copy];
    
    //去掉字符串中的空格
    NSString * str2 = [[str1 stringByReplacingOccurrencesOfString:@" " withString:@""]copy];
    
    //去除过滤特殊字符，stringByTrimingCharactersInSet方法只能过滤两端。
    str2 = [NSString zhFilterSpecialCharactersInString:str2];
    
    //转换成小写
    str2 = [str2 lowercaseString];
    
    return str2;
}


+ (BOOL)zhIsIntScan:(nullable NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}



 
+ (BOOL)zhData_isLargerDate:(NSDate*)date TimeInterval:(NSTimeInterval)timeInterval
{
    
    NSDate *currentDate = [NSDate date];
    //如果当前时间比给的时间大,则计算差距是否超过3小时
    if ([date compare:currentDate] ==NSOrderedAscending)
    {
        //计算2个时间相隔多少秒
        NSTimeInterval time = [currentDate timeIntervalSinceDate:date];
        NSLog(@"时间差=%@",@(time));
        if (time>timeInterval)
        {
            return YES;
        }
    }
    return NO;
}

//为什么字母都是大写的？
+ (NSString *)zhCreatedMD5String:(NSString *)key
{
    const char *str = [key UTF8String];//转换成utf-8
    unsigned char result[CC_MD5_DIGEST_LENGTH];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5(str,  (unsigned int)strlen(str), result);
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i =0; i<CC_MD5_DIGEST_LENGTH; i++)
    {
        [hash appendFormat:@"%02X",result[i]];// x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
    }
    return [hash lowercaseString];
}

- (NSInteger)zhGetNumLinesWithBoundingRectWithSize:(CGSize)size titleFont:(UIFont *)font
{
    CGFloat textH = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.height;
    CGFloat lineHeight = font.lineHeight;
    NSInteger  lineCount = textH / lineHeight;
    return lineCount;
}


+ (CGSize)zhGetBoundingSizeOfString:(NSString *)text WithSize:(CGSize)size font:(UIFont *)font
{
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    }
    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGSize textSize = [text boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:tdic
                              context:nil].size;
    return textSize;
}

+ (void)zhDrawTextInContext:(CGContextRef)ctx text:(NSString *)text inRect:(CGRect)rect font:(UIFont *)font
{
    NSMutableParagraphStyle *priceParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    priceParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    priceParagraphStyle.alignment = NSTextAlignmentLeft;
    
    [text drawInRect:rect
      withAttributes:@{NSParagraphStyleAttributeName : priceParagraphStyle, NSFontAttributeName : font}];
}


+ (NSString *)zhCreatMD5StringWithDict:(NSDictionary *)dict sortKeyArray:(NSArray *)sortKeys
{
    __block NSString *str = @"";
    [sortKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id value = [dict objectForKey:obj];
        if([str length] !=0) {
            str = [str stringByAppendingString:@"&"];
        }
        str = [str stringByAppendingFormat:@"%@=%@",obj,value];
    }];
    
    NSString *md5String = [[NSString zhCreatedMD5String:str]copy];
    return md5String;
}

+ (nullable id)zhGetJSONSerializationObjectFormString:(nullable NSString *)string
{
    if ([NSString zhIsBlankString:string])
    {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSString zhGetJSONSerializationObjectByJsonData:data];
}

+ (nullable id)zhGetJSONSerializationObjectByJsonData:(nullable NSData *)data
{
    NSError *error=nil;
    id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error==nil && data!=nil)
    {
        return dic;
    }
    return nil;
}

+ (nullable id)zhGetJSONSerializationObjectFormContentsOfFile:(NSString *)path
{
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"ZXPrivacyPolicy" ofType:@"json"];
//    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error==nil && data!=nil)
    {
        return dic;
    }
    return nil;

}

+ (NSString *)zhGetJSONSerializationStringFromObject:(nullable id)responseObject
{
    if ([NSJSONSerialization isValidJSONObject:responseObject])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
        if (error==nil && data!=nil)
        {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *escapeString = [NSString zhFilterEscapeCharacterWithJsonString:str];
            return escapeString;
        }
    }
    return nil;
}

//过滤转义字符
+ (NSString *)zhFilterEscapeCharacterWithJsonString:(NSString *)str
{
    NSMutableString *responseString = [NSMutableString stringWithString:str];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    return responseString;
}



#pragma mark-获取[from, to]之间的随机整数。

//  arc4random() % 5： 获取0－4的随机数
//  [zhGetRandomNumberWithFrom:2 to 10]:获取2-10的随机数
//  arc4random_uniform(5):同上
- (int)zhGetRandomNumberWithFrom:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from + 1)));
}


+ (CGFloat)zhGetItemAverageWidthInTotalWidth:(CGFloat)totalWidth columnsCount:(NSUInteger)columnsCount sectionInset:(UIEdgeInsets)inset minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{
    CGFloat itemSpace = minimumInteritemSpacing;
    itemSpace = itemSpace>0?itemSpace:0;
    CGFloat itemWidth =  (totalWidth - (columnsCount-1)*itemSpace-inset.left-inset.right)/columnsCount;
    return floorf(itemWidth);
}

@end

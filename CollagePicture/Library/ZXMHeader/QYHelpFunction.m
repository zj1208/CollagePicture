//
//  QYHelpFunction.m
//  UI_TableView2
//
//  Created by Ibokan on 12-11-13.
//  Copyright (c) 2012年 Ibokan. All rights reserved.
//

#import "QYHelpFunction.h"
#import "APPCommonDef.h"
#import <QuartzCore/QuartzCore.h>



#import <CommonCrypto/CommonCryptor.h>//用于加密算法
#import <CommonCrypto/CommonDigest.h>//用于加密算法


NSString *const QYHelpFunctionVersion = @"v2.0  2015-03-20";
@implementation QYHelpFunction




@end


#pragma mark-
#pragma mark 时间转化相关
/******************************
 StringTimeFormTotalTime
 ******************************/
@implementation NSObject(StringTimeFormTotalTime)

- (NSString*)zhuTime_switchPlayer_millisecond:(NSInteger)aTotalMillisecond;
{
    short totalSeconds = aTotalMillisecond / 1000; //millisecond to second
    return [self zhuTime_switchPlayer_second:totalSeconds];
}



- (NSString*)zhuTime_switchPlayer_second:(NSInteger)aTotalsecond;
{
    short totalHours = aTotalsecond /3600;
    short minutes = (aTotalsecond - totalHours *3600)/60;
    short seconds = aTotalsecond - totalHours *3600 - minutes *60;
    NSString *timeString =nil;
    if (totalHours==0)//如果hours==0；则格式为x:x
    {
        if (minutes>=0&&minutes<10)//如果minutes<10,则格式为0x:xx
        {
            if (seconds>=0 && seconds<10)
            {
                timeString = [NSString stringWithFormat:@"0%d:0%d",minutes,seconds];
            }
            else
            {
                timeString = [NSString stringWithFormat:@"0%d:%d",minutes,seconds];
                
            }
            
        }
        else//如果minutes>=10,则格式为xx:xx
        {
            
            if (seconds>=0 && seconds<10)
            {
                timeString = [NSString stringWithFormat:@"%d:0%d",minutes,seconds];
            }
            else
            {
                timeString = [NSString stringWithFormat:@"%d:%d",minutes,seconds];
                
            }
        }
    }
    
    else
    {
        if (minutes>=0&&minutes<10)//如果minutes<10,则格式为0x:xx
        {
            if (seconds>=0 && seconds<10)
            {
                timeString = [NSString stringWithFormat:@"0%d:0%d:0%d",totalHours,minutes,seconds];
            }
            else
            {
                timeString = [NSString stringWithFormat:@"0%d:0%d:%d",totalHours,minutes,seconds];
                
            }
            
        }
        else//如果minutes>=10,则格式为xx:xx
        {
            
            if (seconds>=0 && seconds<10)
            {
                timeString = [NSString stringWithFormat:@"0%d:%d:0%d",totalHours,minutes,seconds];
            }
            else
            {
                timeString = [NSString stringWithFormat:@"0%d:%d:%d",totalHours,minutes,seconds];
                
            }
        }
        
    }
    return timeString;
}


//[XX:xx.xx]格式时间 转换成以秒为单位的时间计数器
-(NSString*)zhuTime_swithLryTextTimeToSecond_lryTextTime:(NSString*)aTextTime;
{
    if (!aTextTime || aTextTime.length <= 0)
        return nil;
    if ([aTextTime rangeOfString:@"["].length <= 0 && [aTextTime rangeOfString:@"]"].length <= 0)
        return nil;
    NSString *minutes = [aTextTime substringWithRange:NSMakeRange(1, 2)];
    NSString *second = [aTextTime substringWithRange:NSMakeRange(4, aTextTime.length-4)];
    float finishSecond = minutes.floatValue * 60 +second.floatValue;
    return [NSString stringWithFormat:@"%f",finishSecond];
}









-(BOOL)zhuTime_largerSinceNow_theTime:(NSString *)theDate  Dateformat:(NSString *)aDateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *datefor = aDateFormat?aDateFormat:@"yyyy-MM-dd HH:mm:ss";
    [formatter setDateFormat:datefor];
    NSDate *laDate = [formatter dateFromString:theDate];//string型转换为NSDate型（GMT时间）
    NSTimeInterval cha =[laDate timeIntervalSinceNow] ;//以当前时间(Now)为基准时间，返回实例保存的时间与当前时间(Now)的时间间隔,是个负数，所以要用abs
    if (cha<0)
    {
        return NO;
    }
    return YES;
}




//-(NSString *)zhuTime_similarityWeiXin_SinceNow_FormTheTime:(NSString *)theDate
//{
//    NSString *timeString;
//    NSDateFormatter *formatter = PX_AUTORELEASE([[NSDateFormatter alloc] init]);
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *laDate = [formatter dateFromString:theDate];//string型转换为NSDate型（GMT时间）
//    //    NSTimeInterval cha =ABS([laDate timeIntervalSinceNow]) ;//以当前时间(Now)为基准时间，返回实例保存的时间与当前时间(Now)的时间间隔,是个负数，所以要用abs
//    
//    NSDateFormatter *datefor = [[NSDateFormatter alloc] init];
//    [datefor setDateFormat:@"yyyy年MMMd日 a hh:mm"];
//    timeString = [datefor stringFromDate:laDate];
//    
//    return timeString;
//}
//

@end




#pragma mark-
#pragma mark 判断本地数据有关
/************************
 判断本地数据,
 ************************/
@implementation NSObject (judeNative)
#pragma mark 调准一张图片大小,缩放方法。 以下2个方法一样的
-(UIImage *)zhuScaleToSize:(UIImage *)img size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
-(UIImage *)zhuScaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


//返回数据文件的完整路径名
-(NSString*)zhuFile_getFilePath:(NSString*)aFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [paths objectAtIndex:0];
    //我这里先创建了一个目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [filePath stringByAppendingPathComponent:@"test"];
    [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString* fileDirectory = [testDirectory stringByAppendingPathComponent:aFileName];//将aFileName添加到路径末尾
    return fileDirectory;
}

-(void)zhuFile_saveCache:(NSString *)requestType andDataStr:(NSString*)dataStr
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"cache-%@",requestType];
    [setting setObject:dataStr forKey:key];
    [setting synchronize];
}


-(NSString *)zhuFile_getCache:(NSString *)requestType
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"cache-%@",requestType];
    NSString *dataStr = [settings objectForKey:key];
    return dataStr;
}


-(void)zhuFile_getDefaultManagerResource
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *defaultPath = [[NSBundle mainBundle] resourcePath];
    NSError *error;
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:defaultPath error:&error];
    NSLog(@"%@",directoryContents);
    
}


#pragma mark-计算缓存图片大小-如SDWebImage下的
-(float)zhuFile_checkImageFileTempSize:(NSString *)diskCachePath
{
    float totalSize = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for(NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        signed long long length = [attrs fileSize];
        totalSize +=length/1024.0/1024.0;
    }
    return totalSize;
}



#pragma mark-获取from 到 to之间的随机整数。
-(int)zhuGetRandomNumber:(int)from to:(int)to
{
    //  arc4random() % 5： 获取0－4之间的随机数
    // arc4random_uniform(5):同上
    return (int)(from + (arc4random() % (to-from + 1)));
    
}


- (NSString *)zhgetRandomNumber:(int)length
{
    NSString *result=@"";
    for (int i=0; i<length; i++) {
        result = [result stringByAppendingFormat:@"%d",arc4random()%10];
    }
    return result;
}



////	@brief	浏览头像
//static CGRect oldframe;
//-(void)showImage:(UIImageView *)avatarImageView{
//    UIImage *image=avatarImageView.image;
//    UIWindow *window=[UIApplication sharedApplication].keyWindow;
//    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
//    backgroundView.backgroundColor=[UIColor blackColor];
//    backgroundView.alpha=0;
//    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
//    imageView.image=image;
//    imageView.tag=1;
//    [backgroundView addSubview:imageView];
//    [window addSubview:backgroundView];
//    
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
//    [backgroundView addGestureRecognizer: tap];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
//        backgroundView.alpha=1;
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//-(void)hideImage:(UITapGestureRecognizer*)tap{
//    UIView *backgroundView=tap.view;
//    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
//    [UIView animateWithDuration:0.3 animations:^{
//        imageView.frame=oldframe;
//        backgroundView.alpha=0;
//    } completion:^(BOOL finished) {
//        [backgroundView removeFromSuperview];
//    }];
//}






@end





#pragma mark-
#pragma mark HttpConnection 过滤json数据，html数据

@implementation NSObject (httpConnection)


-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}


-(NSString *)FilterJSONString:(NSString *)jsonString
{
    NSMutableString *responseString = [NSMutableString stringWithString:jsonString];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++)
    {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
        {
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
        }
        
    }
    return responseString;
}


//+ (NSString *)replaceUnicode:(NSString *)unicodeStr
//{
//    
//    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
//    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
//    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
//    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
//                                                           mutabilityOption:NSPropertyListImmutable
//                                                                     format:NULL
//                                                           errorDescription:NULL];
//    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
//}
//
//


@end


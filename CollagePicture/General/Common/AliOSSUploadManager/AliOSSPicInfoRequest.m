//
//  AliOSSPicInfoRequest.m
//  YiShangbao
//
//  Created by simon on 17/3/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AliOSSPicInfoRequest.h"

@implementation AliOSSPicInfoRequest

+ (void)ossGetPicInfoWithBasePicURL:(nullable NSString *)baseURL sucess:(nonnull ZXCompletedBlock)complete
{
    NSURL *url =[NSURL URLWithString:@"?x-oss-process=image/info" relativeToURL:[NSURL URLWithString:baseURL]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        CGSize size  = CGSizeZero;
        id object;
        if (data)
        {
            NSDictionary * objectDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSDictionary* ImageWidth = [objectDic objectForKey:@"ImageWidth"];
            CGFloat width =[[ImageWidth objectForKey:@"value"]floatValue];
            NSDictionary* ImageHeight = [objectDic objectForKey:@"ImageHeight"];
            CGFloat height =[[ImageHeight objectForKey:@"value"]floatValue];
            size =CGSizeMake(width,height);
            object = objectDic;
        }
        complete (object,size,error);
        
    }];
    [task resume];
}
@end

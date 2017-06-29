//
// Created by simon on 15/4/10.
// Copyright (c) 2015 simon. All rights reserved.
//


#import <Foundation/Foundation.h>
/**
* 分享信息model
*/
@interface ShareInfo : NSObject
/**
 *  网页url地址,新浪微博需要在content里加入url的http链接
 */
@property (nonatomic, copy) NSString *url;
/**
 *  内容，只有微信好友有内容，新浪微博没有内容；微信朋友圈没有内容；
 */
@property (nonatomic, copy) NSString *content;
/**
 *  图片URL/UIImage图片;新浪微博可以图片和文本，微信和qq；
 */
@property (nonatomic, strong) id ico;
/**
 *  标题；
 */
@property (nonatomic, copy) NSString *title;

@end

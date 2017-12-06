//
//  BaseHttpAPI.h
//  SiChunTang
//
//  Created by 朱新明 on 15/6/4.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageModel.h"
#import "AFURLRequestSerialization.h"



typedef void (^CompleteBlock)(id data);
typedef void (^ErrorBlock)(NSError* error);
typedef void (^CompletePageBlock)(id data,PageModel* pageModel);
typedef void (^CompleteListBlock)(id data,NSInteger pageNo,NSInteger totalPage);



#pragma mark - PARAMETER KEY

static  NSString *const kHTTP_TOKENKEY  =    @"token";
static  NSString *const kHTTP_startIndex = @"startIndex";

static  NSString *const kHTTP_USERID_KEY=  @"userId";

static  NSString *const kHTTP_PAGENO_KEY = @"pn";
static  NSString *const kHTTP_PAGESIZE_KEY  =   @"ps";


static  NSString *const kHTTP_PAGENO_KEY2 = @"pageNo";
static  NSString *const kHTTP_PAGESIZE_KEY2  =   @"pageSize";

static  NSString *const kHTTP_PAGENO_KEY3 = @"pageNum";
static  NSString *const kHTTP_PAGESIZE_KEY3  =   @"pageSize";

#pragma mark - HttpKey

static NSString *kHTTP_ID_KEY = @"id";

/**
 *  token失效
 */

static NSString *const kToken_Code_Value_Invalid = @"user_need_login_token_invalid";
static NSString *const kToken_Code_Value_Disabled = @"user_need_login_token_expire";
//自定义错误，token错误的code
FOUNDATION_EXPORT NSInteger const kAPPErrorCode_Token;

//head
#define HEAD_API_VERSION @"v"   //接口版本号
#define HEAD_TTID @"ttid"    //app版本号@平台
//客户端标识，大版本号.小版本号.bugfix版本_ysb@平台--v=1.0.0_ysb@iphone
#define HEAD_AUTHTOKEN @"mat"    //安全认证唯一标识 登录以后获得 用户authToken，32位唯一标识字符串
#define HEAD_TS @"ts"        //时间戳 1970年1月1日到当前时间毫秒数 ts=1480929340486
#define HEAD_DID @"did"    //手机终端唯一标识 设备ID
#define HEAD_LNG @"lng"      //经度
#define HEAD_LAT @"lat"      //纬度








/**
 * http post 通讯 API基类
 */

@interface BaseHttpAPI : NSObject


//公司业务添加的参数
-(NSMutableDictionary *)addRequestPostData:(NSMutableDictionary *)dicArgument apiName:(NSString *)aApi;
//公司业务需要的版本号及平台
+ (NSString *)getCurrentAppVersion;


- (void)requestSuccessDealWithResponseObeject:(id)responseObject success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 *  HTTP Post 请求
 *
 *  @param path      请求路径
 *  @param parameter 请求参数
 *  @param success   成功block
 *  @param failure   失败block
 */
- (void)postRequest:(NSString *)path parameters:(NSDictionary *)parameter success:(CompleteBlock) success failure:(ErrorBlock)failure;



-(void)getRequest:(NSString *)path parameters:(NSDictionary *)parameter success:(CompleteBlock)success failure:(ErrorBlock)failure;



-(void)synchronouslyGetRequest:(NSString *)path parameters:(NSDictionary *)parameter success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 *  上传图片
 *
 *  @param path           path description
 *  @param parameters     parameters description
 *  @param block          block description
 *  @param uploadProgress uploadProgress description
 *  @param success        success description
 *  @param failure        failure description
 */
- (void)postRequest:(NSString *)path parameters:(id)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
           progress:(void (^)(NSProgress *uploadProgress))uploadProgress
            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end



/*
 #pragma mark -
 
 - (void)headerRefresh
 {
    WS(weakSelf);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
     
         [[[AppAPIHelper shareInstance] getThemeModelAPI]getThemeHomeListWithPageNo:1 pageSize:@(10) success:^(id data) {
 
             [weakSelf.dataMArray removeAllObjects];
             [weakSelf.dataMArray addObjectsFromArray:data];
             [weakSelf.collectionView reloadData];
             _pageNo = 1;
             [weakSelf.collectionView.mj_header endRefreshing];
             [weakSelf.collectionView.mj_footer endRefreshing];
             
             [weakSelf footerWithRefreshing];
             if ([data count]<10)
             {
                 [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
             }
         
             static dispatch_once_t onceToken;
             dispatch_once(&onceToken, ^{
             
             [self lauchFirstNewFunction];
             
             });
         
         } failure:^(NSError *error) {
         
             [weakSelf.collectionView.mj_header endRefreshing];
             [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
         }];
     
     }];
 }
 
 
 
 
 - (void)footerWithRefreshing
 {
     if (self.dataMArray.count==0)
     {
         if (self.collectionView.mj_footer)
         {
             self.collectionView.mj_footer = nil;
         }
         return;
     }
 WS(weakSelf);
 self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
 
     NSLog(@"%@",@(_pageNo));
     [[[AppAPIHelper shareInstance] getThemeModelAPI]getThemeHomeListWithPageNo:_pageNo+1 pageSize:@(10) success:^(id data) {
 
         [weakSelf.dataMArray addObjectsFromArray:data];
         [weakSelf.collectionView reloadData];
         [weakSelf.collectionView.mj_footer endRefreshing];
         
         _pageNo ++;
         if ([data count]<10)
         {
             [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
         }
     
     } failure:^(NSError *error) {
     
         [weakSelf.collectionView.mj_footer endRefreshing];
         [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
         }];
     }];
 }
 
 
 
 */

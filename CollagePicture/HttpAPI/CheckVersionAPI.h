//
//  CheckVersionAPI.h
//  CollagePicture
//
//  Created by simon on 16/11/18.
//  Copyright © 2016年 simon. All rights reserved.
//
//  2018.3.26 修改固定路径为类目获取；
//  2018.5.10 优化代码

#import "BaseHttpAPI.h"
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CompleteBlock)(id data);
typedef void (^ErrorBlock)(NSError* error);


@class CheckVersionAPI;

@protocol CheckVersionDelegate <NSObject>


/**
 *  @brief 已经是最新版本
 *
 */
- (void)zxCheckVersionWithNoNewVersion:(CheckVersionAPI *)versionAPI;

/**
 *  @brief 有新版本，回调更新提示
 */
- (void)zxCheckVersionWithNewVersion:(CheckVersionAPI *)versionAPI;

@end


@interface CheckVersionAPI : NSObject

@property (nonatomic ,assign)NSString *itunesVersion;

@property (nonatomic,weak)id<CheckVersionDelegate>delegate;

+ (instancetype)shareInstance;

//检查itunes版本数据－请求
- (void)checkVersionSuccessWithAppId:(NSString *)appId success:(CompleteBlock)success failure:(ErrorBlock)failure;

- (nullable NSString *)getAppVersionFromItunes:(NSString *)appId;

//检查版本更新－包括请求业务
-(void)checkVersionUpdateWithController:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
/*
 {
 "resultCount":1,
 "results": [
 {"ipadScreenshotUrls":[], "appletvScreenshotUrls":[], "artworkUrl60":"http://is4.mzstatic.com/image/thumb/Purple71/v4/96/09/85/96098522-96a0-9bdd-2daf-2e71c68061cb/source/60x60bb.jpg", "artworkUrl512":"http://is4.mzstatic.com/image/thumb/Purple71/v4/96/09/85/96098522-96a0-9bdd-2daf-2e71c68061cb/source/512x512bb.jpg", "artworkUrl100":"http://is4.mzstatic.com/image/thumb/Purple71/v4/96/09/85/96098522-96a0-9bdd-2daf-2e71c68061cb/source/100x100bb.jpg", "artistViewUrl":"https://itunes.apple.com/us/developer/hang-zhou-dian-ke-ji-you-xian/id1082092068?uo=4", "kind":"software", "features":[],
 "supportedDevices":["iPhone4", "iPad2Wifi", "iPad23G", "iPhone4S", "iPadThirdGen", "iPadThirdGen4G", "iPhone5", "iPodTouchFifthGen", "iPadFourthGen", "iPadFourthGen4G", "iPadMini", "iPadMini4G", "iPhone5c", "iPhone5s", "iPhone6", "iPhone6Plus", "iPodTouchSixthGen"], "advisories":[],
 "screenshotUrls":["http://a2.mzstatic.com/us/r30/Purple20/v4/81/f7/f1/81f7f19b-259e-8094-ec2a-eaec43f9f174/screen696x696.jpeg", "http://a1.mzstatic.com/us/r30/Purple60/v4/9d/d9/83/9dd98310-632d-9836-43d0-e7e9d91934ef/screen696x696.jpeg", "http://a5.mzstatic.com/us/r30/Purple60/v4/e2/fb/ce/e2fbce9d-e5b0-d6bb-2726-be5752ae0e1a/screen696x696.jpeg", "http://a3.mzstatic.com/us/r30/Purple18/v4/40/1e/a6/401ea6dd-7b19-8bd8-fced-27faea0d3c23/screen696x696.jpeg", "http://a4.mzstatic.com/us/r30/Purple20/v4/bd/18/c1/bd18c16a-e47b-2f50-ceb9-7f436c47f344/screen696x696.jpeg"], "isGameCenterEnabled":false, "trackCensoredName":"拉薇宝贝", "languageCodesISO2A":["EN", "ZH"], "fileSizeBytes":"33510400", "contentAdvisoryRating":"4+", "trackViewUrl":"https://itunes.apple.com/us/app/la-wei-bao-bei/id1082092069?mt=8&uo=4", "trackContentRating":"4+", "minimumOsVersion":"7.0", "currency":"USD", "wrapperType":"software", "version":"1.3.0", "artistId":1082092068, "artistName":"杭州安点科技有限公司", "genres":["Utilities"], "price":0.00,
 "description":"产品简介：\u2028关于爱与幸福的产品，由于孩子远游，与父母相隔千里，而父母对于孩子的记忆会淡化，对于孩子的孩子无法及时获取信息，我们想要让幸福的记忆永存，让所有的爱能同步。\n\n【妈妈钟爱理由】   宝宝照片随时整理，每年制作；\n【情侣钟爱理由】   天天秀恩爱，年年做相册；\n【小资钟爱理由】   我的资生活，我的故事集；", "bundleId":"com.ANdian.loveBaby", "trackName":"拉薇宝贝", "trackId":1082092069, "releaseDate":"2016-02-15T21:18:43Z", "primaryGenreName":"Utilities", "currentVersionReleaseDate":"2016-09-22T03:21:21Z", "isVppDeviceBasedLicensingEnabled":true, "formattedPrice":"Free", "releaseNotes":"1、影楼微网站功能，可以参与影楼活动、购买套系\n2、影楼云盘，随时查看影楼相关照片\n3、上传照片优化，减少等待时间\n4、部分崩溃问题优化。", "sellerName":"Hangzhou AnDian technology Co., Ltd", "primaryGenreId":6002, "genreIds":["6002"]}]
 }

*/

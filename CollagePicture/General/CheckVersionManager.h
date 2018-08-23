//
//  CheckVersionManager.h
//  YiShangbao
//
//  Created by simon on 17/6/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MessageModel.h"
#import "HKVersionAlertView.h"

// 2017.12.29
// 修改单列方法名字；
// 2018.2.5； 优化代码；

typedef void (^NextStepBlock)(void);

@interface CheckVersionManager : NSObject

+ (instancetype)sharedInstance;

#pragma mark - 检查更新请求

// 整个app只执行一次；
- (void)checkAppVersionOnceWithNextStep:(NextStepBlock)nextStep;

// 可以执行多次；
- (void)checkAppVersionWithNextStep:(NextStepBlock)nextStep;


@end

//
//  ZXAlertTextActionGroupHeaderView.h
//  MobileCaiLocal
//
//  Created by 朱新明 on 2020/2/17.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef LCDScale_iPhone6
#define LCDScale_iPhone6(X)    ((X)*([[UIScreen mainScreen] bounds].size.width)/375)
#endif

@interface ZXAlertTextActionGroupHeaderView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *messageLabel;

- (void)creatMessageLabel:(NSString *)message;

- (CGFloat)getHeaderHeight;
@end

NS_ASSUME_NONNULL_END

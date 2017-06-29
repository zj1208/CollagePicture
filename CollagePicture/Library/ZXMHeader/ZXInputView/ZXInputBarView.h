//
//  ZXInputBarView.h
//  Baby
//
//  Created by simon on 16/2/23.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXOverlay.h"
#import "ZXPlaceholdTextView.h"


/// 弹出输入框,主要用于scrollView直接回复用的；

NS_ASSUME_NONNULL_BEGIN


@class ZXInputBarView;
@protocol ZXInputBarViewDelegate <NSObject>


/**
 *  点击键盘的“发送”键，发送文本回调代理方法
 *
 *  @param inputView inputView实例
 *  @param text      发送的文本内容
 */

- (void)zxInputBarViewSendContentWithInputView:(ZXInputBarView *)inputView text:(NSString *)text indexPath:(nullable NSIndexPath *)aIndexPath;

@end


@interface ZXInputBarView : UIView<ZXOverlayDelegate,UITextViewDelegate>

@property (nonatomic, strong) ZXPlaceholdTextView * textView;

@property (nullable, nonatomic, weak) id<ZXInputBarViewDelegate>delegate;


/**
 *  window上弹出输入框实例方法
 *
 *
 */

- (void)showInputBarView;

- (void)showInputBarViewWithIndexPath:(nullable NSIndexPath *)indexPath;
@end


NS_ASSUME_NONNULL_END


//*********//
/*
初始化：
_inputBarView = [[ZXInputBarView alloc] init];
_inputBarView.delegate = self;


调用：
[self.inputBarView showInputBarViewWithIndexPath:indexPath];


代理回调：
- (void)zxInputBarViewSendContentWithInputView:(ZXInputBarView *)inputView text:(NSString *)text indexPath:(NSIndexPath *)aIndexPath
*/

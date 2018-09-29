//
//  UILabel+ZXExtension.h
//  YiShangbao
//
//  Created by simon on 17/6/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  2018.2.9；修改label的badge角标方法
//  2018.4.19 修改文字绘画选项,角标计算不准的问题；
//  2018.5.09 优化代码

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ZXExtension)

/**
 * @brief  设置一个icon,在数字小于2位数的时候,是圆标记; 如果大于等于2位数,是2边半圆+中间长方形; 可以根据maginY调节文字与垂直边界的距离;
   例如： [self.badgeLab zh_digitalIconWithBadgeValue:model.num maginY:1 badgeFont:[UIFont systemFontOfSize:LCDScale_iPhone6_Width(12)] titleColor:[UIColor whiteColor] backgroundColor:[UIColor redColor]];
  iOS8上 高度计算不对？
 */
- (void)zh_digitalIconWithBadgeValue:(NSInteger)aBadgeValue maginY:(CGFloat)aMaginY badgeFont:(nullable UIFont *)font titleColor:(nullable UIColor *)aTitleColor backgroundColor:(nullable UIColor*)aBgColor;



/**
 富文本设置最小行高，用于多行显示

 @param text 要显示的字符串，传nil则以self.text显示
 @param spacing 最小行高（eg:一般为UI设计图一半）
 */
-(void)jl_setAttributedText:(nullable NSString *)text withMinimumLineHeight:(float)spacing;

//富文本设置行间距
-(void)jl_setAttributedText:(nullable NSString *)text withLineSpacing:(float)spacing;


/**
 富文本添加中划线

 @param text 要显示的字符串,传nil则以self.text显示
 @param color 中划线颜色
 */
-(void)jl_addMediumLineWithText:(nullable NSString*)text lineColor:(UIColor*)color;

/**
 将字符串中所有的数字颜色、字体修改

 @param text eg:入住商铺394 上传产品20140
 @param numColr numColr 数字颜色
 @param font 数字字体
 */
-(void)jl_changeStringOfNumberStyle:(nullable NSString*)text numberColor:(UIColor*)numColr numberFont:(UIFont*)font;

@end


/**
 分类：给UILabel加个长按复制功能
 会触发window层级发生改变，导致加载最上层window的toast不展示，具体原因可能和交换UIResponder相关方法有关、而长按的menu复制组件直接继承NSObject，有空再研究，先该用子类JLCopyLabel来实现需求
 
//========WYTextCopy==========
typedef void(^TextDidCopyHandler)(UILabel *label);
@interface UILabel (WYTextCopy)
//长按复制功能，默认NO
@property (nonatomic, assign) BOOL isNeedCopy;
//长按手势，默认nil,isNeedCopy=YES即立即创建长按手势
@property (nonatomic, strong, nullable) UILongPressGestureRecognizer * longCopyPressGesture;
//长按复制完成回调
@property (nonatomic, copy) TextDidCopyHandler textDidCopyHandler;
@end
*/




NS_ASSUME_NONNULL_END

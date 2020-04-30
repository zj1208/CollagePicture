//
//  UIButton+ZXHelper.h
//  MusiceFate
//
//  Created by simon on 13/3/21.
//  Copyright © 2013年 yinyuetai.com. All rights reserved.
//
//  简介：
/**
默认情况下，imageEdgeInsets和titleEdgeInsets都是UIEdgeInsetsZero
，且imageView和titleLable之间没有间距。以宽度为例，
 
(1)if (button.width小于imageView上image的width){图像会被压缩，文字不显示}
(2)if (button.width < imageView.width + label.width){图像正常显示，文字显示不全}
(3)if (button.width >＝ imageView.width + label.width){图像和文字都居中显示，imageView在左，label在右，没有间距}
*/
// 注意：zx_centerXRightImageAndLeftTitleWithSpace 方法在不设置宽度约束的时候还有问题；

// 2019.11.26  增加图片在右标题在左的布局改变方法；
// 2019.12.09  修改bug；
// 2020.2.02  优化；
// 2020.2.24  修改ZXButtonContentTypeImageRightTitleLeft类型的方法；
// 2020.2.28  再次优化ZXButtonContentTypeImageRightTitleLeft类型的方法；
// 2020.4.28 优化zx_centerVerticalImageAndTitleWithSpace 上下居中的方法；

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, ZXButtonContentType) {
    ZXButtonContentTypeImageLeftTitleRight,   //图片在左，标题在右，默认风格
    ZXButtonContentTypeImageRightTitleLeft,  //图片在右，标题在左
//    ZXImagePositionTypeTop,    //图片在上，标题在下
};


@interface UIButton (ZXHelper)


/*
调整contentInset，必须在设置完数据后，获取到真实的frame才能调整，autolayout通过下列方法可以拿到:
1. layoutSubViews
2. viewDidLayoutSubviews
3. 父view调用layoutIfNeeded
*/

/**
 * @brief 调用zx_centerVerticalImageAndTitleWithSpace; 默认图文间隔大小是6;
 */

- (void)zx_centerVerticalImageAndTitleDefault;


/**
 * @brief 在本地数据情况下使用，使得image和title上下居中；
 * @param spacing   image和title之间的间隔大小；
 */

- (void)zx_centerVerticalImageAndTitleWithSpace:(float)spacing;


/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现图片和标题的自由排布；
 *  内部会调用layoutIfNeed，根据实际内容动态改变frame大小；-2019.12.09 增加
 *  注意：1.该方法需在设置图片和标题之后才调用;
         2.图片和标题改变后需再次调用以重新计算titleEdgeInsets和imageEdgeInsets
 *
 *  @param type    图片位置类型
 *  @param spacing 图片和标题之间的间隙,默认是0个间距；按钮宽度必须大于（图片＋文本）自适应的宽度；
 *  注意：如果约束没有设置width，或者约束设置宽度比较小会出bug，暂时还没有解决方案；
 */
- (void)zx_setImagePositionWithType:(ZXButtonContentType)type spacing:(CGFloat)spacing;




/**
 * @brief 当前视图独占触摸事件，但是手势识别会忽略exclusiveTouch设置；
 */
- (void)zx_buttonExclusiveTouch;


/**
 *  获取tableView/UICollectionView中的cell的button的indexPath
 *
 *  @param view  tableView/collectionView
 *
 *  @return indexPath
 */

- (nullable NSIndexPath *)zx_getIndexPathWithBtnInCellFromTableViewOrCollectionView:(nullable UIScrollView *)view;


/// 按钮禁止状态，alpha=0.5
/// @param enabled enabled description
- (void)zx_changeAlphaWithCurrentUserInteractionEnabled:(BOOL)enabled;



- (void)zx_changeEnableWithCurrentUserInteractionEnabled:(BOOL)enabled enableTitleColor:(UIColor *)color1 enableBgColor:(UIColor *)color2 noableTitleColor:(UIColor *)color3 noableBgColor:(UIColor *)color4;


/**
 * @brief  灰掉禁止按钮-以白灰2种颜色切换;
 */
- (void)zh_userSwitchWhiteAndLightGrayColorWithInteractionEnabled:(BOOL)enabled;




/**
 * @brief 未选中的时候背景颜色是白色,边框颜色和文字颜色为boardColor;选中的按钮背景颜色动态改变为边框颜色boardColor,文字颜色改为白色;
 */

- (void)zh_userSelectedEnabled:(BOOL)enabled boardColor:(UIColor*)boardColor;


/**
 *  2种颜色，文字颜色和背景颜色转换
 *
 *  @param enabled 是否禁止触摸
 *  @param color1  正常状态字体颜色1；禁止触摸状态背景颜色
 *  @param color2  正常状态背景颜色；禁止触摸状态字体颜色2
 */
- (void)zh_userInteractionEnabled:(BOOL)enabled switchEnableTitleColor:(UIColor *)color1 enableBgColor:(UIColor *)color2;


/**
 设置一个按钮的文本颜色／背景颜色／是否禁用

 @param enabled enabled description
 @param color1 color1 description
 @param color2 color2 description
 */
- (void)zh_userInteractionEnabled:(BOOL)enabled titleColor:(UIColor *)color1 bgColor:(UIColor *)color2;

//设置button按钮选中 和非选中的文字颜色和图片
- (void)zh_setImage:(UIImage *)image1 selectImage:(UIImage *)image2  titleColor:(UIColor *)color1 selectTitleColor:(UIColor *)color2;


/**
 设置button 2行不同字体／颜色的富文本显示的文字；
 要求：文字不能太多，不然会出现多行显示不下的问题；

 使用例子：
 NSAttributedString *line1Att = [[NSAttributedString alloc] initWithString:@"存为私密产品" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB_HexValue(0x666666),
 NSFontAttributeName:[UIFont systemFontOfSize:16]}];
 NSAttributedString *line2Att = [[NSAttributedString alloc] initWithString:@"(不公开只能分享查看)" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB_HexValue(0x666666),
 NSFontAttributeName:[UIFont systemFontOfSize:12]}];
 [self.toPrivacyBtn zh_setTowOfLinesStringWithLineSpace:8.f firstLineWithAttributedTitle:line1Att secondLineWithAttributedTitle:line2Att];
 
 @param space 2行文字之间的行间距
 @param attributed1 attributed1 description
 @param attributed2 attributed2 description
 */
- (void)zh_setTowOfLinesStringWithLineSpace:(CGFloat)space firstLineWithAttributedTitle:(nullable NSAttributedString *)attributed1 secondLineWithAttributedTitle:(nullable NSAttributedString *)attributed2;



- (void)zh_setButtonImageViewScaleAspectFill;
@end

NS_ASSUME_NONNULL_END

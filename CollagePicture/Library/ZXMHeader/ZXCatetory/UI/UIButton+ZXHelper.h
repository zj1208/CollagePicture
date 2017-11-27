//
//  UIButton+ZXHelper.h
//  SiChunTang
//
//  Created by simon on 15/11/21.
//  Copyright © 2015年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ZXHelper)

/**
 * @brief 调用zhuCenterImageAndTitle:titleFontOfSize; 默认图文间隔大小是6;
 * @param fontSize  字体大小，根据字体大小会有相应改变高度；
 */

- (void)zh_centerVerticalImageAndTitle_titleFontOfSize:(CGFloat)fontSize;


/**
 * @brief 在本地数据情况下使用，使得image和title上下居中；
 * @param spacing   image和title之间的间隔大小；
 * @param fontSize  字体大小，根据字体大小会有相应改变高度；
 */

- (void)zh_centerVerticalImageAndTitleWithSpace:(float)spacing titleFontOfSize:(CGFloat)fontSize;



/**
 设置button按钮在默认左边图标和右边文字共存的情况下，设置间距；默认是0个间距；按钮宽度必须大于（ 图片＋文本 ）自适应的宽度；

 @param spacing image和title的间距；
 */
- (void)zh_centerHorizontalImageAndTitleWithTheirSpace:(float)spacing;

/**
 * @brief 当前视图独占触摸事件，但是手势识别会忽略exclusiveTouch设置；
 */
- (void)zh_buttonExclusiveTouch;


/**
 *  获取tableView/UICollectionView中的cell的button的indexPath
 *
 *  @param view  tableView/collectionView
 *
 *  @return indexPath
 */

- (nullable NSIndexPath *)zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:(nullable UIScrollView *)view;


/**
 * @brief  灰掉禁止按钮-以白灰2种颜色切换;
 */
- (void)zh_userSwitchWhiteAndLightGrayColorWithInteractionEnabled:(BOOL)enabled;

- (void)zh_userInteractionEnabledWithAlpha:(BOOL)enabled;

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

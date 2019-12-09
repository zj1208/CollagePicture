//
//  UINavigationItem+ZXCategory.h
//  MobileCaiLocal
//
//  Created by simon on 2019/11/26.
//  Copyright © 2019 timtian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationItem (ZXCategory)


#pragma mark - backBarButtonItem
/**
 *  @brief 自定义系统下一个页面的返回按钮文字title,如果aTitle==nil,only arrow;
 *
 */
- (void)zx_backBarButtonItem_title:(nullable NSString *)aTitle font:(NSInteger)aFont;


#pragma mark-add logo-titleView

/*给navigationBar上添加 logo-titleView的imageView,Label的title
 如果是统一的，就用[[UINavigationBar appearance] setTitleTextAttributes 等方法。如首页需要logo，或者title和TabbarItem不一样。
 */
/**
 * @brief add logo--titleView's imageView。
 * @param imageName  图片名字
 */
- (void)zx_titleViewImageViewWithImageName:(nullable NSString*)imageName;


/**
 * @brief add logo---titleView's Label with title。
 * @param aTitle  文字内容。
 * @param aFont   文字字体；
 * @param aColor  文字颜色
 */
- (void)zx_titleViewLabelWithTitle:(nullable NSString*)aTitle font:(NSInteger)aFont titleColor:(UIColor*)aColor;


@end

NS_ASSUME_NONNULL_END

//
//  UINavigationItem+ZXCategory.m
//  MobileCaiLocal
//
//  Created by simon on 2019/11/26.
//  Copyright © 2019 com.Chs. All rights reserved.
//

#import "UINavigationItem+ZXCategory.h"


@implementation UINavigationItem (ZXCategory)


/**
 *  @brief 自定义系统的返回按钮文字title,如果aTitle==nil,only arrow;当文字太长的时候,可以用这个设置系统返回;
 *  navigationItem的backBarButtonItem的action是不会执行的.无论怎么改，除了popViewController什么都不执行。
 *
 */
- (void)zx_backBarButtonItem_title:(nullable NSString *)aTitle font:(NSInteger)aFont
{
    NSString *string = aTitle ? aTitle : @"";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:string style:UIBarButtonItemStylePlain target:self action:nil];
    if (aTitle)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:aFont] forKey:NSFontAttributeName];
        [cancelButton setTitleTextAttributes:dic forState:UIControlStateNormal];

    }
    
    self.backBarButtonItem = cancelButton;
}


/*----------------------------------------------------*/
//给navigationBar上添加 logo-titleView的imageView／title
- (void)zx_titleViewImageViewWithImageName:(nullable NSString*)imageName
{
    UIImage *img = [UIImage imageNamed:imageName];
    if (!img)
    {
        return;
    }
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    self.titleView = imgView;
}


- (void)zx_titleViewLabelWithTitle:(nullable NSString*)aTitle font:(NSInteger)aFont titleColor:(UIColor*)aColor
{
    UILabel *navLab = [[UILabel alloc] initWithFrame:CGRectZero];
    navLab.text = aTitle;
    navLab.textColor = aColor?aColor:[UIColor whiteColor];
    navLab.font = [UIFont boldSystemFontOfSize:aFont];
    [navLab sizeToFit];
    self.titleView = navLab;
}
@end

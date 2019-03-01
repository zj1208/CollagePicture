//
//  KxMenu.h
//  kxmenu project
//  https://github.com/kolyvan/kxmenu/
//
//  Created by Kolyvan on 17.05.13.
//

/*
 Copyright (c) 2013 Konstantin Bukreev. All rights reserved.
 
 */

// 2019.3.01 增加ZXKxMenuOverlay类


typedef enum {
    KxMenuCellSeperateStyleNone,   //不设置 分割线；
    KxMenuCellSeperateStyleLine, // 有分割线；
} KxMenuCellSeperateStyle;



#import <Foundation/Foundation.h>

#import "KxMenuItem.h"
@interface KxMenu : NSObject

@property(nonatomic) BOOL  observing;


//overlay背景色，默认是透明的；
@property(nonatomic,strong)UIColor * kxMenuOverlayBackgroundColor;

//KxMenuView背景色
@property(nonatomic,strong)UIColor * tintColor;

/**
 *@brief 设置字体大小；
 */
@property(nonatomic,strong)UIFont *titleFont;

/**
 *@brief 分割线样式；
 */
@property(nonatomic)KxMenuCellSeperateStyle kxMenuCellSeperateStyle;



/**
 *@brief set 内容按钮边缘距离；
 */
@property(nonatomic)UIEdgeInsets contentViewEdge;

/**
 *@brief 设置选中背景状态；
 */

@property(nonatomic,strong)UIColor *kxMenuSelectionBackgoundColor;

+ (instancetype) sharedMenu;


/**
 *@brief 获取箭头大小－高度；
 */
//@property(nonatomic,readonly)CGFloat arrowHeight;


+ (void) showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems;

+ (void) dismissMenu;

@end




/*************** eg**************
// #import "KxMenu.h"
 
 - (IBAction)rightBarItemAction:(UIBarButtonItem *)sender
 {
    KxMenuItem *item1 = [KxMenuItem menuItem:@"发消息" image:nil target:self action:@selector(sendMessageTo:)];
    KxMenuItem *item2 = [KxMenuItem menuItem:@"找好友" image:nil target:self
    action:@selector(findFriends:)];
    NSArray * menuItems =@[item1,item2];

    // 设置外观
    KxMenu *kxMenu = [KxMenu sharedMenu];
    kxMenu.tintColor =[UIColor colorWithWhite:0.2 alpha:0.7];
    kxMenu.selectionBackgroundImageStyle = KxMenuSelectionStyleSolidColorBackground;
    kxMenu.contentViewEdge = UIEdgeInsetsMake(5, 5, 5, 5);
 
    CGFloat safeAreaTop  = 0;
    if @available(iOS 11.0, *) {
        UIWindow *window = ((UIApplication.shared.delegate?.window)!)!;
        UIEdgeInsets areaInset = window.safeAreaInsets
        if areaInset != UIEdgeInsets.zero
        {
            safeAreaTop = Int(areaInset.top);
        }
    }else {
    };
    [KxMenu showMenuInView:APP_keyWindow fromRect:CGRectMake(LCDW-44-5, safeAreaTop +44 - 2, 44, 2) menuItems:menuItems];
 }
 
 
 - (void)sendMessageTo:(KxMenuItem *)sender
 {
 
 }
 
 
 - (void)findFriends:(KxMenuItem *)sender
 {
 
 }
 */

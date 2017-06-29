//
//  KxMenuView.h
//  Baby
//
//  Created by simon on 16/1/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    
    KxMenuViewArrowDirectionNone,
    KxMenuViewArrowDirectionUp,
    KxMenuViewArrowDirectionDown,
    KxMenuViewArrowDirectionLeft,
    KxMenuViewArrowDirectionRight,
    
} KxMenuViewArrowDirection;





#import "ZXOverlay.h"
#import "KxMenuItem.h"
#import "KxMenu.h"
@interface KxMenuView : UIView<ZXOverlayDelegate>

@property(nonatomic,strong) UIView*contentView;
@property(nonatomic,strong)NSArray*menuItems;
@property(nonatomic)KxMenuViewArrowDirection arrowDirection;
@property(nonatomic)CGFloat  arrowPosition;

@property(nonatomic)CGFloat maxItemWidth;
@property(nonatomic)CGFloat maxItemHeight;










- (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems;



- (void)dismissMenu:(BOOL) animated;

@end

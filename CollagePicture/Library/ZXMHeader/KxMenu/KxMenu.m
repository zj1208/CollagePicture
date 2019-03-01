//
//  KxMenu.m
//  kxmenu project
//  https://github.com/kolyvan/kxmenu/
//
//  Created by Kolyvan on 17.05.13.
//

/*
 Some ideas was taken from QBPopupMenu project by Katsuma Tanaka.
 https://github.com/questbeat/QBPopupMenu
*/

#import "KxMenu.h"
#import "KxMenuView.h"



@interface KxMenu ()
@property(nonatomic,strong) KxMenuView  *menuView;
@property(nonatomic,strong) ZXKxMenuOverlay *overlay;

@end


@implementation KxMenu

//单例
+ (instancetype) sharedMenu
{
    static KxMenu *gMenu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        gMenu = [[KxMenu alloc] init];
        
    });
    return gMenu;
}




+ (void) showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems
{
    [[self sharedMenu] showMenuInView:view fromRect:rect menuItems:menuItems];
}




+ (void) dismissMenu
{
    [[self sharedMenu] dismissMenu];
}





- (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
{
    if (self.menuView)
    {
        [self.menuView dismissMenu:NO];
        self.menuView = nil;
    }
    
    self.menuView = [[KxMenuView alloc] init];
    [self.menuView showMenuInView:view fromRect:rect menuItems:menuItems];

    if (!_observing)
    {
        _observing = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationWillChange:)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification
                                                object:nil];
    }
}




- (void) dismissMenu
{
    if (self.menuView)
    {
        [self.menuView dismissMenu:NO];
        self.menuView = nil;
    }
    
    if (_observing) {
        
        _observing = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}



- (void) orientationWillChange: (NSNotification *)notification
{
    [self dismissMenu];
}


- (void) dealloc
{
    if (_observing)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

//- (CGFloat)arrowHeight
//{
//    return kArrowSize;
//}
//
@end

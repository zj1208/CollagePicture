//
//  ZXKeyboardManager.m
//  YiShangbao
//
//  Created by simon on 2018/4/25.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXKeyboardManager.h"

#ifndef IS_IPHONE_XX
#define IS_IPHONE_XX ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) { \
    UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;\
    if (areaInset.bottom >0) { \
        tmp = 1;\
    }\
}\
else{\
    tmp = 0;\
}\
tmp;\
})
#endif

#ifndef  HEIGHT_NAVBAR
#define  HEIGHT_NAVBAR      (IS_IPHONE_XX ? (44.f+44.f) : (44.f+20.f))
#endif

@interface ZXKeyboardManager ()

@property (nonatomic, copy) NSString * activedTextFieldRect;

@end;

@implementation ZXKeyboardManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
 
    }
    return self;
}

- (void)setSuperView:(UIView *)superView
{
    _superView = superView;
    if ([_superView isKindOfClass:[UITableView class]] ||[_superView isKindOfClass:[UICollectionView class]] ||[_superView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView*tableView = (UIScrollView *)_superView;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
}
- (instancetype)initWithSuperView:(UIView *)superView
{
    self = [super init];
    if (self) {
        
        self.superView = superView;
    }
    return self;
}
+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{

        if (!instance)
        {
            instance = [self new];
        }
    });
    return instance;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 注册通知

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name: UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange:) name: UIKeyboardDidChangeFrameNotification object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //  Registering for UITextField notification.
    [self registerTextFieldTextViewClass:[UITextField class]
     didBeginEditingNotificationName:UITextFieldTextDidBeginEditingNotification
       didEndEditingNotificationName:UITextFieldTextDidEndEditingNotification];
    
    [self registerTextFieldTextViewClass:[UITextView class] didBeginEditingNotificationName:UITextViewTextDidBeginEditingNotification didEndEditingNotificationName:UITextViewTextDidEndEditingNotification];
}



-(void)registerTextFieldTextViewClass:(nonnull Class)aClass
  didBeginEditingNotificationName:(nonnull NSString *)didBeginEditingNotificationName
    didEndEditingNotificationName:(nonnull NSString *)didEndEditingNotificationName
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldViewBeginEditing:) name:didBeginEditingNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldViewEndEditing:) name:didEndEditingNotificationName object:nil];
}


#pragma mark - 移除通知

- (void)removeObserverForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [self unregisterTextFieldTextViewClass:[UITextField class] didBeginEditingNotificationName:UITextFieldTextDidBeginEditingNotification didEndEditingNotificationName:UITextFieldTextDidEndEditingNotification];
    [self unregisterTextFieldTextViewClass:[UITextView class] didBeginEditingNotificationName:UITextViewTextDidBeginEditingNotification didEndEditingNotificationName:UITextViewTextDidEndEditingNotification];
}

-(void)unregisterTextFieldTextViewClass:(nonnull Class)aClass
        didBeginEditingNotificationName:(nonnull NSString *)didBeginEditingNotificationName
          didEndEditingNotificationName:(nonnull NSString *)didEndEditingNotificationName
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didBeginEditingNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didEndEditingNotificationName object:nil];
}


#pragma mark - textField/TextView回调

// textField 通知比 键盘通知早;textView 通知比 键盘通知迟
- (void)textFieldViewBeginEditing:(NSNotification *)noti
{
    UIView *obj = noti.object;//textField,textView;
    CGRect rect = [obj.superview convertRect:obj.frame toView:self.superView];
    self.activedTextFieldRect = NSStringFromCGRect(rect);
    if ([obj isKindOfClass:[UITextView class]])
    {
        CGRect activeRect = CGRectFromString(self.activedTextFieldRect);
        if ((activeRect.origin.y + activeRect.size.height+HEIGHT_NAVBAR) >  ([UIScreen mainScreen].bounds.size.height - rect.size.height-40))
        {
            [UIView animateWithDuration:2.f animations:^{
                if ([self.superView isKindOfClass:[UITableView class]] ||[self.superView isKindOfClass:[UICollectionView class]] ||[self.superView isKindOfClass:[UIScrollView class]])
                {
                    UIScrollView*tableView = (UIScrollView *)self.superView;
                    tableView.contentOffset = CGPointMake(0, HEIGHT_NAVBAR + activeRect.origin.y + activeRect.size.height - ([UIScreen mainScreen].bounds.size.height - rect.size.height-40));
                }
            }];
        }
    }
}

- (void)textFieldViewEndEditing:(NSNotification *)noti
{
    
}

#pragma mark - 键盘回调

- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGRect activeRect = CGRectFromString(self.activedTextFieldRect);
    if ((activeRect.origin.y + activeRect.size.height+HEIGHT_NAVBAR) >  ([UIScreen mainScreen].bounds.size.height - rect.size.height-40))
    {
        [UIView animateWithDuration:duration animations:^{
            if ([self.superView isKindOfClass:[UITableView class]] ||[self.superView isKindOfClass:[UICollectionView class]] ||[self.superView isKindOfClass:[UIScrollView class]])
            {
                UIScrollView*tableView = (UIScrollView *)self.superView;
                tableView.contentOffset = CGPointMake(0, HEIGHT_NAVBAR + activeRect.origin.y + activeRect.size.height - ([UIScreen mainScreen].bounds.size.height - rect.size.height-40));
            }
        }];
    }
}

- (void)keyboardDidShow:(NSNotification *)noti
{
    
}
- (void)keyboardDidChange:(NSNotification *)noti
{
    
}
- (void)keyboardWillChange:(NSNotification *)noti
{
    
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    if ([_superView isKindOfClass:[UITableView class]] ||[_superView isKindOfClass:[UICollectionView class]] ||[_superView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView*tableView = (UIScrollView *)_superView;
        [tableView scrollRectToVisible:CGRectMake(0, 1, 1, 1) animated:NO];
    }
}

@end

//
//  ZXAlertTextController.m
//  MobileCaiLocal
//
//  Created by 朱新明 on 2020/2/17.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import "ZXAlertTextController.h"
#import "ZXAlertTextActionGroupHeaderView.h"
#import "ZXTextRectTextField.h"

/**
* @brief 16进制的字符串颜色转RGB.把＃变为0x，如果没有则加上。 eg:#34373A--ZXRGB_HexString(0X34373A)
*/
#ifndef ZXRGB_HexValue
#define ZXRGB_HexValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.f]
#endif

static NSInteger const UIAlertControllerBlocksCancelButtonIndex = 0;
static NSInteger const UIAlertControllerBlocksFirstOtherButtonIndex = 2;


@interface ZXAlertTextAction()

@property (nonatomic, copy) void(^handler)(ZXAlertTextAction *action);

@property (nonatomic, copy, nullable) NSString *actionTitle;

@property (nonatomic, assign) ZXAlertTextActionStyle actionStyle;

@property (nonatomic, assign) NSInteger actionTag;

@end

@implementation ZXAlertTextAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(ZXAlertTextActionStyle)style handler:(void (^ __nullable)(ZXAlertTextAction *action))handler
{
    ZXAlertTextAction *action = [[ZXAlertTextAction alloc] init];
    action.handler = handler;
    action.actionTitle = title;
    action.actionStyle = style;
    return action;
}


@end


@interface ZXAlertTextController ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) ZXAlertTextActionGroupHeaderView *actionGroupHeaderView;

@property (nonatomic, strong) ZXTextRectTextField *textField;

@property (nonatomic, strong, nullable) NSString *headTitle;
@property (nonatomic, strong, nullable) NSString *message;

@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *defaultBtn;

@property (nonatomic, strong) NSMutableArray *actionMArray;
@property (nonatomic, strong) NSMutableArray<UITextField *> *textFieldMArray;
@end

@implementation ZXAlertTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)dealloc
{

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

}



#pragma mark - setUI

- (void)setUI
{
    //    UIAlertController
     [self.view addSubview:self.containerView];
     [self setView:self.containerView cornerRadius:10.f borderWidth:0 borderColor:nil];

     CGFloat containerHeight = 196;
     [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.mas_equalTo(self.view.mas_left).with.offset(38);
         make.centerX.mas_equalTo(self.view.mas_centerX);
         make.top.mas_equalTo(self.view.mas_top).with.offset(CGRectGetHeight(self.view.bounds)/2-containerHeight/2);
         make.height.mas_equalTo(containerHeight);
     }];
     
     [self.containerView addSubview:self.actionGroupHeaderView];
     [self.actionGroupHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.containerView.mas_left);
         make.centerX.mas_equalTo(self.containerView.mas_centerX);
         make.top.mas_equalTo(self.containerView.mas_top);
         make.height.mas_equalTo([self.actionGroupHeaderView getHeaderHeight]);
     }];
     self.actionGroupHeaderView.titleLabel.text = self.headTitle;
     [self.actionGroupHeaderView creatMessageLabel:self.message];
     self.actionGroupHeaderView.messageLabel.text = self.message;
     
     [self.containerView addSubview:self.textField];
     [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
         
         make.left.mas_equalTo(self.containerView.mas_left).with.offset(20);
         make.centerX.mas_equalTo(self.containerView.mas_centerX);
         make.top.mas_equalTo(self.actionGroupHeaderView.mas_bottom).with.offset(0);
         make.height.mas_equalTo(44);
     }];
     [self.textFieldMArray addObject:self.textField];
     
     if (self.actionMArray.count == 2 || self.actionMArray.count ==0)
     {
         [self addTwoAction];
     }
}

- (void)addTwoAction
{
    [self.containerView addSubview:self.cancleBtn];
    self.cancleBtn.tag = UIAlertControllerBlocksCancelButtonIndex;
    
    [self.containerView addSubview:self.defaultBtn];
    self.defaultBtn.tag = UIAlertControllerBlocksFirstOtherButtonIndex;
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.textField.mas_bottom).with.offset(20);
        make.left.mas_equalTo(self.containerView.mas_left).with.offset(25);
        make.width.mas_equalTo(self.defaultBtn.mas_width);
        make.height.mas_equalTo(44);
        make.height.mas_equalTo(self.defaultBtn.mas_height);

    }];
    
    [self.defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.textField.mas_bottom).with.offset(20);
        make.left.mas_equalTo(self.cancleBtn.mas_right).with.offset(20);
        make.right.mas_equalTo(self.containerView.mas_right).with.offset(-25);
    }];
    
    [self.actionMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZXAlertTextAction *action = (ZXAlertTextAction *)obj;
        if (action.actionStyle == ZXAlertTextActionStyleCancel) {
            [self.cancleBtn setTitle:action.actionTitle forState:UIControlStateNormal];
            action.actionTag = UIAlertControllerBlocksCancelButtonIndex;
        }
        else
        {
            [self.defaultBtn setTitle:action.actionTitle forState:UIControlStateNormal];
            action.actionTag = UIAlertControllerBlocksFirstOtherButtonIndex;
        }
    }];
}



- (UIView *)containerView
{
    if (!_containerView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        _containerView = view;
    }
    return _containerView;
}

- (ZXAlertTextActionGroupHeaderView *)actionGroupHeaderView
{
    if (!_actionGroupHeaderView) {
        ZXAlertTextActionGroupHeaderView *view = [[ZXAlertTextActionGroupHeaderView alloc] init];
        _actionGroupHeaderView = view;
    }
    return _actionGroupHeaderView;
}

- (ZXTextRectTextField *)textField
{
    if (!_textField) {
        ZXTextRectTextField *field = [[ZXTextRectTextField alloc] init];
        field.placeholder = @"请输入";
        field.font = [UIFont systemFontOfSize:17];
        [self setView:field cornerRadius:10 borderWidth:1 borderColor:nil];
        field.backgroundColor =ZXRGB_HexValue(0xEDEFF0);
        field.keyboardType = UIKeyboardTypeNumberPad;
        _textField = field;
    }
    return _textField;
}

- (UIButton *)cancleBtn
{
    if (!_cancleBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:ZXRGB_HexValue(0x34373A) forState:UIControlStateNormal];
        [self setView:btn cornerRadius:5 borderWidth:0.5 borderColor:ZXRGB_HexValue(0xCCCCCC)];
        [btn addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancleBtn = btn;
    }
    return _cancleBtn;
}

- (UIButton *)defaultBtn
{
    if (!_defaultBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:ZXRGB_HexValue(0xFFFFFF) forState:UIControlStateNormal];
        btn.backgroundColor = ZXRGB_HexValue(0x36B44D);
        [self setView:btn cornerRadius:5 borderWidth:0.5 borderColor:nil];
        [btn addTarget:self action:@selector(defaultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _defaultBtn = btn;
    }
    return _defaultBtn;
}

//设置圆角
- (void)setView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    
    view.layer.borderColor =color?[color CGColor]:[UIColor clearColor].CGColor;
}

#pragma mark - setData

- (NSMutableArray *)actionMArray
{
    if (!_actionMArray) {
        _actionMArray = [NSMutableArray array];
    }
    return _actionMArray;
}

- (NSMutableArray<UITextField *> *)textFieldMArray
{
    if (!_textFieldMArray) {
        _textFieldMArray = [NSMutableArray array];
    }
    return _textFieldMArray;
}


#pragma mark - 实例方法

//actionGroupHeaderScrollView
//UIView
//lable,Label
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message
{
    ZXAlertTextController *vc = [[ZXAlertTextController alloc] init];
    vc.headTitle = title;
    vc.message = message;
    return vc;
}


- (NSArray<ZXAlertTextAction *> *)actions
{
    return self.actionMArray;
}


- (NSArray<UITextField *> *)textFields
{
    return self.textFieldMArray;
}

- (void)addAction:(ZXAlertTextAction *)action
{
    [self.actionMArray addObject:action];
}


#pragma mark - Action

- (void)cancleBtnAction:(UIButton *)sender
{
    __weak __typeof(&*self)weakSelf = self;
    if (sender.tag == UIAlertControllerBlocksCancelButtonIndex) {
        [self.actions enumerateObjectsUsingBlock:^(ZXAlertTextAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.actionTag == UIAlertControllerBlocksCancelButtonIndex) {
                [weakSelf dismissCurrentController];
                if (obj.handler) {
                    obj.handler(obj);
                }
                *stop = YES;
            }
        }];
    }
}



- (void)defaultBtnAction:(UIButton *)sender
{
    __weak __typeof(&*self)weakSelf = self;
    if (sender.tag == UIAlertControllerBlocksFirstOtherButtonIndex) {
        [self.actions enumerateObjectsUsingBlock:^(ZXAlertTextAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.actionTag == UIAlertControllerBlocksFirstOtherButtonIndex) {
                [weakSelf dismissCurrentController];
                if (obj.handler) {
                    obj.handler(obj);
                }
                *stop = YES;
            }
        }];
    }
}

#pragma mark - 销毁栈区内存对象

- (void)dismissCurrentController
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.parentViewController)
    {
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  UITextField+ZXHelper.m
//  CollagePicture
//
//  Created by xielei on 15/12/20.
//  Copyright © 2015年 mac. All rights reserved.
//


#import "UITextField+ZXHelper.h"
#import "NSString+ZXEntension.h"

@implementation UITextField (ZXHelper)


#pragma mark - 字符串的邮箱／手机号／URL／密码等验证

+ (BOOL)xm_validateEmail:(nullable NSString *)email
{
    if ([email rangeOfString:@"@"].length != 0 && [email rangeOfString:@"."].length !=0)
    {
        NSCharacterSet *tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet *tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        NSRange  range1 = [email rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        //取得用户名部分
        NSString *userNameString = [email substringToIndex:range1.location];
        NSArray *userNameArray = [userNameString componentsSeparatedByString:@"."];
        for(NSString *str in userNameArray)
        {
            NSRange rangeOfInavlidChars = [str rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if (rangeOfInavlidChars.length !=0 || [str isEqualToString:@""])
            {
                return NO;
            }
        }
        
        //取得域名部分
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray = [domainString componentsSeparatedByString:@"."];
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if (rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
            {
                return NO;
            }
        }
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (BOOL)xm_validateEmail2:(nullable NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


+ (BOOL)xm_validatePhoneNumber:(nullable NSString *)phone
{
    NSString *number = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    return [emailTest evaluateWithObject:phone];
}

+ (BOOL)xm_validatePassword:(NSString *)pass
{
    NSString *number = @"^[A-Za-z0-9]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    return [emailTest evaluateWithObject:pass];
}


#pragma mark - textField输入限制

+ (BOOL)xm_validateURL:(NSString *)url
{
    NSError *error;
    // 正则1
    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    
//    // 正则2
//    regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                          options:NSRegularExpressionCaseInsensitive
                                                                            error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:url options:0 range:NSMakeRange(0,[url length])];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [url substringWithRange:match.range];
        NSLog(@"匹配:%@",substringForMatch);
        return YES;
    }
    
    return NO;
}



#define myDotNumbers @"0123456789.\n"
#define myNumbers   @"0123456789\n"

+ (BOOL)xm_limitPayMoneyDot:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
          replacementString:(NSString *)string
                 dotPreBits:(int)dotPreBits
               dotAfterBits:(int)dotAfterBits

{
    //数字键盘是没有"\n"和""的
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""])
    {
        //按下return
        return YES;
    }
    
    NSCharacterSet *cs;
    NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
    //如果之前没有“.”,且不是第一个数
    if (NSNotFound == nDotLoc && 0 != range.location)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers]invertedSet];
        // 如果现在是“.”，则允许；
        if ([string isEqualToString:@"."])
        {
            return YES;
        }
        else
        {
             if ([textField.text isEqualToString:@"0"])
            {
                return NO;
            }
        }
        // 如果现在不是“.”,如果之前的整数已经到了规定限制，则不允许；
        if (textField.text.length >= dotPreBits)
        {  //小数点前面6位
            // [textField resignFirstResponder];
            //            [DCFStringUtil showNotice:[NSString stringWithFormat:@"只允许小数前%d位", dotPreBits]];
            return NO;
        }
   
        // 其它正常的走以下流程；
    }
    //如果之前有“.”
    else
    {
        //不是0-9－.的字符集合
        cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers]invertedSet];
        // 如果已经到了总限制 位数 ，则不允许；
        if (textField.text.length >= dotPreBits + dotAfterBits + 1)
        {
            //            [textField resignFirstResponder];
            //            [DCFStringUtil showNotice:[NSString stringWithFormat:@"只允许小数点后%d位", dotAfterBits]];
            return  NO;
        }
        // 如果又是"."，则不允许输入；
        if ([string isEqualToString:@"."])
        {
            return NO;
        }
    }
    // 先分割开来，再通过“”组合； 不懂哦
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest)
    {
        //        [textField resignFirstResponder];
        //        [DCFStringUtil showNotice:[NSString stringWithFormat:@"只允许小数点后%d位", dotAfterBits]];
        return NO;
    }
    // 如果有小数点；且位数 > 小数点位置+后面限制位数
    if (NSNotFound != nDotLoc && range.location > nDotLoc +dotAfterBits)
    {  //小数点后面两位
        //        [textField resignFirstResponder];
        //        [DCFStringUtil showNotice:[NSString stringWithFormat:@"只允许小数点后%d位", dotAfterBits]];
        return NO;
    }
    return YES;
}


+ (BOOL)xm_limitRemainText:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
         replacementString:(NSString *)string
                 maxLength:(NSInteger)maxLength
             remainTextNum:(nullable void(^)(NSInteger remainLength))remainTextBlock
{
    //如果是删除键,删除range的长度；即使选中1个以上字符删除，length也会增加；
    if ([string length] == 0 && range.length > 0)
    {
        if ([textField markedTextRange] && textField.text.length ==maxLength)
        {
            [textField replaceRange:textField.markedTextRange withText:@""];
            textField.text = textField.text;
            NSInteger remainLength = maxLength-textField.text.length;
            //            self.reminderLab.text = [NSString stringWithFormat:@"还可以输入:%lu字符",remian];
            remainTextBlock(remainLength);
            return NO;
        }
        else
        {
            NSInteger remainLength = maxLength-textField.text.length+range.length;
            remainTextBlock(remainLength);
            //            self.reminderLab.text = [NSString stringWithFormat:@"还可以输入:%lu字符",(maxLength-textField.text.length+range.length)];
        }
        return YES;
    }
    NSString *genString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    UITextRange *markedRange = [textField markedTextRange];
    
    if (genString.length >maxLength)
    {
        //没有选中文本标志
        if (!markedRange)
        {
            NSLog(@"没有正在输入的");
            //截取冥想词
            NSRange range2 = [genString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            textField.text = [genString substringToIndex:range2.location];
            NSInteger remainLength = maxLength-textField.text.length;
            remainTextBlock(remainLength);
            //            self.reminderLab.text = [NSString stringWithFormat:@"还可以输入:%lu字符",(maxLength-textField.text.length)];
        }
        else
        {
            NSLog(@"正在输入中文");
            NSRange range2 = [genString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            NSInteger remainLength = maxLength-range2.location;
            remainTextBlock(remainLength);
            //            self.reminderLab.text = [NSString stringWithFormat:@"还可以输入:%lu字符",(maxLength-range2.location)];
        }
        return NO;
    }
    else
    {
        NSInteger remainLength =maxLength-genString.length;
        remainTextBlock(remainLength);
        //        self.reminderLab.text = [NSString stringWithFormat:@"还可以输入:%lu字符",(maxLength-genString.length)];
    }
    
    return YES;
    
}





/** //有问题:出来的时候,慢一点; 不能同步
 *	@brief	自定义数字键盘,在数字键盘添加完成按钮; 先遍历windows获取键盘所在的window,然后在windows遍历view获得view(UIInputSetContainerView,frame是整个windows大小)
 */

- (void)xm_keyboardToAddFinishButton
{
    // create custom button
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //最好用2张图片替换/不然有点不混合;
    [doneButton setTitle:NSLocalizedString(@"完成", nil)  forState:UIControlStateNormal];
    [doneButton setTintColor:[UIColor blackColor]];
    
    [doneButton addTarget:self action:@selector(finishSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    __block UIWindow* keyboardWindow = nil;
    NSArray* windows = [[UIApplication sharedApplication] windows];
    [windows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *str =  [[obj class] description];
        if ([str isEqualToString:@"UIRemoteKeyboardWindow"])
        {
            keyboardWindow = (UIWindow *)obj;
        }
    }];
    
    
    [[keyboardWindow subviews] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *str =  [[obj class] description];
        if ([str isEqualToString:@"UIInputSetContainerView"]||[str isEqualToString:@"UIPeripheralHostView"])
        {
            UIView* containerView = (UIView *)obj;
            [containerView addSubview:doneButton];
            
            [UIView animateKeyframesWithDuration:0.2f delay:0.f options:UIViewKeyframeAnimationOptionLayoutSubviews  animations:^{
                if (__IPHONE_8_0)
                {
                    doneButton.frame = CGRectMake(0, CGRectGetMaxY(containerView.frame)-53, 106, 53);
                }
                else
                {
                    doneButton.frame = CGRectMake(0, 163, 106, 53);
                }
                
                
            } completion:nil];
            
            
        }
    }];
    
}


- (void)finishSelectedAction:(UIButton *)sender
{
    [sender removeFromSuperview];
    [self resignFirstResponder];
}



+ (nullable NSString *)zh_TextFieldPassword:(NSString *)str
{
    NSString *password = [NSString zhFilterInputTextWithWittespaceAndLine:str];
    NSString *reTitle = nil;
    if (password.length==0)
    {
        reTitle= NSLocalizedString(@"密码不能为空", nil) ;
    }
    else if (password.length<4 ||password.length>12)
    {
        reTitle= NSLocalizedString(@"请填写有效的密码长度", nil);
    }
    else if (![UITextField xm_validatePassword:password])
    {
        reTitle= NSLocalizedString(@"请使用数字或字母的密码", nil);
    }
    //    else if ([NSString zhuIsScanInt:password])
    //    {
    //        reTitle= NSLocalizedString(@"您的密码过于简单，请使用数字+字母的组合", nil);
    //    }
    return reTitle;
    
}


@end

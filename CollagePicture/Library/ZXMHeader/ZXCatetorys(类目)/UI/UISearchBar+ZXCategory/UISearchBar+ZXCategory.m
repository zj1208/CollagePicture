//
//  UISearchBar+ZXCategory.m
//  MobileCaiLocal
//
//  Created by simon on 2019/11/12.
//  Copyright © 2019 com.Chs. All rights reserved.
//

#import "UISearchBar+ZXCategory.h"



@implementation UISearchBar (ZXCategory)

- (UITextField *)zx_searchTextField
{
    if (@available(iOS 13.0, *)) {
       return self.searchTextField;
    }
    return [self valueForKey:@"searchField"];
}

- (UIButton *)zx_cancleButton
{
    return [self valueForKey:@"cancelButton"];
}

@end

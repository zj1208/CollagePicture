//
//  ZXTransitionAlphaDelegate.h
//  lovebaby
//
//  Created by simon on 16/6/28.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZXTransitionAlphaDelegate : NSObject

@end


/*
#import "ZXTransitionAlphaDelegate.h"

@property (nonatomic,strong)ZXTransitionAlphaDelegate *transitionDelegate;


- (void)viewDidLoad {
    
    self.transitionDelegate = [[ZXTransitionAlphaDelegate alloc] init];
}

//在请求完主页数据后，弹出新功能引导
- (void)headerRefresh
{
    WS(weakSelf);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [[[AppAPIHelper shareInstance] getThemeModelAPI]getThemeHomeListWithPageNo:1 pageSize:@(10) success:^(id data) {
            
            //弹出引导
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                
                [weakSelf lauchFirstNewFunction];
                
            });
            
        } failure:^(NSError *error) {
        
        }];
        
    }];
}


#pragma mark FirstNewFunction

- (void)lauchFirstNewFunction
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"kNewFunctionGuide"])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:sb_FirstStoryboard bundle:nil];
        NewFunctionController *vc = [sb instantiateViewControllerWithIdentifier:SBID_NewFunctionController];
        vc.delegate = self;
        
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.transitioningDelegate = self.transitionDelegate;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

 
#pragma mark-FirstNewFunctionDelegate
//新功能引导页面的业务按钮 事件
 
- (void)zxNewFuntionGuideControllerAction
{
    if (self.dataMArray.count==0)
    {
        return;
    }
    [self.ZXImagePickerVCManager zxPresentActionSheetToMoreUIImagePickerController:self];
    ThemeListModel *model = [self.dataMArray objectAtIndex:0];
    self.ZXImagePickerVCManager.type =UploadOperationType_SystemTheme;
    self.ZXImagePickerVCManager.subjectId = model.themeId;
    
}

*/

//
//  StoryboardHeader.h
//  douniwan
//
//  Created by simon on 15/6/8.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#ifndef douniwan_StoryboardHeader_h
#define douniwan_StoryboardHeader_h

/*
  @brief  Main Storyboard Name
 */
static NSString *const storyboard_Set  = @"Set";
static NSString *const storyboard_Login  = @"Login";

/*
 @brief Storyboard Segue
 */

static NSString *segue_ShareController = @"segue_shareController";
// 版权信息
static NSString *segue_copyrightController  =@"segue_copyrightController";
//隐私权政策
static NSString *segue_PrivacyListController = @"segue_PrivacyListController";

//第三方绑定
static NSString *segue_ThirdBindingSegue = @"ThirdBindingSegue";
/**
 * brief Storyboard ID
 **/


#pragma mark - 设置

static NSString *SBID_SetControllerID = @"SetViewControllerID";
//照片制作首页

static NSString *SBID_MyCenterControllerNavID = @"MyCenterControllerNavID";

static NSString *SBID_TemplateListController = @"TemplateListControllerID";


////编辑主题
//static NSString *SBID_EditThemeController = @"EditThemeControllerID";
////新建主题
//static NSString *SBID_CreatThemeController = @"CreatThemeControllerID";
//
////管理照片
//static NSString *SBID_ManagerPhotoesController = @"ManagerPhotoesController";
//
////主题详情
//static NSString *SBID_ThemeDetialController = @"ThemeDetialControllerID";
//
////新功能引导
//static NSString *SBID_NewFunctionController = @"NewFunctionController";


static NSString *SBID_MakingPhotoController = @"MakingPhotoControllerSBID";
#endif

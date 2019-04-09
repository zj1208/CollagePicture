//
//  AppHeader.h
//  douniwan
//
//  Created by simon on 15/6/17.
//  Copyright (c) 2015年 simon. All rights reserved.
//
//通知的宏定义
#ifndef NOTIFICATIONMARCO_H
#define NOTIFICATIONMARCO_H

#pragma mark - 接生意

// 已经接了生意；同时更新生意列表页和生意详情页；
static NSString *const Noti_Trade_haveReceivedTrade =@"Noti_Trade_haveReceivedTrade";

// 接生意的时候，返回已经被卖完了,或重复接单；更新生意列表 或 生意列表和生意详情页；
static NSString *const Noti_Trade_subjectCompleted =@"Noti_Trade_subjectCompleted";

// 推送过来新的生意
static NSString *const Noti_Trade_Push_NewTrades =@"Noti_Trade_Push_NewTrades";

// 生意评价完成；更新我的生意列表
static NSString *const Noti_Trade_evaluating = @"Noti_Trade_evaluating";






#pragma mark- 商铺商品


//产品管理－转为公开-刷新公开  （1.ProductManageController容器视图收到更新《公开上架》总数; 2.SellingProductController收到下拉刷新数据）
static NSString *const Noti_ProductManager_updatePublic =@"updatePublic";
//产品管理－转为私密-刷新私密  （1.ProductManageController容器视图收到更新《私密产品》总数; 2.PrivacyProductsController收到下拉刷新数据）
static NSString *const Noti_ProductManager_updatePrivacy =  @"updatePrivacy";
//产品管理－下架产品-刷新下架列表 （1.ProductManageController容器视图收到更新《下架中》总数; 2.SoldOutProductController收到下拉刷新数据）
static NSString *const Noti_ProductManager_updateSoldouting =  @"updateSoldouting ";

//产品管理－转为私密-刷新私密
static NSString *const Noti_ShopCateProducts_update =  @"ShopCateProductsUpdate";

//产品管理－选中索引变换-编辑完后要返回产品管理页面 指定私密 还是公开，并且刷新数据
static NSString *const Noti_ProductManager_selectIndexUpdate = @"ProductManager_selectIndexUpdate";
//返回产品管理界面更新界面数据－编辑产品属性成功，包括删除
static NSString *const Noti_ProductManager_Edit_goBackUpdate = @"ProductManager_goBackUpdate";


//接收到粉丝／访客推送的时候，改变在当前页面的时候，粉丝，访客数量
static NSString *const Noti_Shop_ReceiveNewFansOrVisitors = @"Noti_Shop_NewFansOrVisitors";
//new的订单
static NSString *const Noti_Shop_ReceiveNewOrder = @"Noti_Shop_receiveNewOrder";


static NSString *const Noti_update_FansController= @"Noti_update_FansController";
static NSString *const Noti_update_VisitorViewController = @"Noti_update_VisitorViewController";

static NSString *const Noti_PostDataToHost = @"Noti_PostDataToHost";

//收到通知跳转处理时移除功能引导页
static NSString *const Noti_RemoveView_GuideController =@"Noti_RemoveView_GuideController";

//重新获取NIM账号
static NSString *const Noti_tryAgainGetNimAccout = @"tryAgainGetNimAccout";



//商户端经侦服务更新数据
static NSString *const Noti_update_WYServiceViewController =@"Noti_update_WYServiceViewController";

//立即提现选择银行卡更新数据
static NSString *const Noti_update_WYImmediateWithdrawalViewController =@"Noti_update_WYImmediateWithdrawalViewController";

//支付结果回调
static NSString *const Noti_PaymentResult_WYChoosePayWayViewController =@"Noti_PaymentResult_WYChoosePayWayViewController";


//发货成功之后返回上一页刷新
static NSString *const Noti_Order_update_SendGoodsSuccess =@"Noti_Order_update_SendGoodsSuccess";

//确认订单之后刷新上一页数据
static NSString *const Noti_Order_update_ModifyOrderPriceSuccess =@"Noti_Order_update_ModifyOrderPriceSuccess";

//操作之后 刷新订单列表/订单详情数据
static NSString *const Noti_Order_update_OrderListAndDetail =@"Noti_Order_update_OrderListAndDetail";


//刷新商铺tabBarItem的图标
static NSString *const Noti_TabBarItem_ShopIcon_Red =@"Noti_TabBarItem_ShopIcon_Red";
static NSString *const Noti_TabBarItem_ShopIcon_None =@"Noti_TabBarItem_ShopIcon_None";

//消息未读数
static NSString *const Noti_TabBarItem_Message_unreadCount =@"Noti_TabBarItem_Message_unreadCount";

//消息内部弹出（采购端／商户端）
static NSString *const Noti_Push_Message =@"Noti_Push_Message";

//采购端tabBar点击
static NSString *const Noti_update_WYPurchaserMainViewController =@"Noti_update_WYPurchaserMainViewController";

//采购端tabbar 关注点击刷新
static NSString *const Noti_update_WYAttentionViewController =@"Noti_update_WYAttentionViewController";

//开单预览更新pdf
static NSString *const Noti_updatePDF_WYMakeBillPreviewViewController =@"Noti_updatePDF_WYMakeBillPreviewViewController";
//开单设置修改联系信息
static NSString *const Noti_showAlert_WYMakeBillPreviewSetController =@"Noti_showAlert_WYMakeBillPreviewSetController";

//开单数据首页
static NSString *const Noti_update_SPSSStatisticsController =@"Noti_update_SPSSStatisticsController";

//开单列表
static NSString *const Noti_update_WYMakeBillHomeViewController =@"Noti_update_WYMakeBillHomeViewController";

//我的客户-客户新增、删除客户通知刷新采购商信息状态
static NSString *const Noti_update_BuyerInfoController =@"Noti_update_BuyerInfoController";
//我的客户-查看客户详情-采购商信息删除客户后返回时跳过查看客户详情
static NSString *const Noti_remove_LookMyCustomerController =@"Noti_remove_LookMyCustomerController";

#endif

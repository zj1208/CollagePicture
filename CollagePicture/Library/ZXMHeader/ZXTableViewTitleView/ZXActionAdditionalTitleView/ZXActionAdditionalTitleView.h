//
//  ZXActionAdditionalTitleView.h
//  YiShangbao
//
//  Created by simon on 2017/10/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：左侧：图标+标题文字，右侧：副标题； Accessory：图标，可设置不显示或显示，（可空）点击整个view响应事件；  底部有线条可设置及隐藏；
//
//  2018.01.10
//  扩展ZXActionAdditionalViewAccessoryType；
//  2018.03.20
//  增加底部线条，修改辅助图标不显示的bug；

#import <UIKit/UIKit.h>

static NSString *const nibName_ZXActionAdditionalTitleView = @"ZXActionAdditionalTitleView";

typedef NS_ENUM(NSInteger, ZXActionAdditionalViewAccessoryType)
{
    // Accessory没有图标
    ZXActionViewAccessoryTypeNone = 0,
    
    // Accessory指示imageView图标
    ZXActionViewAccessoryTypeDisclosureIndicator = 1,

};

@interface ZXActionAdditionalTitleView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *leftIconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *detailTitleLab;

@property (nonatomic) ZXActionAdditionalViewAccessoryType    accessoryType;

@property (weak, nonatomic) IBOutlet UIImageView *accessoryImageView;

@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;


// 底部线条,默认隐藏
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

+ (id)viewFromNib;

@end

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section ==section_recentlyPushTrande)
    {
        if (self.purchaserModel.lastBizs.count>0)
        {
            ZXActionAdditionalTitleView *titleView = [ZXActionAdditionalTitleView viewFromNib];
            titleView.titleLab.text =[NSString stringWithFormat:@"最近发布的生意(%@)",self.purchaserModel.totalNiches];
            titleView.accessoryImageView.image = [UIImage imageNamed:@"pic-jiantou"];
            titleView.detailTitleLab.text = @"查看全部";
            [titleView.tapGestureRecognizer addTarget:self action:@selector(goTradeListAction:)];
            titleView.bottomLine.hidden = NO;
            return titleView;
        }
    }
  return [[UIView alloc] init];

}
*/

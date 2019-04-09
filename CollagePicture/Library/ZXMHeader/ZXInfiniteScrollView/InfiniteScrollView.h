//
//  InfiniteScrollView.h
//  baohuai_iPhone
//
//  Created by simon on 14/5/2.
//  Copyright (c) 2014年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSTimer+Addition.h"
#import "ZXADBannerModel.h"


@class InfiniteScrollView;
@protocol InfiniteScrollViewDelegate <NSObject>

@optional

-(void)infiniteScrollView:(InfiniteScrollView *)infiniteView didSelectRowAtIndex:(NSInteger)index;

- (void)infiniteScrollView:(InfiniteScrollView *)infiniteView didSelectModel:(ZXADBannerModel *)data;

@end



NS_CLASS_AVAILABLE_IOS(3_0) @interface InfiniteScrollView : UIView


@property(nonatomic, strong) NSTimer *timer;


@property(nonatomic, weak) id<InfiniteScrollViewDelegate>delegate;

/**
 设置model型数据源

 @param array model数组
 @param placeholderImage 占位图
 */
- (void)setItemsArray:(NSMutableArray *)array placeholderImage:(UIImage *)placeholderImage;


/**
 设置网络图片数据源

 @param array 网络图片数组
 @param placeholderImage 占位图
 */
//- (void)setImageURLStrings:(NSMutableArray *)array placeholderImage:(UIImage *)placeholderImage;


- (void)reloadData;

- (void)addTestData;//add test  Data  if not data
@end



//*****************例1*********************/

//cell
/*
#import "BaseCollectionViewCell.h"
#import "InfiniteScrollView.h"

@interface InfiniteCollectionCell : BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet InfiniteScrollView *infiniteView;
@end


#import "InfiniteCollectionCell.h"

@implementation InfiniteCollectionCell



- (void)setData:(id)data
{
    [_infiniteView setItemsArray:data placeholderImage:[UIImage imageNamed:@"yicaibao.jpg"]];
    [_infiniteView reloadData];
    
}
@end
*/


//controller 控制器 －数据源，实现点击代理

/*
- (void)requestAdv
{
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@1001 success:^(id data) {
        
        AdvModel *model = (AdvModel *)data;
        [_infiniteDataMArray removeAllObjects];
        [model.advArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            advArrModel *advItemModel = (advArrModel *)obj;
            NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w828_hX relativeToImgPath:advItemModel.pic];
            ZXADBannerModel *advModel = [[ZXADBannerModel alloc] initWithDesc:nil picString:picUrl.absoluteString url:advItemModel.url advId:nil];
            
            [_infiniteDataMArray addObject:adBanner];
            [_collectionView reloadData];
        }];
        
    } failure:^(NSError *error) {
        
    }];
    
}

 
 - (void)viewDidDisappear:(BOOL)animated
 {
    [super viewDidDisappear:animated];
    [self.infiniteView.timer pauseTimer];
 }
 - (void)viewDidAppear:(BOOL)animated
 {
    [super viewDidAppear:animated];
    [self.infiniteView.timer resumeTimer];
 }


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    InfiniteCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"infiniteScrollView" forIndexPath:indexPath];
    self.infiniteView = cell.infiniteView;
    if (self.infiniteDataMArray.count>0)
    {
        [cell setData:self.infiniteDataMArray];
    }
    cell.infiniteView.delegate =self;
    return cell;
}
  
- (void)infiniteScrollView:(InfiniteScrollView *)infiniteView didSelectModel:(ZXADBannerModel *)data
{
    ZXADBannerModel *model = (ZXADBannerModel *)data;
    
    [[WYUtility dataUtil] routerWithName:model.url withSoureController:self];
}
*/




//*****************例2*********************/

/* 
// banner-infinite无缝链接轮播
self.infiniteScrollView.delegate = self;
self.infiniteScrollView.frame = ZX_FRAME_H(self.infiniteScrollView, 125*LCDW/320);
[self requestData];



- (void)requestData
{
    __weak FindHomeController*  SELF = self;
    [[[AppAPIHelper shared]getFindHttpAPI]getBanner_completionBlockWithScuccess:^(id data) {
        
        _infiniteScrollView.itmesArray = data;
        [_infiniteScrollView reloadData];
        
        if (SELF.refreshControl.refreshing)
        {
            [SELF.refreshControl endRefreshing];
        }
        
    } failure:^(NSError *error) {
        [SELF zhuHUD_showModelHUDWithModeText:[error localizedDescription]];
        if (SELF.refreshControl.refreshing)
        {
            [SELF.refreshControl endRefreshing];
        }
    }];
}
 
 

- (IBAction)refresh:(UIRefreshControl *)sender {
    
    [self.infiniteScrollView.itmesArray removeAllObjects];
    [self requestData];
}
 
 */

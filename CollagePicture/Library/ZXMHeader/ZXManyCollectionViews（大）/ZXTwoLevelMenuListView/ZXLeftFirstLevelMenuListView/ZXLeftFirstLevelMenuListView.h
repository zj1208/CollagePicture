//
//  ZXLeftFirstLevelMenuListView.h
//  MobileCaiLocal
//
//  Created by simon on 2019/11/27.
//  Copyright © 2019 timtian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXLeftFirstLevelMenuListView;
@protocol ZXLeftFirstLevelMenuListViewDataSource <NSObject>

@required
- (nullable NSString *)zx_leftFirstLevelMenuListView:(ZXLeftFirstLevelMenuListView *)leftMenuListView titleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (NSInteger)zx_leftFirstLevelMenuListView:(ZXLeftFirstLevelMenuListView *)leftMenuListView numberOfRowsInSection:(NSInteger)section;
@end

@protocol ZXLeftFirstLevelMenuListViewDelegate <NSObject>

@optional
- (void)zx_leftFirstLevelMenuListView:(ZXLeftFirstLevelMenuListView *)leftMenuListView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface ZXLeftFirstLevelMenuListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) id<ZXLeftFirstLevelMenuListViewDataSource>dataSource;

@property (nonatomic, weak) id<ZXLeftFirstLevelMenuListViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END

//
//  HLChooseScrollView.h
//  HappyLottery
//
//  Created by 蔡叶超 on 6/27/17.
//  Copyright © 2017 cyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLChooseScrollView;


@protocol HLChooseScrollViewDelegate <NSObject>
- (void)chooseScrollView:(HLChooseScrollView *)view DidSelected:(NSInteger)index;
@end

@protocol HLChooseScrollViewDataSource <NSObject>
- (NSArray <NSString *> *)categoryArr;
@end

@interface HLChooseScrollView : UIView

@property (nonatomic, assign) NSInteger selecetedIndex;

@property (nonatomic, weak) id <HLChooseScrollViewDelegate> delegate;
@property (nonatomic, weak) id <HLChooseScrollViewDataSource> dataSource;
@end

//
//  HLHomePageADHeaderView.m
//  HappyLottery
//
//  Created by 蔡叶超 on 6/27/17.
//  Copyright © 2017 cyc. All rights reserved.
//

#import "HLHomePageADHeaderView.h"


@interface HLHomePageADHeaderView () <UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation HLHomePageADHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.pagingEnabled = TRUE;
        self.scrollView.showsHorizontalScrollIndicator = FALSE;
        self.scrollView.showsVerticalScrollIndicator = FALSE;
        [self addSubview:self.scrollView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(frame.origin.x / 2.0 - 20, frame.origin.y - 10, 40, 20)];
        [self addSubview:self.pageControl];
        
    }
    return  self;
}


- (void)setAdLinks:(NSArray<NSString *> *)imageURLs {
    
    self.pageControl.numberOfPages = imageURLs.count;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.mj_w * imageURLs.count, self.scrollView.mj_h);
    for (int i = 0; i < imageURLs.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( self.scrollView.mj_w * i, 0, self.scrollView.mj_w, self.scrollView.mj_h)];
        
        imageView.image =  [UIImage imageNamed:imageURLs[i]];
        [self.scrollView addSubview:imageView];
    }
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.mj_w;
}

@end

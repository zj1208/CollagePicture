//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

static const CGFloat EGOHeaderViewHight =  60.f;
#define EGOContentInsetTop  EGOHeaderViewHight+scrollView.contentInset.top
#define EGOContentOffest -EGOHeaderViewHight-scrollView.contentInset.top



@interface EGORefreshTableHeaderView ()

@property(nonatomic,assign)EGOPullRefreshState  state;
@property(nonatomic,strong)UILabel *lastUpdatedLabel;
@property(nonatomic,strong)UILabel *statusLabel;
@property(nonatomic,strong)CALayer *arrowImage;
@property(nonatomic,strong)UIActivityIndicatorView *activityView;



- (void)setState:(EGOPullRefreshState)aState;


@end

@implementation EGORefreshTableHeaderView
@synthesize state = _state;
@synthesize arrowImage = _arrowImage;
@synthesize lastUpdatedLabel = _lastUpdatedLabel;
@synthesize statusLabel = _statusLabel;
@synthesize activityView = _activityView;
@synthesize delegate = _delegate;
@synthesize reloading = _reloading;


- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame arrowImageName:@"blueArrow" textColor:TEXT_COLOR];
}

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor
{
    if((self = [super initWithFrame:frame]))
    {
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = self.superview.backgroundColor;

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = textColor?textColor:TEXT_COLOR;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		self.lastUpdatedLabel=label;
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
        label.textColor = textColor?textColor:TEXT_COLOR;
        label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		self.statusLabel=label;
		
		CALayer *layer = [CALayer layer];
		layer.contentsGravity = kCAGravityResizeAspect;
        UIImage *img = [UIImage imageNamed:arrow];
        layer.contents = (id)img.CGImage;
        [[self layer] addSublayer:layer];
		self.arrowImage=layer;
        self.arrowImage.frame =CGRectMake(25.0f, 10, img.size.width/2, img.size.height/2);

		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:view];
		self.activityView = view;
		
		[self setState:EGOOPullRefreshNormal];
    }
    return self;
	
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (CGRectEqualToRect(self.frame, CGRectZero))
    {
        
    }
    self.frame = CGRectMake(0, -EGOHeaderViewHight,[[UIScreen mainScreen]bounds].size.width, EGOHeaderViewHight);
    self.lastUpdatedLabel.frame = CGRectMake(0.0f, self.frame.size.height - 30.0f, self.frame.size.width, 20.0f);
    self.statusLabel.frame = CGRectOffset(self.lastUpdatedLabel.frame, 0, -(CGRectGetHeight(self.lastUpdatedLabel.frame)));
    CGRect arrowRect = self.arrowImage.frame;
    arrowRect.origin = CGPointMake(35*self.frame.size.width/320, 15);
    self.arrowImage.frame = arrowRect;

    self.activityView.frame = self.arrowImage.frame;

}
#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate
{
    NSDate *date = [NSDate date];
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
// [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdatedDateFormatter:)])
    {
        NSString *dateFor = [self.delegate egoRefreshTableHeaderDataSourceLastUpdatedDateFormatter:self];
        [dateFormatter setDateFormat:dateFor];
    }
    self.lastUpdatedLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"最后更新于", @"Last Updated"),  [dateFormatter stringFromDate:date]];
    
//        便于进一步使用本地数据相关的
        [[NSUserDefaults standardUserDefaults] setObject:self.lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}



- (void)setState:(EGOPullRefreshState)aState
{
	switch (aState)
    {
		case EGOOPullRefreshPulling:
			
			self.statusLabel.text = NSLocalizedString(@"释放就刷新...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			self.arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (self.state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				self.arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			self.statusLabel.text = NSLocalizedString(@"下拉就刷新...", @"Pull down to refresh status");
			[self.activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			self.arrowImage.hidden = NO;
			self.arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			
			self.statusLabel.text = NSLocalizedString(@"加载中...", @"Loading Status");
			[self.activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			self.arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
	
    if (scrollView.isDragging &&self.state != EGOOPullRefreshLoading)
    {
		BOOL _loading = NO;
		if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)])
        {
			_loading = [self.delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
        else
        {
            _loading = self.reloading;

        }
		
		if (self.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > EGOContentOffest && scrollView.contentOffset.y < 0.0f && !_loading)
        {
			[self setState:EGOOPullRefreshNormal];
		}
        else if (self.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < EGOContentOffest && !_loading)
        {
			[self setState:EGOOPullRefreshPulling];
		}
		
//		if (scrollView.contentInset.top != 0)
//        {
//			scrollView.contentInset = UIEdgeInsetsMake(0.0f+scrollView.contentInset.top, 0.0f, 0.0f+scrollView.contentInset.bottom, 0.0f);
//		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
//  if loading  no action
	if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)])
    {
		_loading = [self.delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
    else
    {
        _loading = self.reloading;

    }
//	if  no  loading, set EGOOPullRefreshLoading State，还要让60区域这部分变为滚动整体区域。使得不会自动上移，也不受人为滚动，还是会让这部分处于最上部分；
	if (scrollView.contentOffset.y <= EGOContentOffest && !_loading)
    {
		
		if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)])
        {
            self.reloading = YES;
			[self.delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
        
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(EGOContentInsetTop, 0.0f, 0.0f+scrollView.contentInset.bottom, 0.0f);
		[UIView commitAnimations];
		
	}
}




- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    Class class = NSClassFromString(@"LoadMoreTableFooterView");
    if (class)
    {
        Ivar ivar = class_getInstanceVariable(class, "reloading");
        id variable = object_getIvar([class alloc], ivar);
        if (variable)
        {
            return;
        }
    }
    
    if (self.reloading)
    {
        [UIView animateWithDuration:0.7 animations:^{
            UIEdgeInsets contentInset = scrollView.contentInset;
            contentInset.top = contentInset.top-EGOHeaderViewHight;
            [scrollView setContentInset:contentInset];
            
        } completion:nil];
        [self setState:EGOOPullRefreshNormal];
    }
    
    if ([scrollView isKindOfClass:[UITableView class]] )
    {
        UITableView *tableView = (UITableView *)scrollView;
        [tableView reloadData];
    }
    if ([scrollView isKindOfClass:[UICollectionView class]])
    {
        UICollectionView *collectionView = (UICollectionView *)scrollView;
        [collectionView reloadData];
    }
    self.reloading = NO;

}

#pragma mark - Manually refresh view update
- (void)egoRefreshScrollViewDataSourceStartManualLoading:(UIScrollView *)scrollView {
    [self setState:EGOOPullRefreshLoading];
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.contentOffset = CGPointMake(0, EGOContentOffest);
        scrollView.contentInset = UIEdgeInsetsMake(EGOContentInsetTop, 0.0f, 0.0f+scrollView.contentInset.bottom, 0.0f);

    } completion:^(BOOL finished) {
        
//        在监听到通知，如退出，登录的时候刷新。这个finished不会变为YES；是个bug；
//        if (finished)
//        {
            if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)])
            {
                [self.delegate egoRefreshTableHeaderDidTriggerRefresh:self];
                self.reloading = YES;
            }

//        }

    }];    
}

@end

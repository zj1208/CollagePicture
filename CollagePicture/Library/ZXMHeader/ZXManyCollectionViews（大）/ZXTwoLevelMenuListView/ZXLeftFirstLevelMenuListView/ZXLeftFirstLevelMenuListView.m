//
//  ZXLeftFirstLevelMenuListView.m
//  MobileCaiLocal
//
//  Created by simon on 2019/11/27.
//  Copyright © 2019 timtian. All rights reserved.
//

#import "ZXLeftFirstLevelMenuListView.h"
#import "ZXLeftFirstLevelTableCell.h"
@implementation ZXLeftFirstLevelMenuListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initUI];
    }
    return self;
}


- (void)initUI
{
    [self addSubview:self.tableView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:247/255.0 alpha:1.0];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXLeftFirstLevelTableCell class]) bundle:nil] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ZXLeftFirstLevelTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if ([self.dataSource respondsToSelector:@selector(zx_leftFirstLevelMenuListView:titleForRowAtIndexPath:)]) {
       NSString *title = [self.dataSource zx_leftFirstLevelMenuListView:self titleForRowAtIndexPath:indexPath];
        cell.titleLabel.text =title;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.dataSource respondsToSelector:@selector(zx_leftFirstLevelMenuListView:numberOfRowsInSection:)]) {
        return [self.dataSource zx_leftFirstLevelMenuListView:self numberOfRowsInSection:section];
    }
    return  0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (50*[[UIScreen mainScreen] bounds].size.width)/375;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(zx_leftFirstLevelMenuListView:didSelectItemAtIndexPath:)])
    {
        [self.delegate zx_leftFirstLevelMenuListView:self didSelectItemAtIndexPath:indexPath];
    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

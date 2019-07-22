//
//  ZXAlbumTableCell.m
//  FunLive
//
//  Created by simon on 2019/4/23.
//  Copyright © 2019 facebook. All rights reserved.
//

#import "ZXAlbumTableCell.h"
#import "ZXAssetModel.h"

@interface ZXAlbumTableCell ()

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZXAlbumTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self)
    {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    [self.contentView addSubview:self.posterImageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self addConstraintWithItem:self.posterImageView];
    
    [self addTitleLabelConstraintWithItem:self.titleLabel];
    self.titleLabel.text = @"jldjlsjfljdsf";
}



#pragma mark - 约束
- (void)addConstraintWithItem:(UIView *)item
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0)
    {
        UILayoutGuide *layoutGuide_superView = self.contentView.layoutMarginsGuide;
        NSLayoutConstraint *constraint_top = [item.topAnchor constraintEqualToAnchor:layoutGuide_superView.topAnchor constant:0];
        NSLayoutConstraint *constraint_bottom = [item.bottomAnchor constraintEqualToAnchor:layoutGuide_superView.bottomAnchor constant:0];
        NSLayoutConstraint *constraint_leading = [item.leadingAnchor constraintEqualToAnchor:layoutGuide_superView.leadingAnchor constant:-8];
        NSLayoutConstraint *constraint_width = [item.widthAnchor constraintEqualToAnchor:item.heightAnchor];
        [NSLayoutConstraint activateConstraints:@[constraint_top,constraint_bottom,constraint_leading,constraint_width]];
    }
    else
    {
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        constraint1.active = YES;
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        constraint2.active = YES;
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        constraint3.active = YES;
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:item attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        constraint4.active = YES;
    }
}

- (void)addTitleLabelConstraintWithItem:(UIView *)item
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0)
    {
        NSLayoutConstraint *constraint_centerY = [item.centerYAnchor constraintEqualToAnchor:item.superview.centerYAnchor];
        NSLayoutConstraint *constraint_leading = [item.leadingAnchor constraintEqualToAnchor:self.posterImageView.trailingAnchor constant:10];
        NSLayoutConstraint *constraint_trailing = [item.trailingAnchor constraintGreaterThanOrEqualToAnchor:item.superview.trailingAnchor constant:-50];
            NSLayoutConstraint *constraint_width = [item.widthAnchor constraintGreaterThanOrEqualToConstant:50];
        [NSLayoutConstraint activateConstraints:@[constraint_centerY,constraint_trailing,constraint_leading,constraint_width]];
    }
    else
    {
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        constraint1.active = YES;
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.posterImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:10];
        constraint2.active = YES;
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:item.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-50];
        constraint3.active = YES;
        
        [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50].active = YES;
    }
}


#pragma mark - Lazy load

- (UIImageView *)posterImageView {
    if (_posterImageView == nil) {
        UIImageView *posterImageView = [[UIImageView alloc] init];
        posterImageView.contentMode = UIViewContentModeScaleAspectFill;
//        posterImageView.backgroundColor = [UIColor lightGrayColor];
        posterImageView.clipsToBounds = YES;
        _posterImageView = posterImageView;
    }
    return _posterImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textColor = [UIColor blackColor];
//        titleLabel.backgroundColor = [UIColor lightGrayColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}


- (void)setAlbumModel:(ZXAlbumModel *)albumModel
{
    
    _albumModel = albumModel;
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:albumModel.title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%ld)",(long)albumModel.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [nameString appendAttributedString:countString];
    self.titleLabel.attributedText = nameString;
    
    __weak __typeof(self) weakSelf = self;
    [[ZXPHPhotoManager shareInstance]getPostImageWithAlbumModel:albumModel completion:^(UIImage * _Nonnull image) {
       
        weakSelf.posterImageView.image = image;
    }];
    
}
@end

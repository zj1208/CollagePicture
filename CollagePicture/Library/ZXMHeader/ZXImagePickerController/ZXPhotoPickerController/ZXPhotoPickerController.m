//
//  ZXPhotoPickerController.m
//  FunLive
//
//  Created by simon on 2019/5/8.
//  Copyright © 2019 facebook. All rights reserved.
//

#import "ZXPhotoPickerController.h"
#import "ZXPHPhotoManager.h"
#import "ZXImagePickerController.h"
#import "ZXAssetCollectionCell.h"

#import "NSBundle+ZXImagePicker.h"

#ifndef IS_IPHONE_XX
#define IS_IPHONE_XX ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) { \
    UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;\
    if (areaInset.bottom >0) { \
        tmp = 1;\
    }\
}\
else{\
    tmp = 0;\
}\
tmp;\
})
#endif

@interface ZXPhotoPickerController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionFlowLayout;

@property (nonatomic, strong) NSMutableArray *models;


@property (nonatomic, strong) UIView *bottomContainerView;
//@property (nonatomic, strong) UIToolbar *bottomContainerView;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIImageView *numberImageView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *originalPhotoButton;
@property (nonatomic, strong) UIView *divideLine;

@end

@implementation ZXPhotoPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
//    [self setData];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    ZXImagePickerController *imagePicker = (ZXImagePickerController *)self.navigationController;
    return imagePicker.stausBarStyle;
}

- (void)setUI
{
    ZXImagePickerController *imagePicker = (ZXImagePickerController *)self.navigationController;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStylePlain target:imagePicker action:@selector(cancelButtonClick)];

    self.navigationItem.title = self.model.title;
//
    [self configBottomToolBar];
    [self.view addSubview:self.collectionView];
    [self addConstraintWithCollectionView:self.collectionView];
}


#pragma mark - UICollectionView

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        flowLayout.sectionInset = self.sectionInset;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionFlowLayout = flowLayout;
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collection.alwaysBounceVertical = YES;
        collection.directionalLockEnabled = YES;
        collection.backgroundColor = [UIColor clearColor];
        collection.delegate = self;
        collection.dataSource = self;
//        collection.showsVerticalScrollIndicator = NO;
//        collection.showsHorizontalScrollIndicator = NO;
        [collection registerClass:[ZXAssetCollectionCell class] forCellWithReuseIdentifier:@"Cell"];
        _collectionView = collection;
    }
    return _collectionView;
}


- (void)configBottomToolBar {
//    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
//    if (!tzImagePickerVc.showSelectBtn) return;
    
//    self.bottomContainerView = [[UIToolbar alloc] initWithFrame:CGRectZero];
//    self.bottomContainerView.barTintColor = [UIColor redColor];
    self.bottomContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat rgb = 253 / 255.0;
    self.bottomContainerView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    [self.view addSubview:self.bottomContainerView];
    [self addConstraintWithBottomContainerView:self.bottomContainerView];
    
    _divideLine = [[UIView alloc] init];
    CGFloat rgb2 = 222 / 255.0;
    _divideLine.backgroundColor = [UIColor colorWithRed:rgb2 green:rgb2 blue:rgb2 alpha:1.0];
    [self.bottomContainerView addSubview:_divideLine];

    [self.bottomContainerView addSubview:self.previewButton];
    [self.bottomContainerView addSubview:self.doneButton];
    [self.bottomContainerView addSubview:self.numberImageView];
    [self.bottomContainerView addSubview:self.numberLabel];

//    if (tzImagePickerVc.allowPickingOriginalPhoto) {
//        _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//        [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_originalPhotoButton setTitle:tzImagePickerVc.fullImageBtnTitleStr forState:UIControlStateNormal];
//        [_originalPhotoButton setTitle:tzImagePickerVc.fullImageBtnTitleStr forState:UIControlStateSelected];
//        [_originalPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [_originalPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//        [_originalPhotoButton setImage:[UIImage imageNamedFromMyBundle:tzImagePickerVc.photoOriginDefImageName] forState:UIControlStateNormal];
//        [_originalPhotoButton setImage:[UIImage imageNamedFromMyBundle:tzImagePickerVc.photoOriginSelImageName] forState:UIControlStateSelected];
//        _originalPhotoButton.selected = _isSelectOriginalPhoto;
//        _originalPhotoButton.enabled = tzImagePickerVc.selectedModels.count > 0;
//
//        _originalPhotoLabel = [[UILabel alloc] init];
//        _originalPhotoLabel.textAlignment = NSTextAlignmentLeft;
//        _originalPhotoLabel.font = [UIFont systemFontOfSize:16];
//        _originalPhotoLabel.textColor = [UIColor blackColor];
//        if (_isSelectOriginalPhoto) [self getSelectedPhotoBytes];
//    }
    

//
//
//    [self.bottomContainerView addSubview:_originalPhotoButton];
//    [_originalPhotoButton addSubview:_originalPhotoLabel];
}

- (UIImageView *)numberImageView
{
    if (!_numberImageView)
    {
        ZXImagePickerController *imagePicker = (ZXImagePickerController *)self.navigationController;
        UIImage *image = [NSBundle zx_imageNamedFromMyBundle:imagePicker.photoNumberIconImageName];
        _numberImageView = [[UIImageView alloc] initWithImage:image];
//        _numberImageView.hidden = tzImagePickerVc.selectedModels.count <= 0;
        _numberImageView.backgroundColor = [UIColor clearColor];
        _numberImageView.backgroundColor = [UIColor redColor];


    }
    return _numberImageView;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
       
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.font = [UIFont systemFontOfSize:15];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.text = @"5";
//        numberLabel.text = [NSString stringWithFormat:@"%zd",tzImagePickerVc.selectedModels.count];
//        numberLabel.hidden = tzImagePickerVc.selectedModels.count <= 0;
        numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel = numberLabel;
    }
    return _numberLabel;
}

- (UIButton *)previewButton
{
    if (!_previewButton)
    {
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewButton addTarget:self action:@selector(previewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _previewButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_previewButton setTitle:NSLocalizedString(@"预览", nil) forState:UIControlStateNormal];
        [_previewButton setTitle:NSLocalizedString(@"预览", nil) forState:UIControlStateDisabled];
//        [_previewButton setTitle:tzImagePickerVc.previewBtnTitleStr forState:UIControlStateDisabled];
        [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
//        _previewButton.enabled = tzImagePickerVc.selectedModels.count;
    }
    return _previewButton;
}

- (UIButton *)doneButton
{
    if (!_doneButton)
    {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_doneButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [_doneButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateDisabled];
        [_doneButton setTitleColor:_doneButton.tintColor forState:UIControlStateNormal];
//        [_doneButton setTitle:tzImagePickerVc.doneBtnTitleStr forState:UIControlStateNormal];
//        [_doneButton setTitle:tzImagePickerVc.doneBtnTitleStr forState:UIControlStateDisabled];
//        [_doneButton setTitleColor:tzImagePickerVc.oKButtonTitleColorNormal forState:UIControlStateNormal];
//        [_doneButton setTitleColor:tzImagePickerVc.oKButtonTitleColorDisabled forState:UIControlStateDisabled];
//        _doneButton.enabled = tzImagePickerVc.selectedModels.count || tzImagePickerVc.alwaysEnableDoneBtn;
    }
    return _doneButton;
}

- (void)doneButtonClick:(UIButton *)sender
{
    
}

- (void)previewButtonClick:(UIButton *)sender
{
    
}

#pragma mark - 约束
- (void)addConstraintWithBottomContainerView:(UIView *)item
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *))
    {
        safeAreaInsets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
    }
    if (@available(iOS 11.0, *))         {
        UILayoutGuide *layoutGuide_superView = self.view.safeAreaLayoutGuide;
        NSLayoutConstraint *constraint_height = [item.heightAnchor constraintEqualToConstant:50+safeAreaInsets.bottom];
        NSLayoutConstraint *constraint_bottom = [item.bottomAnchor constraintEqualToAnchor:layoutGuide_superView.bottomAnchor constant:safeAreaInsets.bottom];
        NSLayoutConstraint *constraint_leading = [item.leadingAnchor constraintEqualToAnchor:layoutGuide_superView.leadingAnchor constant:0];
        NSLayoutConstraint *constraint_centerX = [item.centerXAnchor constraintEqualToAnchor:layoutGuide_superView.centerXAnchor];
        [NSLayoutConstraint activateConstraints:@[constraint_height,constraint_bottom,constraint_leading,constraint_centerX]];
    }
    else if([[UIDevice currentDevice] systemVersion].floatValue>=9.f)
    {
        UILayoutGuide *layoutGuide_superView = self.view.layoutMarginsGuide;
        NSLayoutConstraint *constraint_height = [item.heightAnchor constraintEqualToConstant:50+safeAreaInsets.bottom];
        NSLayoutConstraint *constraint_bottom = [item.bottomAnchor constraintEqualToAnchor:layoutGuide_superView.bottomAnchor constant:safeAreaInsets.bottom];
        CGFloat leading = [UIScreen mainScreen].bounds.size.width>320 ? 20 :16;
        NSLayoutConstraint *constraint_leading = [item.leadingAnchor constraintEqualToAnchor:layoutGuide_superView.leadingAnchor constant:-leading];
        //x的center
        NSLayoutConstraint *constraint_centerX = [item.centerXAnchor constraintEqualToAnchor:layoutGuide_superView.centerXAnchor];
        [NSLayoutConstraint activateConstraints:@[constraint_height,constraint_bottom,constraint_leading,constraint_centerX]];
    }
    else
    {
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50+safeAreaInsets.bottom];
        constraint1.active = YES;

        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        constraint2.active = YES;

        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        constraint3.active = YES;

        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        constraint4.active = YES;
    }
}

- (void)addConstraintWithCollectionView:(UIView *)item
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 11.0, *))         {
        UILayoutGuide *layoutGuide_superView = self.view.safeAreaLayoutGuide;
        NSLayoutConstraint *constraint_top = [item.topAnchor constraintEqualToAnchor:layoutGuide_superView.topAnchor constant:0];
        NSLayoutConstraint *constraint_bottom = [item.bottomAnchor constraintEqualToAnchor:self.bottomContainerView.topAnchor constant:0];
        NSLayoutConstraint *constraint_leading = [item.leadingAnchor constraintEqualToAnchor:layoutGuide_superView.leadingAnchor constant:0];
        NSLayoutConstraint *constraint_centerX = [item.centerXAnchor constraintEqualToAnchor:layoutGuide_superView.centerXAnchor];
        [NSLayoutConstraint activateConstraints:@[constraint_top,constraint_bottom,constraint_leading,constraint_centerX]];
    }
    else if([[UIDevice currentDevice] systemVersion].floatValue>=9.f)
    {
        UILayoutGuide *layoutGuide_superView = self.view.layoutMarginsGuide;
        NSLayoutConstraint *constraint_top = [item.topAnchor constraintEqualToAnchor:layoutGuide_superView.topAnchor constant:0];
        NSLayoutConstraint *constraint_bottom = [item.bottomAnchor constraintEqualToAnchor:self.bottomContainerView.topAnchor constant:0];
        NSLayoutConstraint *constraint_leading = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        //x的center
        NSLayoutConstraint *constraint_centerX = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [NSLayoutConstraint activateConstraints:@[constraint_top,constraint_bottom,constraint_leading,constraint_centerX]];
    }
    else
    {
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        constraint1.active = YES;

        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        constraint2.active = YES;

        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        constraint3.active = YES;

        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        constraint4.active = YES;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.divideLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.bottomContainerView.frame), 1);
    CGFloat toolBarHeight = 50;
    CGFloat buttonHeight = 44;
    CGFloat buttonEdgeTop = (50 - 44)/2;
    self.previewButton.frame = CGRectMake(10, buttonEdgeTop, 50, buttonHeight);
    self.doneButton.frame = CGRectMake(CGRectGetWidth(self.bottomContainerView.frame) - 44 - 12, buttonEdgeTop, 44, buttonHeight);
    self.numberImageView.frame = CGRectMake(CGRectGetWidth(self.bottomContainerView.frame) - 44 - 12-44, buttonEdgeTop, 44, buttonHeight);
    self.numberLabel.frame = self.numberImageView.frame;
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (_showTakePhotoBtn) {
//        TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
//        if (tzImagePickerVc.allowPickingImage && tzImagePickerVc.allowTakePicture) {
//            return _models.count + 1;
//        }
//    }
    return 40;
    return self.model.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    // the cell lead to take a picture / 去拍照的cell
//    TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)self.navigationController;
//    if (((tzImagePickerVc.sortAscendingByModificationDate && indexPath.row >= _models.count) || (!tzImagePickerVc.sortAscendingByModificationDate && indexPath.row == 0)) && _showTakePhotoBtn) {
//        TZAssetCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZAssetCameraCell" forIndexPath:indexPath];
//        cell.imageView.image = [UIImage imageNamedFromMyBundle:tzImagePickerVc.takePictureImageName];
//        return cell;
//    }
    // the cell dipaly photo or video / 展示照片或视频的cell
    ZXAssetCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
//    cell.allowPickingMultipleVideo = tzImagePickerVc.allowPickingMultipleVideo;
//    cell.photoDefImageName = tzImagePickerVc.photoDefImageName;
//    cell.photoSelImageName = tzImagePickerVc.photoSelImageName;
//    TZAssetModel *model;
//    if (tzImagePickerVc.sortAscendingByModificationDate || !_showTakePhotoBtn) {
//        model = _models[indexPath.row];
//    } else {
//        model = _models[indexPath.row - 1];
//    }
//    cell.allowPickingGif = tzImagePickerVc.allowPickingGif;
//    cell.model = model;
//    cell.showSelectBtn = tzImagePickerVc.showSelectBtn;
//    cell.allowPreview = tzImagePickerVc.allowPreview;
//
//    __weak typeof(cell) weakCell = cell;
//    __weak typeof(self) weakSelf = self;
//    __weak typeof(_numberImageView.layer) weakLayer = _numberImageView.layer;
//    cell.didSelectPhotoBlock = ^(BOOL isSelected) {
//        TZImagePickerController *tzImagePickerVc = (TZImagePickerController *)weakSelf.navigationController;
//        // 1. cancel select / 取消选择
//        if (isSelected) {
//            weakCell.selectPhotoButton.selected = NO;
//            model.isSelected = NO;
//            NSArray *selectedModels = [NSArray arrayWithArray:tzImagePickerVc.selectedModels];
//            for (TZAssetModel *model_item in selectedModels) {
//                if ([[[TZImageManager manager] getAssetIdentifier:model.asset] isEqualToString:[[TZImageManager manager] getAssetIdentifier:model_item.asset]]) {
//                    [tzImagePickerVc.selectedModels removeObject:model_item];
//                    break;
//                }
//            }
//            [weakSelf refreshBottomToolBarStatus];
//        } else {
//            // 2. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
//            if (tzImagePickerVc.selectedModels.count < tzImagePickerVc.maxImagesCount) {
//                weakCell.selectPhotoButton.selected = YES;
//                model.isSelected = YES;
//                [tzImagePickerVc.selectedModels addObject:model];
//                [weakSelf refreshBottomToolBarStatus];
//            } else {
//                NSString *title = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Select a maximum of %zd photos"], tzImagePickerVc.maxImagesCount];
//                [tzImagePickerVc showAlertWithTitle:title];
//            }
//        }
//        [UIView showOscillatoryAnimationWithLayer:weakLayer type:TZOscillatoryAnimationToSmaller];
//    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 6;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

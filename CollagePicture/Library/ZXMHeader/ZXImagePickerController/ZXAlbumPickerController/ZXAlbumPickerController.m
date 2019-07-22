//
//  ZXAlbumPickerController.m
//  FunLive
//
//  Created by simon on 2019/4/23.
//  Copyright © 2019 facebook. All rights reserved.
//

#import "ZXAlbumPickerController.h"
#import "ZXAlbumTableCell.h"

@interface ZXAlbumPickerController ()<UITableViewDataSource,UITableViewDelegate,ZXPHPhotoManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *albumMArray;

@end

@implementation ZXAlbumPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
    [self setData];
}

- (void)setUI
{
    ZXImagePickerController *imagePicker = (ZXImagePickerController *)self.navigationController;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStylePlain target:imagePicker action:@selector(cancelButtonClick)];
    
    if (imagePicker.allowPickingImage)
    {
        self.navigationItem.title = NSLocalizedString(@"照片", nil);
    }else if (imagePicker.allowPickingVideo)
    {
        self.navigationItem.title = NSLocalizedString(@"视频", nil);
    }
    
    [self.view addSubview:self.tableView];
    [self addConstraintWithItem:self.tableView];
}

- (void)setData
{
    __weak __typeof(self) weakSelf = self;
    ZXPHPhotoManager *manager = [ZXPHPhotoManager shareInstance];
    manager.delegate = self;
    [manager getAlbumCollectionListWithAllowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<ZXAlbumModel *> * _Nonnull albumModels) {
        [weakSelf.albumMArray addObjectsFromArray:albumModels];
        [weakSelf.tableView reloadData];
    }];
}

- (NSMutableArray *)albumMArray
{
    if (!_albumMArray)
    {
        _albumMArray = [NSMutableArray array];
    }
    return _albumMArray;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = 70;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[ZXAlbumTableCell class] forCellReuseIdentifier:@"TZAlbumCell"];
    }
    return _tableView;
}




#pragma mark - 约束
- (void)addConstraintWithItem:(UIView *)item
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *))
    {
        UIEdgeInsets areaInset = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if(!UIEdgeInsetsEqualToEdgeInsets(areaInset, UIEdgeInsetsZero)){
            safeAreaInsets = areaInset;
        }else{
        }
    }
    if (@available(iOS 11.0, *))         {
        UILayoutGuide *layoutGuide_superView = self.view.safeAreaLayoutGuide;
        NSLayoutConstraint *constraint_top = [item.topAnchor constraintEqualToAnchor:layoutGuide_superView.topAnchor constant:0];
        NSLayoutConstraint *constraint_bottom = [item.bottomAnchor constraintEqualToAnchor:layoutGuide_superView.bottomAnchor constant:0+safeAreaInsets.bottom];
        NSLayoutConstraint *constraint_leading = [item.leadingAnchor constraintEqualToAnchor:layoutGuide_superView.leadingAnchor constant:0];
        NSLayoutConstraint *constraint_centerX = [item.centerXAnchor constraintEqualToAnchor:layoutGuide_superView.centerXAnchor];
        [NSLayoutConstraint activateConstraints:@[constraint_top,constraint_bottom,constraint_leading,constraint_centerX]];
    }
    else if([[UIDevice currentDevice] systemVersion].floatValue>=9.f)
    {
        // Fallback on earlier versions
        UILayoutGuide *layoutGuide_superView = self.view.layoutMarginsGuide;
        NSLayoutConstraint *constraint_top = [item.topAnchor constraintEqualToAnchor:layoutGuide_superView.topAnchor constant:0];
        NSLayoutConstraint *constraint_bottom = [item.bottomAnchor constraintEqualToAnchor:layoutGuide_superView.bottomAnchor constant:0+safeAreaInsets.bottom];
        //leading 在viewController的view上用layoutMarginsGuide比较复杂，所以改为普通view约束；
        NSLayoutConstraint *constraint_leading = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        //x的center
        NSLayoutConstraint *constraint_centerX = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [NSLayoutConstraint activateConstraints:@[constraint_top,constraint_bottom,constraint_leading,constraint_centerX]];
    }
    else
    {
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        constraint1.active = YES;

        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        constraint2.active = YES;

        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        constraint3.active = YES;

        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:item.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        constraint4.active = YES;
    }
}

#pragma mark -ZXPHPhotoManagerDelegate

- (BOOL)zx_shouldContainAlbumInAlbumCollectionListWithAlbumTitle:(NSString *)albumName fetchResult:(PHFetchResult *)result
{
    if ([self.pickerDelegate respondsToSelector:@selector(zx_shouldContainAlbumInAlbumCollectionListWithAlbumTitle:fetchResult:)])
    {
        return [self.pickerDelegate zx_shouldContainAlbumInAlbumCollectionListWithAlbumTitle:albumName fetchResult:result];
    }
    if ([albumName isEqualToString:@"连拍快照"])
    {
        return NO;
    }
    return YES;
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    ZXImagePickerController *imagePicker = (ZXImagePickerController *)self.navigationController;
    return imagePicker.stausBarStyle;
}

#pragma mark - UITableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.albumMArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXAlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZAlbumCell" forIndexPath:indexPath];
//    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
//    cell.selectedCountButton.backgroundColor = imagePickerVc.oKButtonTitleColorNormal;
    cell.albumModel = [self.albumMArray objectAtIndex:indexPath.row];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    TZPhotoPickerController *photoPickerVc = [[TZPhotoPickerController alloc] init];
//    photoPickerVc.columnNumber = self.columnNumber;
//    TZAlbumModel *model = _albumArr[indexPath.row];
//    photoPickerVc.model = model;
//    [self.navigationController pushViewController:photoPickerVc animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

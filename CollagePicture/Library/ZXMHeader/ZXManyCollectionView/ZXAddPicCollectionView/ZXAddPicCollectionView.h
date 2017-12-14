//
//  ZXAddPicCollectionView.h
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  水平添加图片的组件；
//  增加自定义提示view（UIButton图 + 提示UILabel）；
//  2017.12.13

#import <UIKit/UIKit.h>
#import "ZXAddPicViewCell.h"
// 图片模型
#import "ZXPhoto.h"
#import "ZXAddPicCoverView.h"

NS_ASSUME_NONNULL_BEGIN

// 图片状态
typedef NS_ENUM(NSInteger, ZXPhotosViewState) {
    
    ZXPhotosViewStateWillCompose = 0,   // 未发布
    ZXPhotosViewStateDidCompose = 1     // 已发布
};

// 编辑方式
typedef NS_ENUM(NSInteger, ZXAddPicCellEditingStyle) {
    
    ZXAddPicCellEditingStyleNone,
    ZXAddPicCellEditingStyleDelete, // 删除
    ZXAddPicCellEditingStyleInsert  // 添加
};

static NSString * const ZXAddAssetImageName = @"zxPhoto_addAsset";
static NSString * const ZXAddPhotoImageName = @"zxPhoto_addImage";

@protocol ZXAddPicCollectionViewDelegate;


@interface ZXAddPicCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, weak) id<ZXAddPicCollectionViewDelegate>delegate;

@property (nonatomic, strong) UICollectionView *collectionView;


// 添加默认提示view
@property (nonatomic, strong) ZXAddPicCoverView *addPicCoverView;
// 是否显示默认提示view
@property (nonatomic, assign) BOOL showAddPicCoverView;

/** 所有图片的状态（默认为已发布状态） */
@property (nonatomic, assign) ZXPhotosViewState photosState;

// 可以是image数组，也可以是url地址；
@property (nonatomic, strong) NSMutableArray *dataMArray;

// 本地image数组
@property (nonatomic, strong) NSMutableArray *images;

// 设置collectionView的sectionInset
@property (nonatomic, assign) UIEdgeInsets sectionInset;

// item之间的间距,忽略删除按钮; 在做一行固定显示几个item的时候，可以用于增大间距来减小item的width；
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

// 行间距，忽略删除按钮
@property (nonatomic, assign) CGFloat minimumLineSpacing;

// 设置是否存在动态“添加图片“按钮
@property (nonatomic, getter=isExistInputItem) BOOL existInputItem;

// 设置添加按钮的图片
@property (nonatomic, strong) UIImage *addButtonPlaceholderImage;

// 最多可显示的item数量，到达这个数，就不能再加入，”添加图片“按钮也会移除
@property (nonatomic, assign) NSInteger maxItemCount;

// 设置item的width，height，size；
@property (nonatomic, assign) CGFloat picItemWidth;
@property (nonatomic, assign) CGFloat picItemHeight;
@property (nonatomic, assign) CGSize picItemSize;

// 自适应缩放宽度大小：计算出来后用于设置一个总宽度（比如屏幕宽度）下放几个的平均item宽度；
- (CGFloat)getItemAverageWidthInTotalWidth:(CGFloat)totalWidth itemCount:(NSUInteger)count sectionInset:(UIEdgeInsets)inset interitemSpacing:(CGFloat)minimumInteritemSpacing
;


- (void)setData:(NSArray *)data;

/**
 获取整个collectionView需要的高度
 
 @param data 数组
 @return 高度
 */
- (CGFloat)getCellHeightWithContentData:(NSArray *)data;

@end



@protocol ZXAddPicCollectionViewDelegate <NSObject>

// 这个代理影响在tableView的整体布局高度，所以一定要回调，重新计算总高度；
@required
/**
 编辑（添加按钮,删除小按钮）的时候回调；

 @param addPicCollectionView self
 @param editingStyle ZXAddPicCellEditingStyle
 @param indexPath indexPath
 */
- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView  commitEditingStyle:(ZXAddPicCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;


// 点击已存在的图片
- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didSelectPicItemAtIndex:(NSInteger)index didAddPics:(NSMutableArray *)picsArray;

@end


NS_ASSUME_NONNULL_END


/*******************************例如*多张图片上传******************/


//1.UITableViewCell:HeaderPicsViewCell初始化

//@implementation HeaderPicsViewCell
/*
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    ZXAddPicCollectionView *picView = [[ZXAddPicCollectionView alloc] init];
    picView.maxItemCount = 9;
    picView.minimumInteritemSpacing = 2.f;
    picView.photosState = ZXPhotosViewStateDidCompose;
    picView.sectionInset = UIEdgeInsetsMake(5, 12, 5, 12);
    picView.picItemWidth = [picView getItemAverageWidthInTotalWidth:LCDW itemCount:4 sectionInset:picView.sectionInset interitemSpacing:picView.minimumInteritemSpacing];
    picView.picItemHeight = picView.picItemWidth;
    picView.addButtonImage = [UIImage imageNamed:ZXAddAssetImageName];
    
    picView.addPicCoverView.titleLabel.text = [NSString stringWithFormat:@"添加图片或视频\n(最多9个，视频时长不能超过10秒)"];
    
    self.picsCollectionView = picView;
    [self.contentView addSubview:picView];
    
    [self.picsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(picView.superview.mas_top).offset(0);
        make.bottom.mas_equalTo(picView.superview.mas_bottom).offset(0);
        make.left.mas_equalTo(picView.superview.mas_left).offset(0);
        make.right.mas_equalTo(picView.superview.mas_right).offset(0);
    }];
    
    self.containerView.hidden = YES;
}

// 当有数据的时候
- (void)setData:(id)data
{
    [self.picsCollectionView setData:data];
}
*/



// 2.controller:

/*
#import "ZXAddPicCollectionView.h"
#import "TZImagePickerController.h" //多图选择
#import "XLPhotoBrowser.h" //大图浏览

- (void)viewDidLoad
{
    self.photoCell = [self.tableView dequeueReusableCellWithIdentifier:CellId_headerPicsView];
    self.photoCell.picsCollectionView.delegate = self;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
     AddProductModel *model = (AddProductModel *)[self.diskManager getData];
     if (indexPath.section ==0)
     {
         if (_photosMArray.count >0)
         {
             [self.photoCell setData:_photosMArray];
         }
         return self.photoCell;
     }
}
 
//把请求回来的图片json数组转换成固定格式的ZXPhoto图片model数组：photosMArray
- (void)setupZXPhotoModelArray:(NSArray *)aliossModelArray
{
    
    [aliossModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AliOSSPicUploadModel *model = (AliOSSPicUploadModel *)obj;
        NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:model.p];
        ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:model.p thumbnailUrl:picUrl.absoluteString];
        photo.width = model.w;
        photo.height = model.h;
        [_photosMArray addObject:photo];
    }];
}
 


#pragma mark - 添加图片

- (void)picBtnAction:(id)sender
{
    //初始化多选择照片
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:(9-self.photosMArray.count) delegate:self];
    // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    [imagePicker setSortAscendingByModificationDate:NO];
    //是否有选择原图
    imagePicker.allowPickingOriginalPhoto = NO;
    //    imagePicker.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    //用户选中的图片
    //    imagePicker.selectedAssets = _assestArray;
    //是否允许选择视频
    imagePicker.allowPickingVideo = NO;
    //是否可以拍照
    imagePicker.allowTakePicture = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark- TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    [MBProgressHUD zx_showLoadingWithStatus:@"正在上传" toView:self.view];
    __block NSInteger currentIndex = 0;
    NSMutableArray *tempMArray = [NSMutableArray array];
    WS(weakSelf);
    [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImage *image = (UIImage *)obj;
        NSData *imageData = [WYUtility zipNSDataWithImage:image];
        
        [[AliOSSUploadManager getInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_uploadProduct uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            
        } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
            
            currentIndex ++;
 
            //这里处理上传完的图片：把上传添加后的图片数据加入到临时图片数组photosMArray
            NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:imagePath];
            ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:imagePath thumbnailUrl:picUrl.absoluteString];
            photo.width = imageSize.width;
            photo.height = imageSize.height;
            [tempMArray addObject:photo];

            if (currentIndex ==photos.count)
            {
                [_photosMArray addObjectsFromArray:tempMArray];
                [MBProgressHUD zx_hideHUDForView:weakSelf.view];
                [self.photoCell.picsCollectionView setData:_photosMArray];
                [self.tableView reloadData];
            }
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }];
    }];
}

#pragma mark - ZXAddPicCollectionViewDelegate

- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView commitEditingStyle:(ZXAddPicCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == ZXAddPicCellEditingStyleInsert)
    {
        [self picBtnAction:nil];
    }
    else
    {
        //删除图片数组models的指定图片数据
        [self.photosMArray removeObjectAtIndex:indexPath.item];
        [self.tableView reloadData];
    }
}


- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didSelectPicItemAtIndex:(NSInteger)index didAddPics:(NSMutableArray *)picsArray
{
    //大图浏览
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:picsArray.count datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleCustom;
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
}

 
#pragma mark - XLPhotoBrowserDatasource

- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    
    NSString *orginal =[[_photosMArray objectAtIndex:index]original_pic];
    return [NSURL URLWithString:orginal];
}
*/



// 上传图片地址给自己服务器的时候：转换

// 业务类型1.转换为model数组（json数组）上传
// 图片
/*
- (NSMutableArray *)manyPicModelFormPicArray:(NSMutableArray *)photoArray
{
    NSMutableArray *uploadPicArray = [NSMutableArray array];
    [self.photosMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXPhoto *photo = (ZXPhoto *)obj;
        AliOSSPicUploadModel *model = [[AliOSSPicUploadModel alloc] init];
        model.p = photo.original_pic;
        model.w = photo.width;
        model.h = photo.height;
        [uploadPicArray addObject:model];
    }];
    return  uploadPicArray;
}
// model.pics = [self manyPicModelFormPicArray:self.photosMArray];
*/
 


//业务类型2.转换多张图片地址为一个string的拼接地址，直接给服务器；
/*
- (NSString *)manyPicStrFormPicArray:(NSMutableArray *)photoArray
{
    if (photoArray.count ==0)
    {
        return nil;
    }
    //图片
    NSMutableArray *uploadPicArray = [NSMutableArray array];
    [self.photosMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXPhoto *photo = (ZXPhoto *)obj;
        NSString *picStr = photo.original_pic;
        [uploadPicArray addObject:picStr];
    }];
    return  [uploadPicArray componentsJoinedByString:@","];
}
*/

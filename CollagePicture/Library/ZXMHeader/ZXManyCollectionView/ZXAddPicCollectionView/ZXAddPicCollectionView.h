//
//  ZXAddPicCollectionView.h
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  水平添加图片的组件；

#import <UIKit/UIKit.h>
#import "ZXAddPicViewCell.h"
//图片模型
#import "ZXPhoto.h"


// 图片状态
typedef NS_ENUM(NSInteger, ZXPhotosViewState) {
    ZXPhotosViewStateWillCompose = 0,   // 未发布
    ZXPhotosViewStateDidCompose = 1     // 已发布
};

typedef NS_ENUM(NSInteger, ZXAddPicCellEditingStyle) {
    ZXAddPicCellEditingStyleNone,
    ZXAddPicCellEditingStyleDelete,
    ZXAddPicCellEditingStyleInsert
};



@class ZXAddPicCollectionView;

@protocol ZXAddPicCollectionViewDelegate <NSObject>

/**
 点击添加图片按钮时候的回调；
 
 @param indexPath indexPath description
 */
- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didSelectAddBtnItemAtIndexPath:(NSIndexPath *)indexPath didAddTags:(NSMutableArray *)tagsArray;


- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didSelectPicItemAtIndex:(NSInteger)index didAddPics:(NSMutableArray *)picsArray;

//这个代理影响在tableView的整体布局高度，所以一定要回调，重新计算总高度；
@required
/**
 点击删除照片后的回调；
 
 @param tagsView tagsView description
 @param tagsArray 已经删除后的当前网络数组数据
 */
//- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didDeletedWithTags:(NSMutableArray *)tagsArray ;
- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didDeletedWithTags:(NSMutableArray *)tagsArray forRowAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface ZXAddPicCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, weak) id<ZXAddPicCollectionViewDelegate>delegate;

@property (nonatomic, strong) UICollectionView *collectionView;

/** 所有图片的状态（默认为已发布状态） */
@property (nonatomic, assign) ZXPhotosViewState photosState;

//可以是image数组，也可以是url地址；

@property (nonatomic, strong) NSMutableArray *dataMArray;
//本地image数组
@property (nonatomic, strong) NSMutableArray *images;

//设置collectionView的sectionInset
@property (nonatomic, assign)UIEdgeInsets sectionInset;

//item之间的间距,忽略删除按钮; 可以增大间距来减小item的width；
@property (nonatomic, assign)CGFloat minimumInteritemSpacing;
//行间距，忽略删除按钮
@property (nonatomic, assign)CGFloat minimumLineSpacing;

//设置是否存在动态“添加图片“按钮
@property (nonatomic, getter=isExistInputItem)BOOL existInputItem;

//最多可显示的标签数量，到达这个数，就不能再加入，”添加图片“按钮也会移除
@property (nonatomic, assign)NSInteger maxItemCount;


@property (nonatomic, assign) CGFloat picItemWidth;
@property (nonatomic, assign) CGFloat picItemHeight;

//自适应屏幕宽度：计算出来后用于设置一个总宽度（比如屏幕宽度）的平均item宽度；
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

/*******************************例如*单张图片上传******************/


//HeaderPicsViewCell初始化

 
 //@implementation HeaderPicsViewCell
/*
- (void)awakeFromNib
{
    
    ZXAddPicCollectionView *picView = [[ZXAddPicCollectionView alloc] init];
    picView.maxItemCount = 9;
    //增大间距，来减下平均item宽度
    picView.minimumInteritemSpacing = 10.f;
    picView.photosState = ZXPhotosViewStateDidCompose;
    picView.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    picView.picItemWidth = [picView getItemAverageWidthInTotalWidth:LCDW itemCount:4 sectionInset:picView.sectionInset interitemSpacing:picView.minimumInteritemSpacing];
    picView.picItemHeight = picView.picItemWidth;
    
    self.picsCollectionView = picView;
    
    [self.contentView addSubview:picView];
    
    
    [self.picsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(picView.superview.mas_top).offset(0);
        make.bottom.mas_equalTo(picView.superview.mas_bottom).offset(0);
        make.left.mas_equalTo(picView.superview.mas_left).offset(0);
        make.right.mas_equalTo(picView.superview.mas_right).offset(0);
    }];
    
    self.containerView.hidden = NO;
    self.picsCollectionView.hidden = !self.containerView.hidden;
    
    [super awakeFromNib];
}

 
//当有数据的时候，整个提示view隐藏
 
 - (void)setData:(id)data
 {
     self.containerView.hidden =[data count]>0?YES:NO;
     self.picsCollectionView.hidden = !self.containerView.hidden;
     [self.picsCollectionView setData:data];
 }
  */

 /*
 //controller:


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.label.text = [NSString stringWithFormat:@"请上传9张真实的工厂照片\n让采购商更清楚您的实力"];
    _photosMArray =[self setupZXPhotoModelArray:mode.picArray];
}

//设置需要的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      if (indexPath.section ==1)
      {
            return [self.picsCollectionView getCellHeightWithContentData:_photosMArray];
      }
      
      return LCDScale_iphone6_Width(45.f);
}
  
  
  
// 把请求回来的网络图片数组 转换一下；
- (NSMutableArray)setupZXPhotoModelArray:(NSArray *)aliossModelArray
{
    NSMutableArray *showPicArray = [NSMutableArray array];
    [aliossModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        
        AliOSSPicUploadModel *model = (AliOSSPicUploadModel *)obj;
        NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:model.p];
        ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:model.p thumbnailUrl:picUrl.absoluteString];
        photo.width = model.w;
        photo.height = model.h;
        [showPicArray addObject:photo];
    }];
}

  [self.photoCell setData:_photosMArray];
  
- (void)picBtnAction:(id)sender
{
    [self.morePickerVCManager zxPresentActionSheetToMoreUIImagePickerControllerFromSourceController:self];
}

#pragma mark - ZXAddPicCollectionViewDelegate

//点击添加图片按钮
 
- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath didAddTags:(NSMutableArray *)tagsArray
{
  //  [self.morePickerVCManager zxPresentActionSheetToMoreUIImagePickerControllerFromSourceController:self];
     //初始化多选择照片
     TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:(4-self.photosMArray.count) delegate:self];
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

//删除图片
- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didDeletedWithTags:(NSMutableArray *)tagsArray forRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    [self.photosMArray removeObjectAtIndex:indexPath.item];
    if (tagsArray.count ==0)
    {
        self.photoCell.containerView.hidden = NO;
        self.photoCell.picsCollectionView.hidden = !self.photoCell.containerView.hidden;

    }
    [self.tableView reloadData];

}

 //点击图片查看大图
 - (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didSelectPicItemAtIndex:(NSInteger)index didAddPics:(NSMutableArray *)picsArray
 {
    //大图浏览
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:picsArray.count datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleCustom;
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
 }

 #pragma mark    - XLPhotoBrowserDatasource
 
 - (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
 
    NSString *orginal =[[_photosMArray objectAtIndex:index]original_pic];
    return [NSURL URLWithString:orginal];
 }

 
#pragma mark - ImagePickerControllerDelegate
//代理，添加网络图片
 - (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
 
 
     self.photoCell.containerView.hidden = YES;
     self.photoCell.picsCollectionView.hidden = !self.photoCell.containerView.hidden;
     
     [self zhHUD_showWithStatus:@"正在上传"];
     __block NSInteger currentIndex = 0;
     WS(weakSelf);
     [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     
         UIImage *image = (UIImage *)obj;
         NSData *imageData = [WYUtility zipNSDataWithImage:image];
     
         [[OSSUploadManager getInstance]putObjectOSSStsTokenPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_uploadProduct uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
     
         } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
         
             currentIndex ++;
             //这里处理上传图片
             NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:imagePath];
             ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:imagePath thumbnailUrl:picUrl.absoluteString];
             photo.width = imageSize.width;
             photo.height = imageSize.height;
             
             [_photosMArray addObject:photo];

             if (currentIndex ==photos.count)
             {
                 [weakSelf zhHUD_hideHUDForView:weakSelf.view];
                 [self.photoCell.picsCollectionView setData:_photosMArray];
                 [self.tableView reloadData];

             }
         
         } failure:^(NSError *error) {
         
             [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
         }];
     
     }];
 
 }
*/

//上传图片地址给自己服务器的时候：转换

// 1.转换为model数组上传
 //图片
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
 


//2.转换为string拼接地址
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

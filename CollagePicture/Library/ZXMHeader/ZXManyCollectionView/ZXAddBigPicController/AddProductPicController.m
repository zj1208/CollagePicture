//
//  AddProductPicController.m
//  YiShangbao
//
//  Created by simon on 17/2/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
/*
#import "AddProductPicController.h"
#import "ZXImagePickerVCManager.h"
#import "TMDiskManager.h"
#import "CommonModel.h"
#import "OSSUploadManager.h"
 
@interface AddProductPicController ()<ZXImagePickerVCManagerDelegate,ZXAddBigPicCollectionViewDataSource>

@property (nonatomic ,strong)ZXImagePickerVCManager *imagePickerVCManager;

@property (nonatomic, strong)NSMutableArray *section1MArray;
@property (nonatomic, strong)NSMutableArray *section2MArray;

@property (nonatomic, strong)TMDiskManager *diskManager;


@property (nonatomic, strong)NSIndexPath *editIndexPath;
//总数据集合
@property (nonatomic, strong)NSMutableArray *dataMArray;
@end

@implementation AddProductPicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ZXImagePickerVCManager *pickerVCManager = [[ZXImagePickerVCManager alloc] init];
    pickerVCManager.morePickerActionDelegate = self;
    self.imagePickerVCManager = pickerVCManager;
    
    //初始化oss上传
    [[OSSUploadManager getInstance] initOSSStsTokenCredential];
    
    self.collectionView.backgroundColor = UIColorFromRGB_HexValue(0xf3f3f3);

    self.collectionView.zxdataSource = self;
    [self.collectionView registerClass:[ZXAddProPicCollectionCell class] forCellWithReuseIdentifier:@"Cell"];

    
    NSMutableArray *dataM = [NSMutableArray array];
    self.dataMArray = dataM;
    
    
    NSMutableArray *mArr = [NSMutableArray array];
    self.section1MArray = mArr;
    
    NSMutableArray *mArr2 = [NSMutableArray array];
    self.section2MArray = mArr2;

    
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
    self.diskManager = manager;
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    if (model.pics.count>0)
    {
        [self.section1MArray addObject:[model.pics firstObject]];
        if (model.pics.count>1)
        {
            NSArray *arr = [model.pics subarrayWithRange:NSMakeRange(1, model.pics.count-1)];
            [self.section2MArray addObjectsFromArray:arr];
        }
    }
    [self.collectionView reloadData];
    
    self.collectionView.uploadPicBtnActionBlock = ^(NSIndexPath *editPath)
    {
          [self.imagePickerVCManager zxPresentActionSheetToMoreUIImagePickerControllerFromSourceController:self];
    };
}

 //每次刷新需要数据的时候才会去转换一下
- (NSMutableArray *)ZXAddBigPicCollectionViewSection1Marray
{
    return [self setupZXPhotoModelArray:self.section1MArray];
}

- (NSMutableArray *)ZXAddBigPicCollectionViewSection2Marray
{
    return [self setupZXPhotoModelArray:self.section2MArray];
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

//代理
- (void)zxImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info withEditedImage:(UIImage *)image
{
    NSData *imageData = [WYUtility zipNSDataWithImage:image];
    [self zhHUD_showWithStatus:@"正在上传"];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
    WS(weakSelf);
    [[OSSUploadManager getInstance]putObjectOSSStsTokenPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_uploadProduct uploadingData:imageData progress:nil singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
        
//        AliOSSPicUploadModel *model = [[AliOSSPicUploadModel alloc] init];
//        model.p = imagePath;
//        model.w = imageSize.width;
//        model.h = imageSize.height;
 
         //这里处理上传图片
         NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:imagePath];
         ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:imagePath thumbnailUrl:picUrl.absoluteString];
         photo.width = imageSize.width;
         photo.height = imageSize.height;
 
 
        [weakSelf zhHUD_showSuccessWithStatus:@"上传成功"];
        self.navigationController.navigationBar.userInteractionEnabled = YES;
        if (_editIndexPath.section ==0)
        {
            [_section1MArray addObject:photo];
        }
        else
        {
            [_section2MArray addObject:photo];
        }
        [weakSelf.collectionView reloadData];
        //这里处理上传图片
        
    } failure:^(NSError *error) {
        
        [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
        self.navigationController.navigationBar.userInteractionEnabled = YES;
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//@end


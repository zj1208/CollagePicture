//
//  ZXLabelsInputTagsView.h
//  YiShangbao
//
//  Created by simon on 17/2/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介： 动态添加标签的collectionView

//  2017.12.26 修改nibName 常量定义 改为NSStringFromClass；
//  2018.2.11；修改在达到最大数量时候删除的bug；
//  2018.6.07  修改高度计算；
//  2018.6.25  修改高度计算造成的bug；
//  2018.6.29  优化组件；
//  2018.08.01 优化collectionView添加时机不对造成的高度计算bug；
//  2019.10.26 标签宽度小数点进1，限制标签最大宽度不超过collectionView的宽度-inset的最终宽度；

#import <UIKit/UIKit.h>
#import "LabelCell.h"

NS_ASSUME_NONNULL_BEGIN

// 编辑方式
typedef NS_ENUM(NSInteger, ZXLabelsInputCellEditingStyle) {
    
    ZXLabelsInputCellEditingStyleNone,
    ZXLabelsInputCellEditingStyleDelete, // 删除
    ZXLabelsInputCellEditingStyleInserting,  // 添加中
    ZXLabelsInputCellEditingStyleInserted  // 已经添加

};


@class ZXLabelsInputTagsView;

@protocol ZXLabelsInputTagsViewDelegate <NSObject>

// 如果不实现这些协议，则会用默认的设置；
@optional
/**
 将要展示数据的时候，自定义设置cell的显示；不影响布局的外观设置

 @param cell LabelCell
 @param indexPath collectionView中的对应indexPath
 */
- (void)zx_labelsInputTagsView:(ZXLabelsInputTagsView *)tagsView  willDisplayCell:(LabelCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 点击添加标签事件回调-是否弹出默认输入弹框
 
 */
- (BOOL)zx_shuoldPopAddTagAlertViewLabelsInputTagsView:(ZXLabelsInputTagsView *)tagsView;

/**
 默认输入弹框中的文字输入监听回调；  可以自定义处理判断或再增加弹框；一般不用；

 @param notification notification description
 */
- (void)zx_labelsInputTagsView:(ZXLabelsInputTagsView *)tagsView textFieldTextDidChangeNotification:(NSNotification *)notification;

// 是否可以添加这个输入标签title
- (BOOL)zx_shuoldAddTagTitleWithLabelsInputTagsView:(ZXLabelsInputTagsView *)tagsView tagTitle:(nullable NSString *)title;


@required


/**
 编辑（已经添加,已经删除）的时候回调；

 @param tagsView self
 @param editingStyle ZXLabelsInputCellEditingStyle
 @param indexPath 指定indexPath，添加的时候无意义；
 */
- (void)zx_labelsInputTagsView:(ZXLabelsInputTagsView *)tagsView commitEditingStyle:(ZXLabelsInputCellEditingStyle)editingStyle forRowAtIndexPath:(nullable NSIndexPath *)indexPath addTagTitle:(nullable NSString *)title;

@end


@interface ZXLabelsInputTagsView : UIView<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, weak) id<ZXLabelsInputTagsViewDelegate>delegate;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataMArray;

// 设置collectionView的sectionInset
@property (nonatomic, assign) UIEdgeInsets sectionInset;

// 标签item之间的最小间距
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

// 行间距
@property (nonatomic, assign) CGFloat minimumLineSpacing;

// 设置是否存在输入标签
@property (nonatomic, getter=isExistInputItem) BOOL existInputItem;

// 最多可显示的标签数量，到达这个数，就不能再输入了，输入标签也会移除
@property (nonatomic, assign) NSInteger maxItemCount;

// 设置item的height；
@property (nonatomic, assign) CGFloat itemHeight;

// 设置添加tag的提示文本，默认@"点击输入标签"
@property (nonatomic, copy) NSString *defaultAddTagTitle;
// 点击添加tag时，默认提示中的文本；
@property (nonatomic, copy) NSString *defaultAlertTitle;
// 点击添加tag时,默认提示框中的textField的最长文本长度；默认10个长度
@property (nonatomic, assign) NSInteger defaultAlertFieldTextLength;

// 添加tag标签的文字颜色，边框颜色，圆角设置，添加标签的背景色
@property (nonatomic, strong) UIColor *addTagTextColor;
@property (nonatomic, strong) UIColor *addTagBorderColor;
@property (nonatomic, assign) CGFloat addTagCornerRadius;
@property (nonatomic, strong) UIColor *addTagBackgroudColor;

// 标签背景色
@property (nonatomic, strong) UIColor *tagTextColor;
@property (nonatomic, strong) UIColor *tagBorderColor;
@property (nonatomic, assign) CGFloat tagCornerRadius;
@property (nonatomic, strong) UIColor *tagBackgroudColor;


- (void)setData:(NSArray *)data;

/**
 获取整个collectionView需要的高度

 @param data 数组
 @return 高度
 */
- (CGFloat)getCellHeightWithContentData:(nullable NSArray *)data;

@end


NS_ASSUME_NONNULL_END




//////////////////－－－－－－例如－－－－－－－///////////////
#pragma mark - 例1-纯显示ZXLabelsTagsView 和输入添加ZXLabelsInputTagsView一起动态


#pragma mark-AddProLabelTagCell:cell中显示编辑标签数组


/*
#import "BaseTableViewCell.h"
#import "ZXLabelsInputTagsView.h"

@interface AddProLabelTagCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet ZXLabelsInputTagsView *inputTagsView;
@end
*/

/*
#import "AddProLabelTagCell.h"

@implementation AddProLabelTagCell


- (void)awakeFromNib
{
    self.inputTagsView.defaultAddTagTitle = @"添加产品标签";
    self.inputTagsView.defaultAlertTitle = @"添加产品标签，不超过10个字";
    self.inputTagsView.maxItemCount = 10;
    self.inputTagsView.minimumLineSpacing = 10;
    [super awakeFromNib];
}

- (void)setData:(id)data
{
    [self.inputTagsView setData:data];
}

- (CGFloat)getCellHeightWithContentIndexPath:(NSIndexPath *)indexPath data:(id)data
{
    return [self.inputTagsView getCellHeightWithContentData:data];
}
@end
*/

#pragma mark - 显示纯展示的推荐标签数组

/*
#import "BaseTableViewCell.h"
#import "ZXLabelsTagsView.h"

@interface AddProRecdLabelCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet ZXLabelsTagsView *labelsTagsView;
@end

 
 #import "AddProRecdLabelCell.h"
 
 @implementation AddProRecdLabelCell
 
 - (void)awakeFromNib
 {
    [super awakeFromNib];
    self.labelsTagsView.maxItemCount = 50;
 }
 
 - (void)setData:(id)data
 {
    [self.labelsTagsView setData:data];
 }
 
 - (CGFloat)getCellHeightWithContentIndexPath:(NSIndexPath *)indexPath data:(id)data
 {
    return [self.labelsTagsView getCellHeightWithContentData:data];
 }
 @end

 */


#pragma mark-AddProLabelsController.h-控制器
/*
controller.h-用tableViewController做
 
#import "AddProLabelsController.h"
#import "ZXTitleView.h"
#import "ProductMdoleAPI.h"
#import "AddProLabelTagCell.h"
#import "AddProRecdLabelCell.h"
#import "TMDiskManager.h"
#import "AddProductModel.h"


@interface AddProLabelsController ()<ZXLabelsInputTagsViewDelegate,ZXLabelsTagsViewDelegate>

@property (nonatomic, strong)TMDiskManager *diskManager;
@property (nonatomic, strong) NSMutableArray *dataMArray; //纯展示推荐标签组
@property (nonatomic, strong) NSMutableArray *addedMArray;//编辑添加标签组

@end

@implementation AddProLabelsController

static NSString *const reuse_recommendTagsCell = @"recdTagsCell";
static NSString *const reuse_editTagsCell = @"editTagsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = WYUISTYLE.colorBGgrey;    
    [self setData];
    
}

- (void)setData
{
    NSMutableArray *addArray = [NSMutableArray array];
    self.addedMArray = addArray;
    
    //获取已经保存的数据,展示在ZXLabelsInputTagsView小组里展示
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
    self.diskManager = manager;
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    if (![NSString zx_isBlankString:model.labels])
    {
         NSArray *labelsArray = [model.labels componentsSeparatedByString:@","];
         if (labelsArray.count>0)
         {
           [self.addedMArray addObjectsFromArray:labelsArray];
         }
    }
 
    //获取网络推荐数据，展示在ZXLabelsTagsView
    _dataMArray = [NSMutableArray array];

    NSArray *orgArray = @[@"测试数据",@"测试",@"妈妈说标题要长",@"机智的手哥",@"新明哥哥你好帅啊,爱死你了",@"I Love You!"];
    [_dataMArray addObjectsFromArray:orgArray];
    
    [self requestData];
}


- (void)requestData
{
    [ProductMdoleAPI getProductUsualProdLabelsWithSuccess:^(id data) {
        
        [self.dataMArray addObjectsFromArray:data];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //ZXLabelsInputTagsView-需要添加标签
    if (indexPath.section ==0)
    {
         AddProLabelTagCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_editTagsCell forIndexPath:indexPath];
         cell.inputTagsView.delegate = self;
         [cell setData:self.addedMArray];
         return cell;
    }
    //ZXLabelsTagsView-推荐标签
    if (indexPath.section==2)
    {
        AddProRecdLabelCell *cell1 = [tableView dequeueReusableCellWithIdentifier:reuse_recommendTagsCell forIndexPath:indexPath];
        [cell1 setData:self.dataMArray];
        cell1.labelsTagsView.delegate = self;
        return cell1;
    }
    // 提示语展示
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = @"例如产品名称为:全新冰雪奇缘二代姐妹音乐批发大套装礼盒玩具艾莎芭比娃娃\n标签:冰雪奇缘、音乐、艾莎、芭比娃娃、艾尔莎、玩具礼盒、娃娃、安娜";
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.numberOfLines = 0;
    cell.backgroundColor = WYUISTYLE.colorBGgrey;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ZXLabelsInputTagsView的高度-需要添加标签
    if (indexPath.section ==0)
    {
         static AddProLabelTagCell *cell =  nil;
         static dispatch_once_t onceToken;
 
         dispatch_once(&onceToken, ^{
 
         cell = [tableView dequeueReusableCellWithIdentifier:reuse_editTagsCell];
         });
         return [cell getCellHeightWithContentIndexPath:indexPath data:self.addedMArray];
    }
     // 提示语展示
    else if (indexPath.section ==1)
    {
        if (self.dataMArray.count>0)
        {
            return 0.f;
        }
        static UITableViewCell *cell =  nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        });
        [cell.textLabel layoutIfNeeded];
        cell.textLabel.text = @"例如产品名称为:全新冰雪奇缘二代姐妹音乐批发大套装礼盒玩具艾莎芭比娃娃\n标签:冰雪奇缘、音乐、艾莎、芭比娃娃、艾尔莎、玩具礼盒、娃娃、安娜";;
        [cell.contentView layoutIfNeeded];
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        return size.height;
    }
    //ZXLabelsTagsView推荐标签的总高度-推荐常用标签
    else if (indexPath.section ==2)
    {
        static AddProRecdLabelCell *cell =  nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            cell = [tableView dequeueReusableCellWithIdentifier:reuse_recommendTagsCell];
        });
        return [cell getCellHeightWithContentIndexPath:indexPath data:self.dataMArray];
    }
    return 45.f;
    
}



#pragma mark - 组头，组尾展示提示

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:return 40.f; break;
        case 1:return self.dataMArray.count>0?0.1f:20.f;break;
        default:return 0.1f;
            break;
    }
    return 0.1f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section ==0)
    {
        ZXTitleView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXTitleView owner:self options:nil] firstObject];
        view.titleLab.text =@"*每个最多10个字，最多可以输入10个标签";
        view.titleLab.font = [UIFont systemFontOfSize:12];
        view.titleLab.textColor = [UIColor redColor];
        [view.leftImageView removeFromSuperview];
        view.backgroundColor =WYUISTYLE.colorBGgrey;
        return view;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0)
    {
        return 10;
    }
    else if (section ==2)
    {
        return self.dataMArray.count==0?0.f:45.f;
    }
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==2)
    {
        ZXTitleView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXTitleView owner:self options:nil] firstObject];
        view.titleLab.text =@"常用标签";
        view.titleLab.font = [UIFont systemFontOfSize:14];
        view.backgroundColor =WYUISTYLE.colorBGgrey;
        return view;
    }
    return [[UIView alloc] init];
    
}


#pragma mark -ZXLabelsInputTagsViewDelegate
 
 - (void)zx_labelsInputTagsView:(ZXLabelsInputTagsView *)tagsView commitEditingStyle:(ZXLabelsInputCellEditingStyle)editingStyle forRowAtIndexPath:(nullable NSIndexPath *)indexPath addTagTitle:(nullable NSString *)title
 {
     if (editingStyle ==ZXLabelsInputCellEditingStyleDelete)
     {
         [self.addedMArray removeObjectAtIndex:indexPath.item];
         [self.tableView reloadData];
     }
     else if (editingStyle ==ZXLabelsInputCellEditingStyleInserted)
     {
         [self.addedMArray insertObject:title atIndex:0];
         [self.tableView reloadData];
     }
 }
 
 - (BOOL)zx_shuoldAddTagTitleWithLabelsInputTagsView:(ZXLabelsInputTagsView *)tagsView tagTitle:(NSString *)title
 {
     if ([self.addedMArray containsObject:title])
     {
         [MBProgressHUD zx_showError:NSLocalizedString(@"经营品牌不能重复，请更换", nil) toView:self.view];
         return NO;
     }
     return YES;
 }


//点击labelsTagsView推荐常用标签，加入到ZXLabelsInputTagsView 展示
 
#pragma mark- ZXLabelsTagsViewDelegate

- (void)zx_labelsTagsView:(ZXLabelsTagsView *)labelsTagView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [self.dataMArray objectAtIndex:indexPath.item];
    if (![self.addedMArray containsObject:obj])
    {
        [self.addedMArray insertObject:obj atIndex:0];
        [self.tableView reloadData];
    }
}

//确定－保存下来，及返回
- (IBAction)saveBarItemAction:(UIBarButtonItem *)sender {
    
 if (self.dataMArray.count>0)
 {
     NSString *labels = [self.dataMArray componentsJoinedByString:@","];
     [self.diskManager setPropertyImplementationValue:labels forKey:@"mainBrand"];
 }
 else
 {
     [self.diskManager setPropertyImplementationValue:nil forKey:@"mainBrand"];
 }
 [self.navigationController popViewControllerAnimated:YES];

}

@end

*/





#pragma mark - 例2 ：纯添加及删除


#pragma mark - 上一级页面，先初始化一个数据表，让模型存在；

/*
- (void)initData
{
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskShopManageInfoKey];
    self.diskManager = manager;
    
    ShopManagerInfoModel *model = [[ShopManagerInfoModel alloc] init];
    [self.diskManager setData:model];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shopInfoChange:) name:TMDiskShopManageInfoKey object:nil];
}
- (void)shopInfoChange:(id)notification
{
    ShopManagerInfoModel *model = (ShopManagerInfoModel *)[self.diskManager getData];
    self.shopProLab.text = model.mainSell?model.mainSell:@"请输入主营产品";
    self.shopProLab.textColor = model.mainSell?UIColorFromRGB_HexValue(0x222222):UIColorFromRGB_HexValue(0xCCCCCC);
    
    self.brandLab.text =model.mainBrand?model.mainBrand:@"请输入代理品牌";
    self.brandLab.textColor = model.mainBrand?UIColorFromRGB_HexValue(0x222222):UIColorFromRGB_HexValue(0xCCCCCC);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
*/


#pragma mark - 添加删除标签功能／加载默认标签功能的页面
/*
#import "ManageBrandController.h"

#import "TMDiskManager.h"
#import "ManageMainProCell.h"
#import "ZXTitleView.h"

@interface ManageBrandController ()<ZXLabelsInputTagsViewDelegate>

@property (nonatomic, strong)TMDiskManager *diskManager;
@property (nonatomic, strong) NSMutableArray *addedMArray;
@property (nonatomic,strong)ManageMainProCell *editLabelTagCell;


@end

@implementation ManageBrandController

static NSString *editTagsCell = @"editTagsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = WYUISTYLE.colorBGgrey;
    //防止数据初始化，重新拿重用的cell；
    ManageMainProCell *cell =[self.tableView dequeueReusableCellWithIdentifier:editTagsCell];
    self.editLabelTagCell = cell;
    
    [self setData];    
}

- (void)setData
{
    NSMutableArray *addArray = [NSMutableArray array];
    self.addedMArray = addArray;
 
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskShopManageInfoKey];
    self.diskManager = manager;
    ShopManagerInfoModel *model = (ShopManagerInfoModel *)[self.diskManager getData];
    
    if (![NSString zx_isBlankString:model.mainBrand])
    {
        NSArray *labelsArray = [model.mainBrand componentsSeparatedByString:@","];
        if (labelsArray.count>0)
        {
            [self.addedMArray addObjectsFromArray:labelsArray];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editLabelTagCell.inputTagsView.delegate = self;
    [self.editLabelTagCell setData:self.addedMArray];
    return self.editLabelTagCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [self.editLabelTagCell getCellHeightWithContentIndexPath:indexPath data:self.addedMArray];
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section ==0)
    {
        ZXTitleView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXTitleView owner:self options:nil] firstObject];
        view.titleLab.text =@"最多输入5个品牌";
        view.titleLab.font = [UIFont systemFontOfSize:12];
        view.titleLab.textColor = [UIColor redColor];
        [view.leftImageView removeFromSuperview];
        view.backgroundColor =WYUISTYLE.colorBGgrey;
        return view;
    }
    return [[UIView alloc] init];
}


- (void)zx_labelsInputTagsView:(ZXLabelsInputTagsView *)tagsView didChangedTagsWithTags:(NSMutableArray *)tagsArray
{
    self.addedMArray = tagsArray;
    [self.tableView reloadData];
}
- (IBAction)saveBarItemAction:(UIBarButtonItem *)sender {
    
    if (self.addedMArray.count>0)
    {
        NSString *labels = [self.addedMArray componentsJoinedByString:@","];
        [self.diskManager setPropertyImplementationValue:labels forKey:@"mainBrand"];
    }
    else
    {
        [self.diskManager setPropertyImplementationValue:nil forKey:@"mainBrand"];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end

*/




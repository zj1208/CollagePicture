//
//  GuideViewController.m
//  SiChunTang
//
//  Created by simon on 15/11/18.
//  Copyright © 2015年 simon. All rights reserved.
//

#import "ZXGuideViewController.h"
#import "AppDelegate.h"


NSString *const kHadLaunchedGuide = @"kHadLaunchedGuide_1";


@interface ZXGuideViewController ()<UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) NSMutableArray *dataMArray;
@property(nonatomic,strong) UIViewController *rootViewController;

+ (ZXGuideViewController *)sharedGuide;

/**
 * 添加图片数据;
 */
- (void)setData:(id)data;
/**
 *  是否首次安装app加载的跟视图设置;
 *
 *  @param vc tabBarController
 */
- (void)firstLaunchAppWithRootController:(UIViewController *)vc;
@end


@implementation ZXGuideViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
 {
      //创建流水布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize =  [UIScreen mainScreen].bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    return [super initWithCollectionViewLayout:layout];
}






+ (ZXGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static ZXGuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}



+ (BOOL)hadLaunchedGuide
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kHadLaunchedGuide];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.dataMArray)
    {
        self.dataMArray = [NSMutableArray array];
    }
   
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.clearsSelectionOnViewWillAppear = NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.pagingEnabled = YES;
}


+ (void)guideFigureWithImages:(NSArray *)images finishWithRootController:(UIViewController *)vc
{
    [[ZXGuideViewController sharedGuide]setData:images];
    [[ZXGuideViewController sharedGuide]firstLaunchAppWithRootController:vc];
}

- (void)setData:(id)data
{
    if (!self.dataMArray)
    {
        self.dataMArray = [NSMutableArray array];
    }
    if (!data)return;
    [self.dataMArray addObjectsFromArray:data];
}



- (void)viewWillAppear:(BOOL)animated
{
    [self.collectionView reloadData];
    [super viewWillAppear:animated];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataMArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    cell.backgroundColor =UIColorFromRGB(arc4random()%255, arc4random()%255, arc4random()%255);

    if (![cell.contentView viewWithTag:100])
    {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.tag =100;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imgView];
        
        UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [enterButton setTitle:@"开始" forState:UIControlStateNormal];
        [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        enterButton.backgroundColor = [UIColor grayColor];
        enterButton.layer.masksToBounds = YES;
        enterButton.layer.cornerRadius = 8;
        [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:enterButton];
        enterButton.tag =200;
        enterButton.hidden = YES;
    }
   
    UIImageView * imgView = (UIImageView *)[cell.contentView viewWithTag:100];
//    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.edges.equalTo(cell);
//    }];
    [self addImgViewConstraint:imgView toItem:imgView.superview];
    
    id sd = [self.dataMArray objectAtIndex:indexPath.item];
    imgView.image = [UIImage imageNamed:sd];
    
    
    UIButton * btn = (UIButton *)[imgView viewWithTag:200];
    btn.hidden = YES;
    if (indexPath.item==self.dataMArray.count-1)
    {
        btn.hidden = NO;
        imgView.userInteractionEnabled = YES;
    }
    //    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(imgView).with.offset(-80);
    //        make.centerX.equalTo(imgView.mas_centerX);
    //        make.left.equalTo(imgView.mas_left).with.offset(80);
    //        make.height.mas_equalTo(@(35));
    //    }];
    [self addConstraint:btn toItem:btn.superview];
    
    return cell;
}

/**
 *  给imageView添加约束
 *
 *  @param item      imgView
 *  @param superView imgView的父视图
 */
- (void)addImgViewConstraint:(UIView *)item toItem:(UIView *)superView
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    
    //centerX
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [superView addConstraint:constraint1];
    
    
    //centerY
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [superView addConstraint:constraint2];
    
    //右边 right 0
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [superView addConstraint:constraint3];
    
    //上边 top 0
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [superView addConstraint:constraint4];
}

/**
 *  给按钮添加约束
 *
 *  @param item      按钮
 *  @param superView 父视图
 */
- (void)addConstraint:(UIView *)item toItem:(UIView *)superView
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    //bottom -80
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:-80];
    [superView addConstraint:constraint1];
    
    //高度 height 35
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:35];
    [item addConstraint:constraint2];
    
    
    //centerX
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [superView addConstraint:constraint3];
    
    //右边 right 80
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1 constant:-80];
    [superView addConstraint:constraint4];
}


#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame),CGRectGetHeight(self.collectionView.frame));
}


- (void)pressEnterButton:(UIButton *)sender
{

    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];


    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHadLaunchedGuide];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    window.rootViewController = self.rootViewController;

    if ([self.delegate respondsToSelector:@selector(guideViewComeToRootViewController)])
    {
        [self.delegate guideViewComeToRootViewController];
    }

    
}




- (void)firstLaunchAppWithRootController:(UIViewController *)vc
{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
  
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kHadLaunchedGuide])
    {
        window.rootViewController = self;
        self.rootViewController =vc;
        [window makeKeyAndVisible];
    }
    else
    {
        window.rootViewController = vc;
        [window makeKeyAndVisible];

        if ([self.delegate respondsToSelector:@selector(guideViewComeToRootViewController)])
        {
            [self.delegate guideViewComeToRootViewController];
        }
    }
   
}

- (void)guideIMAppfirstLaunchWithLoginViewController:(UIViewController *)loginVC rootController:(UIViewController *)rootVC isLoginUserDefault:(BOOL)isUD
{
    if (!isUD)
        
    {
        [self firstLaunchAppWithRootController:loginVC];
        
    }
    else
    {
        [self firstLaunchAppWithRootController:rootVC];
    }
}

- (void)guideIMAppLoginOut:(UIViewController *)loginVC
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController =loginVC;
}

- (void)guideIMAppLoginIn:(UIViewController *)rootVC
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController =rootVC;
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

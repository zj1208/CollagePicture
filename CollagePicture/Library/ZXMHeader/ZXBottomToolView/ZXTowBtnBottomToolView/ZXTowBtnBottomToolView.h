//
//  ZXTowBtnBottomToolView.h
//  YiShangbao
//
//  Created by simon on 17/4/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  简介：展示2个按钮的工具条；可以根据属性调节各个间距；2个按钮都垂直居中显示；同时可以设置按钮之间的space间距，按钮与父视图的边距大小；根据左边按钮的宽度设置，和各间距，来自定义调节右边按钮的宽度； 可以自由设置按钮的各种基本属性；
//  2018.4.12  增加简介；

#import <UIKit/UIKit.h>



static NSString *nibName_ZXTowBtnBottomToolView = @"ZXTowBtnBottomToolView";

@interface ZXTowBtnBottomToolView : UIView


// 所有上边距，按钮垂直居中显示；默认8.f
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allBtnTopLayout;

// 左边按钮
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
// 左边按钮左边距约束设置;默认15.f;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBtnLeadingLayout;
// 左边按钮宽度约束设置; 默认162.f;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBtnWidthLayout;

// 右边按钮
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
// 右边按钮右边约束设置;默认15.f;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtnTralingLayout;


// 按钮之间的间距space大小；默认20.f;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnsSpaceLayout;

@end

//2个按钮的举例：这个例子中其中一个按钮利用富文本有二行文本显示，且第一行文本包含图标；


/*
- (void)initUI
{
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = 60.f;
    self.tableView.contentInset = inset;
    
    [self addBottomView];
}

- (void)addBottomView
{
    [self.bottomContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.bottomContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    ZXTowBtnBottomToolView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXTowBtnBottomToolView owner:self options:nil] firstObject];
    view.backgroundColor = [UIColor clearColor];
    [self.bottomContainerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.bottomContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    // 左侧按钮设置：分2排，上一排是图标+文字，下一排是文字；
    NSMutableAttributedString *line1Att = [[NSMutableAttributedString alloc] initWithString:@" 设为私密" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                                  NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    UIImage *attachImg = [UIImage imageNamed: @"ic_simi"];
    textAttachment.image = attachImg;  //设置图片源
    textAttachment.bounds = CGRectMake(0, -4, attachImg.size.width, attachImg.size.height);          //设置图片位置和大小
    NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [line1Att insertAttributedString:attrStr atIndex:0];
    
    NSAttributedString *line2Att = [[NSAttributedString alloc] initWithString:@"(不公开只能分享查看)" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                          NSFontAttributeName:[UIFont systemFontOfSize:10]}];
    [view.leftBtn zh_setTowOfLinesStringWithLineSpace:5.f firstLineWithAttributedTitle:line1Att secondLineWithAttributedTitle:line2Att];
    
    [view.leftBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
    view.leftBtnWidthLayout.constant = LCDScale_iPhone6_Width(162);
    [view.leftBtn addTarget:self action:@selector(privacyBtnAction:forEvent:) forControlEvents:UIControlEventTouchUpInside];
 
     // 或者左侧按钮2-图标+文字
     // 本店分类设置
     [view.leftBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
     [view.leftBtn setTitle:@"本店分类设置" forState:UIControlStateNormal];
     [view.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     UIImage *image = [[UIImage imageNamed:@"ic_fenleishezhi"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     [view.leftBtn setImage:image forState:UIControlStateNormal];
     view.leftBtnWidthLayout.constant = LCDScale_iPhone6_Width(170);
     [view.leftBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
     [view.leftBtn addTarget:self action:@selector(classifyBtnAction:forEvent:) forControlEvents:UIControlEventTouchUpInside];
 
    // 右侧：公开上架按钮
    UIImage *backgroundImage = [WYUTILITY getCommonVersion2RedGradientImageWithSize:view.rightBtn.frame.size];
    [view.rightBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [view.rightBtn setTitle:@"公开上架" forState:UIControlStateNormal];
    [view.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view.rightBtn addTarget:self action:@selector(uploadBtnAction:forEvent:) forControlEvents:UIControlEventTouchUpInside];
}
*/

/*
- (void)addBottomView
{
    self.bottomContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    ZXTowBtnBottomToolView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXTowBtnBottomToolView owner:self options:nil] firstObject];
    view.backgroundColor = [UIColor clearColor];
    [self.bottomContainerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(self.bottomContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    
    // 本店分类设置
    [view.leftBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
    [view.leftBtn setTitle:@"本店分类设置" forState:UIControlStateNormal];
    [view.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *image = [[UIImage imageNamed:@"ic_fenleishezhi"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [view.leftBtn setImage:image forState:UIControlStateNormal];
    view.leftBtnWidthLayout.constant = LCDScale_iPhone6_Width(170);
    [view.leftBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    [view.leftBtn addTarget:self action:@selector(classifyBtnAction:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *backgroundImage = [WYUTILITY getCommonVersion2RedGradientImageWithSize:view.rightBtn.frame.size];
    [view.rightBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    view.rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [view.rightBtn setTitle:@"上传产品" forState:UIControlStateNormal];
    [view.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view.rightBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
*/

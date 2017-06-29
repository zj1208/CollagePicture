//
//  HeaderView.m
//  wqk8
//
//  Created by xielei on 15/11/11.
//  Copyright © 2015年 mac. All rights reserved.
//#import "Masonry.h"


#import "HeaderView.h"
//#import "Masonry.h"
#import "UIButton+WebCache.h"
//#import "UserModel.h"
@implementation HeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
   
    [super awakeFromNib];
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSet];
    }
    return self;
}

- (void)initSet
{
  
  
}



- (void)setData:(id)data
{
//    UserOutPutBean *model = (UserOutPutBean *)data;
    NSString *str = [NSString stringWithFormat:@"head_b%@",@(1+arc4random() % 8)];
    
//    NSString *appendString=model.headIcon;
//    if ([model.headIcon hasPrefix:@"avtor/"])
//    {
//        appendString = [NSString stringWithFormat:@"http://woqin.oss-cn-hangzhou.aliyuncs.com/%@",model.headIcon];
//    }
    
  //  [self.headBtn sd_setImageWithURL:[NSURL URLWithString:nil] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:str]];
    
 //   self.nameLab.text = model.nickName;
 //   self.signatureLab.text = model.signature;
  
}



@end

//
//  TemplateListCell.m
//  CollagePicture
//
//  Created by simon on 16/9/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "TemplateListCell.h"
#import "UIImageView+WebCache.h"

@implementation TemplateListCell

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
    [self zx_setBorderWithCornerRadius:5 borderWidth:1 borderColor:[UIColor clearColor]];
}

- (void)setData:(id)data
{
    NSString *string = [data objectForKey:@"picUrl"];
    NSURL *url = [NSURL zx_ossImageWithResizeType:OSSImageResizeType_w828_hX relativeToImgPath:string];
      
    [self.imgView sd_setImageWithURL:url placeholderImage:AppPlaceholderImage];
}
@end

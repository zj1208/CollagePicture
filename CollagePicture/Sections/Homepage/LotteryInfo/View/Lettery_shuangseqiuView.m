//
//  Lettery_shuangseqiuView.m
//  CollagePicture
//
//  Created by 蔡叶超 on 6/30/17.
//  Copyright © 2017 simon. All rights reserved.
//

#import "Lettery_shuangseqiuView.h"

@implementation Lettery_shuangseqiuView

+ (instancetype)xibView {
    Lettery_shuangseqiuView *view = (Lettery_shuangseqiuView *)[[[NSBundle mainBundle] loadNibNamed:@"LetteryView" owner:nil options:nil] lastObject];
    return view;
}

@end

//
//  Lettery_daletouView.m
//  CollagePicture
//
//  Created by 蔡叶超 on 6/30/17.
//  Copyright © 2017 simon. All rights reserved.
//

#import "Lettery_daletouView.h"

@implementation Lettery_daletouView

+ (instancetype)xibView {
    Lettery_daletouView *view = (Lettery_daletouView *)[[[NSBundle mainBundle] loadNibNamed:@"LetteryView" owner:nil options:nil] objectAtIndex:1];
    return view;
}

@end

//
//  Lettory_11xuan5View.m
//  CollagePicture
//
//  Created by 蔡叶超 on 6/30/17.
//  Copyright © 2017 simon. All rights reserved.
//

#import "Lettery_11xuan5View.h"

@interface Lettery_11xuan5View()



@end


@implementation Lettery_11xuan5View

+ (instancetype)xibView {
    Lettery_11xuan5View *view = (Lettery_11xuan5View *)[[[NSBundle mainBundle] loadNibNamed:@"LetteryView" owner:nil options:nil] firstObject];
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}



- (void)updateData:(NSArray *)arr {
    assert(arr.count != 5);
    for (int i = 0; i < arr.count; i ++) {
        UILabel *label = (UILabel *)[self viewWithTag:i];
        label.text = [NSString stringWithFormat:@"%d", i];
    }
}
@end

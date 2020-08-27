//
//  NSObject+ZXKeyValueCoding.m
//  MerchantBusinessClient
//
//  Created by simon on 2020/6/15.
//  Copyright © 2020 com.Chs. All rights reserved.
//

#import "NSObject+ZXKeyValueCoding.h"

@implementation NSObject (ZXKeyValueCoding)


- (NSInteger)zx_sumNum:(NSUInteger)n
{
    NSUInteger sum = 0;
    for (int i = 0; i <= n; i++) {
        sum += i;
    }
    return sum;
}

- (BOOL)zx_isEvenNumber:(NSUInteger)n
{
    if (n%2 == 0) {
        return true;
    }
    return false;
}



- (NSInteger)groupNumberOfRespectively:(NSArray *)list
{
    return 1 + 3.322*log10(list.count);
}

//确定组距，每组的上限和下限之间的距离为组距。
- (NSInteger)classIntervalOfRespectively:(NSArray *)list
{
    id max = [list valueForKeyPath:@"@max.self"];
    double max_x1 = [max doubleValue];
    
    id min = [list valueForKeyPath:@"@min.self"];
    double min_x1 = [min doubleValue];
    
    NSInteger m = [self groupNumberOfRespectively:list];
    
    //假设等距分组的组距为d。
    double d;
    
    //根据变量值的取值范围和已确定的组数计算等距分组的组距最小值；
    d = (max_x1 - min_x1)/m;
    
    //在实际分组中，为了使全部变量值都能有组可人，实际的组距只能比此值大，而不能比此值小。比如计算出来是18.3，要19才行。
    // 返回浮点数整数部分,舍弃小数点部分，往个位数进1;
    int d_ceil = ceil(d);
    
    //实践中，通常用5和10的倍数来作组距。
    int d_final = 0;
    int remainder_10 = d_ceil % 10;
    int remainder_5 = d_ceil % 5;
    if(remainder_10 == 0 || remainder_5 == 0)
    {
        d_final = d_ceil;
    }
    else if (remainder_10 > 5)
    {
        d_final = ((d_ceil / 10) +1)*10;
    }
    else if (remainder_10 < 5)
    {
       d_final = ((d_ceil / 5) +1)*5;
    }
    return d_final;
}
@end

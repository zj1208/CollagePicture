//
//  PageModel.h
//  Baby
//
//  Created by simon on 16/1/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "BaseModel.h"

@interface PageModel : BaseModel

//总页数
@property(nonatomic,strong)NSNumber *totalPage;
/**
 *  当页条数
 */
@property(nonatomic,strong)NSNumber * pageSize;

/**
    总条数
 */
@property (nonatomic,strong)NSNumber *totalCount;
/**
 *  当前页
 */
@property(nonatomic,strong)NSNumber * currentPage;


/**
 *  开始条数
 */
@property(nonatomic,strong)NSNumber * startIndex;
/**
 *  结束条数
 */
@property(nonatomic,strong)NSNumber * endIndex;


@end

//
//  AddProductModel.h
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddProductModel : BaseModel
//图片数组[{"p":"原图url",h:12,w:123}]
@property (nonatomic,strong)NSArray *pics;

//产品名称
@property (nonatomic,copy) NSString *name;
//产品标签,逗号分割-"纯铜","不锈钢","加长","加厚"
@property (nonatomic,copy) NSString *labels;
//规格尺寸，逗号分割-
@property (nonatomic,copy) NSString *spec;
//型号
@property (nonatomic,copy) NSString *model;
//介绍
@property (nonatomic,copy) NSString *desc;


//货源类型－1-现货，2-定制
@property (nonatomic, copy) NSNumber *sourceType;
//起订量
@property (nonatomic, copy) NSNumber *minQuantity;   //这2个字段类型不一样
//计价单位-文档写错了
@property (nonatomic, copy) NSString *priceUnit;
//批发价格
@property (nonatomic, copy) NSString *price;


//箱规-4个参数
//整箱体积，带单位 1.5 m^3
@property (nonatomic, strong) NSNumber *volumn;
//整箱重量
@property (nonatomic, strong) NSNumber *weight;
//装箱数量
@property (nonatomic, strong) NSNumber *number;
//装箱数量的单位
@property (nonatomic, copy) NSString *unitInBox;

//是否设为主营产品
@property (nonatomic, assign) BOOL isMain;

//所属类目id
@property (nonatomic,strong) NSNumber *sysCateId;
//类目名称-用于本地业务处理，不用于json解析
@property (nonatomic, copy) NSString *sysCateName;
//用于更新商品－上传id
@property (nonatomic, strong) NSNumber *productId;


//上架/保存为私密产品-true-上架 false-保存为私密产品,编辑的时候没有
@property (nonatomic, assign) BOOL isOnshelve;
//产品状态 0-下架状态 1-上架状态 2-私密状态，编辑的时候才有
@property (nonatomic, strong) NSNumber *status;
@end



@interface AliOSSPicUploadModel : BaseModel

@property (nonatomic) CGFloat h;
@property (nonatomic) CGFloat w;
@property (nonatomic,copy) NSString *p;

@end



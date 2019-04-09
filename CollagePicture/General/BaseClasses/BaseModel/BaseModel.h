//
//  BaseModel.h
//  ICBC
//
//  Created by simon on 15/3/20.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface BaseModel : MTLModel<MTLJSONSerializing>
  
+(NSDictionary*)JSONKeyPathsByPropertyKey;



@end



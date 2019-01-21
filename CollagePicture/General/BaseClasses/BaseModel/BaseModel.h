//
//  BaseModel.h
//  ICBC
//
//  Created by 朱新明 on 15/3/20.
//  Copyright (c) 2015年 朱新明. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface BaseModel : MTLModel<MTLJSONSerializing>
  
+(NSDictionary*)JSONKeyPathsByPropertyKey;



@end



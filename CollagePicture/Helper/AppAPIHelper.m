//
//  AppAPIHelper.m
//  SiChunTang
//
//  Created by simon on 15/6/7.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#import "AppAPIHelper.h"


@interface AppAPIHelper ()
@end


@implementation AppAPIHelper


+ (instancetype)shareInstance
{
    static id sharedHelper = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}


- (instancetype)init {
    self = [super init];
    if (self)
    {
        _userModelAPI             = [[UserModelAPI alloc] init];
//
//        _studioModelAPI           = [[StudioModelAPI alloc] init];
//
//        _oderModelAPI             = [[OderModelAPI alloc] init];
//
//        _makeAlbumModelAPI        = [[MakeAlbumModelAPI alloc] init];
//
//        _messageModelAPI          = [[MessageModelAPI alloc] init];
        
//        _growthModelAPI           = [[GrowthModelAPI alloc] init];
//        _themeModelAPI = [[ThemeModelAPI alloc] init];

    }
    return self;
}


- (UserModelAPI *)getUserModelAPI {
    return _userModelAPI;
}

//
//- (StudioModelAPI *)getStudioModelAPI
//{
//    return _studioModelAPI;
//}
//
//
//- (OderModelAPI *)getoderModelAPI
//{
//    return _oderModelAPI;
//}
//
//
//- (MakeAlbumModelAPI *)getMakeAlbumModelAPI
//{
//    return _makeAlbumModelAPI;
//}
//
//- (MessageModelAPI *)getMessageModelAPI
//{
//    return _messageModelAPI;
//}

//- (GrowthModelAPI *)getGrowthModelAPI
//{
//    return _growthModelAPI;
//}
//
//
//- (ThemeModelAPI *)getThemeModelAPI
//{
//    return _themeModelAPI;
//}
@end

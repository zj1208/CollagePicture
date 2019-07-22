//
//  ZXAssetModel.m
//  FunLive
//
//  Created by simon on 2019/4/28.
//  Copyright © 2019 facebook. All rights reserved.
//

#import "ZXAssetModel.h"

@implementation ZXAssetModel

@end


@implementation ZXAlbumModel

- (void)setResult:(id)result {
    _result = result;
//    BOOL allowPickingImage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tz_allowPickingImage"] isEqualToString:@"1"];
//    BOOL allowPickingVideo = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tz_allowPickingVideo"] isEqualToString:@"1"];
//    [[TZImageManager manager] getAssetsFromFetchResult:result allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage completion:^(NSArray<TZAssetModel *> *models) {
//        _models = models;
//        if (_selectedModels) {
//            [self checkSelectedModels];
//        }
//    }];
}


- (NSString *)title {
    if (_title) {
        return _title;
    }
    return @"";
}

@end

//
//  MakingPhotoController.h
//  Baby
//
//  Created by simon on 16/2/24.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlbumListModel;


@interface MakingPhotoController : UIViewController

//@property(nonatomic,strong) NSNumber *albumId;
@property(nonatomic,copy) NSString *albumTitle;
@property(nonatomic,strong) NSNumber *price;


@property(nonatomic,strong) NSIndexPath *uploadingIndexPath;
@property(nonatomic,strong) NSNumber * albumMakedType;
////添加
//@property(nonatomic,strong)AlbumListModel * model;

@property(nonatomic,strong) NSNumber *templateType;


@property (weak, nonatomic) IBOutlet UIButton *previousPageBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextPageBtn;
@property (weak, nonatomic) IBOutlet UIButton *againMakingBtn;


- (IBAction)againMakingAction:(UIButton *)sender;

- (IBAction)previousPageAction:(UIButton *)sender;

- (IBAction)nextPageAction:(UIButton *)sender;
@end

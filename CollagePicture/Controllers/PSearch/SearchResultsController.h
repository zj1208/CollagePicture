//
//  SearchResultsController.h
//  CollagePicture
//
//  Created by 朱新明 on 2019/10/25.
//  Copyright © 2019 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol SearchResultsControllerDelegate <NSObject>

- (void)textFieldEditingBegainActionWithSearchTitle:(NSString *)searchTitle;

@end

@interface SearchResultsController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (weak, nonatomic) IBOutlet UIButton *carBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, weak)id<SearchResultsControllerDelegate>delegate;

- (IBAction)goBackAction:(UIButton *)sender;
- (IBAction)textFieldEditingBegainAction:(id)sender;

- (void)requestSearchDataWithText:(NSString *)text;

- (IBAction)carBtnAction:(id)sender;

@end

NS_ASSUME_NONNULL_END

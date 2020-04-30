//
//  SearchSuggestionViewController.h
//  CollagePicture
//
//  Created by 朱新明 on 2019/10/25.
//  Copyright © 2019 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXSearchSuggestionDidSelectCellBlock)(NSIndexPath *indexPath,NSString *suggestionTitle);

@interface SearchSuggestionViewController : UITableViewController

@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, copy) NSArray<NSString *> *searchSuggestionsArray;

@property (nonatomic, copy) ZXSearchSuggestionDidSelectCellBlock didSelectCellBlock;


@end

NS_ASSUME_NONNULL_END

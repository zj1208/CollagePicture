//
//  ImageEditView.h
//  Baby
//
//  Created by simon on 16/2/26.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageEditView;
@protocol ImageEditViewPickerDelegate <NSObject>

/**
 *  imageEditView的delegate
 *
 *  @param sender        对应的button
 *  @param imageEditView 对应的imageEditView
 */

- (void)imageEditViewPickerWithButton:(UIButton *)sender editView:(ImageEditView *)imageEditView;

@end

@interface ImageEditView : UIView<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIImageView *imageView;

@property(nonatomic,strong) UIButton *selectBtn;

@property(nonatomic,weak) id<ImageEditViewPickerDelegate>delegate;

@property (nonatomic,assign,getter=isHadImage)BOOL hadImage;

- (void)setImageViewData:(UIImage *)img;


- (void)removePickerBtn;
@end

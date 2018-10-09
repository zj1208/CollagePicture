//
//  ZXPrintPageRenderer.h
//  YiShangbao
//
//  Created by simon on 2018/2/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 Setting SIMPLE_LAYOUT to 1 uses a layout that involves less application code and
 produces a layout where the web view content has margins that are relative to
 the imageable area of the paper.
 
 Setting SIMPLE_LAYOUT to 0 uses a layout that involves more computation and setup
 and produces a layout where the webview content is inset 1/2 from the edge of the
 paper (assuming it can be without being clipped). See the comments in
 APLPrintPageRenderer.m immediately after #if !SIMPLE_LAYOUT.
 */
#define SIMPLE_LAYOUT 1

// The point size to use for the height of the text in the
// header and footer.
#define HEADER_FOOTER_TEXT_HEIGHT     10

// The left edge of text in the header will be offset from the left
// edge of the imageable area of the paper by HEADER_LEFT_TEXT_INSET.
#define HEADER_LEFT_TEXT_INSET        20

// The header and footer will be inset this much from the edge of the
// imageable area just to avoid butting up right against the edge that
// will be clipped.
#define HEADER_FOOTER_MARGIN_PADDING  5

// The right edge of text in the footer will be offset from the right
// edge of the imageable area of the paper by FOOTER_RIGHT_TEXT_INSET.
#define FOOTER_RIGHT_TEXT_INSET       20

#if !SIMPLE_LAYOUT

// The header and footer content will be no closer than this distance
// from the web page content on the printed page.
#define MIN_HEADER_FOOTER_DISTANCE_FROM_CONTENT 10

// Enforce a minimum 1/2 inch margin on all sides.
#define MIN_MARGIN 36

#endif

@interface ZXPrintPageRenderer : UIPrintPageRenderer

@property (nonatomic, copy) NSString *jobTitle;

@property (nonatomic, assign) NSRange pageRange;
@end

//
//  ZXPrintPageRenderer.m
//  YiShangbao
//
//  Created by simon on 2018/2/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXPrintPageRenderer.h"



@implementation ZXPrintPageRenderer

#if !SIMPLE_LAYOUT
/*
 For the case where we are not doing SIMPLE_LAYOUT, this code does the following:
 1) Makes the minimum margin for the content of the content portion of the printout (i.e. the webpage) at least 1/4" away from the edge of the paper. If the hardware margins of the paper are greater than that, then the hardware margins will force the content margins to be as large as they allow.
 2) Because this format is relative to the edge of the sheet rather than the imageable area, we need to compute these values once we know the paper size and printableRect. This is known in the numberOfPages method and that is the reason this code overrides that method.
 3) Since the header and footer heights of a UIPrintFormatter plays a part in determining height of of the content area, this code computes those heights, taking into account that we want the minimum 1/4" margin on the content.
 4) This code also enforces a minimum distance (MIN_HEADER_FOOTER_DISTANCE_FROM_CONTENT) between the header and footer and the content area.
 5) Note that the insets used for the contentInsets property of a UIPrintFormatter are relative to the imageable area of the paper being printed upon. The header and footer height are also imposed relative to the edge of the top and bottom hardware margin.
 */


/*
 Compute an edge inset to produce the minimum margin based on the imageable area margin of the edge.
 */
static inline CGFloat EdgeInset(CGFloat imageableAreaMargin)
{
    /*
     Because the offsets specified to a print formatter are relative to printRect and we want our edges to be at least MIN_MARGIN from the edge of the sheet of paper, here we compute the necessary offset to achieve our margin. If the imageable area margin is larger than our MIN_MARGIN, we return an offset of zero which means that the imageable area margin will be used.
     */
    CGFloat val = MIN_MARGIN - imageableAreaMargin;
    return val > 0 ? val : 0;
}


/*
 Compute a height for the header or footer, based on the margin for the edge in question and the height of the text being drawn.
 */
static CGFloat HeaderFooterHeight(CGFloat imageableAreaMargin, CGFloat textHeight)
{
    /*
     Make the header and footer height provide for a minimum margin of MIN_MARGIN. We want the content to appear at least MIN_HEADER_FOOTER_DISTANCE_FROM_CONTENT from the header/footer text. If that requires a margin > MIN_MARGIN then we'll use that. Remember, the header/footer height returned needs to be relative to the edge of the imageable area.
     */
    CGFloat headerFooterHeight = imageableAreaMargin + textHeight +
    MIN_HEADER_FOOTER_DISTANCE_FROM_CONTENT + HEADER_FOOTER_MARGIN_PADDING;
    if(headerFooterHeight < MIN_MARGIN)
        headerFooterHeight = MIN_MARGIN - imageableAreaMargin;
    else {
        headerFooterHeight -= imageableAreaMargin;
    }
    
    return headerFooterHeight;
}


/*
 Override numberOfPages so we can compute the values for our UIPrintFormatter based on the paper used for the print job. When this is called, self.paperRect and self.printableRect reflect the paper size and imageable area of the destination paper.
 */
- (NSInteger)numberOfPages
{
    // We only have one formatter so obtain it so we can set its paramters.
    UIPrintFormatter *myFormatter = (UIPrintFormatter *)[self.printFormatters objectAtIndex:0];
    
    /*
     Compute insets so that margins are 1/2 inch from edge of sheet, or at the edge of the imageable area if it is larger than that. The EdgeInset function takes a margin for the edge being calculated.
     */
    CGFloat leftInset = EdgeInset(self.printableRect.origin.x);
    CGFloat rightInset = EdgeInset(self.paperRect.size.width - CGRectGetMaxX(self.printableRect));
    
    // Top inset is only used if we want a different inset for the first page and we don't.
    // The bottom inset is never used by a viewFormatter.
    myFormatter.contentInsets = UIEdgeInsetsMake(0, leftInset, 0, rightInset);
    
    // Now compute what we want for the header size and footer size.
    // These determine the size and placement of the content height.
    
    // First compute the title height.
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:HEADER_FOOTER_TEXT_HEIGHT];
    // We'll use the same title height for the header and footer.
    // This is the minimum height the footer can be.
    CGFloat titleHeight = [self.jobTitle sizeWithFont:font].height;
    
    /*
     We want to calculate these heights so that the content top and bottom edges are a minimum distance from the edge of the sheet and are inset at least MIN_HEADER_FOOTER_DISTANCE_FROM_CONTENT from the header and footer.
     */
    self.headerHeight = HeaderFooterHeight(CGRectGetMinY(self.printableRect), titleHeight);
    self.footerHeight = HeaderFooterHeight(self.paperRect.size.height - CGRectGetMaxY(self.printableRect), titleHeight);
    
    // Just to be sure, never allow the content to go past our minimum margins for the content area.
    myFormatter.maximumContentWidth = self.paperRect.size.width - 2*MIN_MARGIN;
    myFormatter.maximumContentHeight = self.paperRect.size.height - 2*MIN_MARGIN;
    
    
    /*
     Let the superclass calculate the total number of pages. Since this UIPrintPageRenderer only uses a UIPrintFormatter, the superclass knows the number of pages based on the formatter metrics and the paper/printable rects.
     
     Note that since this code only uses a single print formatter we could just as easily use myFormatter.pageCount to obtain the total number of pages. But it would be more complex than that if we had multiple printformatters for our job so we're using a more general approach here for illustration and it is correct for 1 or more formatters.
     */
    return [super numberOfPages];
}

#endif

/*
 Our pages don't have any intrinsic notion of page number; our footer will number the pages so that users know the order. So for us, we will always render the first page printed as page 1, even if the range is n-m. So we track which page in the range is the first index as well as the total length of our range.
 */
- (void)prepareForDrawingPages:(NSRange)range
{
    _pageRange = range;
    [super prepareForDrawingPages:range];
}


- (void)drawHeaderForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)headerRect
{
    if(self.jobTitle){
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:HEADER_FOOTER_TEXT_HEIGHT];
        // Position the title starting from the left and inset slightly from the left edge of the imageable area.
        CGFloat startX = CGRectGetMinX(headerRect) + HEADER_LEFT_TEXT_INSET;
        /*
         The header will always be a fixed amount inset from edge of the the imageable area of the paper.
         The point passed to drawAtPoint is at the top-left of the text that will be drawn, hence the starting point is the y coordinate of the top of the imageable area rect plus any padding.
         */
        CGFloat startY = self.printableRect.origin.y + HEADER_FOOTER_MARGIN_PADDING;
        CGPoint startPoint = CGPointMake(startX, startY);
        [self.jobTitle drawAtPoint:startPoint withAttributes:@{NSFontAttributeName:font}];
    }
}


- (void)drawFooterForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)footerRect
{
    NSString *localizedPageNumberString = NSLocalizedString(@"Page %d of %d", @"Page Count String");
    /*
     Compute the page numbers so that the first page in the range being printed is always page 1 of N, where N is the total number of pages.
     */
    NSString *pageNumberString = [NSString stringWithFormat:localizedPageNumberString,
                                  pageIndex+1 - _pageRange.location, _pageRange.length];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:HEADER_FOOTER_TEXT_HEIGHT];
    CGSize pageNumSize = [pageNumberString sizeWithAttributes:@{NSFontAttributeName:font}];
    /*
     Position the page number string so that it ends inset by FOOTER_RIGHT_TEXT_INSET from the right edge of the imageable area.
     */
    CGFloat startX = CGRectGetMaxX(footerRect) - pageNumSize.width - FOOTER_RIGHT_TEXT_INSET;
    /*
     The footer will always be a fixed amount inset from the bottom edge of the imageable area of the paper.
     The point passed to drawAtPoint is the top-left of the text that will be drawn, hence the height needs to be subtracted from the starting point.
     */
    CGFloat startY = CGRectGetMaxY(self.printableRect) - pageNumSize.height - HEADER_FOOTER_MARGIN_PADDING;
    CGPoint startPoint = CGPointMake(startX, startY);
    
    [pageNumberString drawAtPoint:startPoint withAttributes:@{NSFontAttributeName:font}];
}
@end

//
//  UIScrollView+FWTOverlay.m
//  FWTClockKit_Test
//
//  Created by Marco Meschini on 24/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "UIScrollView+FWTOverlayView.h"
#import "FWTOverlayScrollViewHelper.h"
#import <objc/runtime.h>

@implementation UIScrollView (FWTRelativeContentOffset)

- (CGPoint)fwt_relativeContentOffset
{
    return [self fwt_relativeContentOffsetNormalized:NO];
}

- (CGPoint)fwt_relativeContentOffsetNormalized:(BOOL)normalized
{
    CGPoint toReturn = CGPointZero;
    CGSize contentSize = self.contentSize;
    CGSize frameSize = self.frame.size;
    CGPoint contentOffset = self.contentOffset;
    CGSize workingSize = (CGSize){contentSize.width-frameSize.width, contentSize.height-frameSize.height};
    toReturn.x = isnan(contentOffset.x/workingSize.width) ? .0f : contentOffset.x/workingSize.width;
    toReturn.y = isnan(contentOffset.y/workingSize.height) ? .0f : contentOffset.y/workingSize.height;
    if (normalized)
    {
        toReturn.x = MAX(toReturn.x, .0f);
        toReturn.x = MIN(toReturn.x, 1.0f);
        toReturn.y = MAX(toReturn.y, .0f);
        toReturn.y = MIN(toReturn.y, 1.0f);
    }
    
    return toReturn;
}

- (void)setFwt_relativeContentOffset:(CGPoint)fwt_relativeContentOffset
{
    
}

@end

static char overlayHelperKey;

@interface UIScrollView (FWTOverlayView_Private)
@property (nonatomic, retain) FWTOverlayScrollViewHelper *fwt_overlayHelper;
@end

@implementation UIScrollView (FWTOverlayView)

#pragma mark - Private
- (FWTOverlayScrollViewHelper *)_getAssociatedScrollViewHelperAndInitIfNeeded:(BOOL)value
{
    FWTOverlayScrollViewHelper *helper = objc_getAssociatedObject(self, &overlayHelperKey);
    if (!helper && value)
    {
        helper = [[[FWTOverlayScrollViewHelper alloc] initWithScrollView:self] autorelease];
        objc_setAssociatedObject(self, &overlayHelperKey, helper, OBJC_ASSOCIATION_RETAIN);
    }
    
    return helper;
}

#pragma mark - Public
- (void)setFwt_overlayView:(UIView *)fwt_overlayView
{
    if (fwt_overlayView)
    {
        FWTOverlayScrollViewHelper *helper = [self _getAssociatedScrollViewHelperAndInitIfNeeded:YES];
        helper.overlayView = fwt_overlayView;
    }
    else
    {
       objc_setAssociatedObject(self, &overlayHelperKey, nil, OBJC_ASSOCIATION_RETAIN);
    }
}

- (UIView *)fwt_overlayView
{
    FWTOverlayScrollViewHelper *helper = [self _getAssociatedScrollViewHelperAndInitIfNeeded:NO];
    return helper.overlayView;
}

- (void)setFwt_overlayViewEdgeInsets:(UIEdgeInsets)fwt_edgeInsets
{
    FWTOverlayScrollViewHelper *helper = [self _getAssociatedScrollViewHelperAndInitIfNeeded:YES];
    helper.edgeInsets = fwt_edgeInsets;
}

- (UIEdgeInsets)fwt_overlayViewEdgeInsets
{
    FWTOverlayScrollViewHelper *helper = [self _getAssociatedScrollViewHelperAndInitIfNeeded:NO];
    return helper.edgeInsets;
}

- (void)setFwt_overlayViewFlexibleMargin:(UIViewAutoresizing)fwt_overlayViewFlexibleMargin
{
    FWTOverlayScrollViewHelper *helper = [self _getAssociatedScrollViewHelperAndInitIfNeeded:YES];
    helper.flexibleMargin = fwt_overlayViewFlexibleMargin;
}

- (UIViewAutoresizing)fwt_overlayViewFlexibleMargin
{
    FWTOverlayScrollViewHelper *helper = [self _getAssociatedScrollViewHelperAndInitIfNeeded:NO];
    return helper.flexibleMargin;
}

- (void)setFwt_overlayViewHideAfterDelay:(CGFloat)fwt_hideAfterDelay
{
    FWTOverlayScrollViewHelper *helper = [self _getAssociatedScrollViewHelperAndInitIfNeeded:YES];
    helper.hideAfterDelay = fwt_hideAfterDelay;
}

- (CGFloat)fwt_overlayViewHideAfterDelay
{
    FWTOverlayScrollViewHelper *helper = [self _getAssociatedScrollViewHelperAndInitIfNeeded:NO];
    return helper.hideAfterDelay;
}

- (FWTOverlayLayoutBlock)fwt_layoutBlock
{
    FWTOverlayScrollViewHelper *helper = [self _getAssociatedScrollViewHelperAndInitIfNeeded:NO];
    return helper.layoutBlock;
}

- (void)setFwt_layoutBlock:(FWTOverlayLayoutBlock)fwt_layoutBlock
{
    FWTOverlayScrollViewHelper *helper = [self _getAssociatedScrollViewHelperAndInitIfNeeded:YES];
    helper.layoutBlock = fwt_layoutBlock;
}

- (FWTOverlayDismissBlock)fwt_dismissBlock
{
    FWTOverlayScrollViewHelper *helper = [self _getAssociatedScrollViewHelperAndInitIfNeeded:NO];
    return helper.dismissBlock;
}

- (void)setFwt_dismissBlock:(FWTOverlayDismissBlock)fwt_dismissBlock
{
    FWTOverlayScrollViewHelper *helper = [self _getAssociatedScrollViewHelperAndInitIfNeeded:YES];
    helper.dismissBlock = fwt_dismissBlock;
}

@end

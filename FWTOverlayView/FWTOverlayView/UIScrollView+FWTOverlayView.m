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

static char overlayHelperKey;

@interface UIScrollView ()
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

- (CGPoint)fwt_overlayViewCenter
{
    return self.fwt_overlayView.center;
}

@end

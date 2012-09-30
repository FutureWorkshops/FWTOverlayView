//
//  UIScrollView+FWTOverlay.h
//  FWTClockKit_Test
//
//  Created by Marco Meschini on 24/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _FWTScrollViewDirection
{
    FWTScrollViewDirectionNone,
    FWTScrollViewDirectionVertical,
    FWTScrollViewDirectionHorizontal,
} FWTScrollViewDirection;

@interface UIScrollView (FWTOverlayView)

@property (nonatomic, retain) UIView *fwt_overlayView;
@property (nonatomic, assign) UIEdgeInsets fwt_overlayViewEdgeInsets;
@property (nonatomic, assign) CGFloat fwt_overlayViewHideAfterDelay;
@property (nonatomic, readonly, assign) CGPoint fwt_overlayViewCenter;

@property (nonatomic, readonly, assign) CGFloat fwt_contentOffsetPercentage;
- (CGFloat)fwt_contentOffsetPercentageClampEnabled:(BOOL)clampEnabled;

@property (nonatomic, readonly, assign) FWTScrollViewDirection fwt_scrollDirection;

@end

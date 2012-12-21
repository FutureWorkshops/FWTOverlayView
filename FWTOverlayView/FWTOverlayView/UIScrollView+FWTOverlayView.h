//
//  UIScrollView+FWTOverlay.h
//  FWTClockKit_Test
//
//  Created by Marco Meschini on 24/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWTOverlayBlockDefinitions.h"

@interface UIScrollView (FWTRelativeContentOffset)

@property (nonatomic) CGPoint fwt_relativeContentOffset;
- (CGPoint)fwt_relativeContentOffsetNormalized:(BOOL)normalized;

@end


@interface UIScrollView (FWTOverlayView)

//  configure
@property (nonatomic, retain) UIView *fwt_overlayView;
@property (nonatomic, assign) UIEdgeInsets fwt_overlayViewEdgeInsets;
@property (nonatomic, assign) UIViewAutoresizing fwt_overlayViewFlexibleMargin;
@property (nonatomic, assign) CGFloat fwt_overlayViewHideAfterDelay;
@property (nonatomic, copy) FWTOverlayLayoutBlock fwt_layoutBlock;
@property (nonatomic, copy) FWTOverlayDismissBlock fwt_dismissBlock;

@end

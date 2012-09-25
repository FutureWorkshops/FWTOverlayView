//
//  UIScrollView+FWTOverlay.h
//  FWTClockKit_Test
//
//  Created by Marco Meschini on 24/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (FWTOverlayView)

@property (nonatomic, retain) UIView *fwt_overlayView;
@property (nonatomic, assign) UIEdgeInsets fwt_overlayViewEdgeInsets;
@property (nonatomic, assign) CGFloat fwt_overlayViewHideAfterDelay;
@property (nonatomic, readonly, assign) CGPoint fwt_overlayViewCenter;

@end

//
//  ScrollViewHelper.h
//  FWTClockKit_Test
//
//  Created by Marco Meschini on 24/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FWTOverlayBlockDefinitions.h"

//  This is a private class. You can access its properties through the UIScrollView (FWTOverlay) category. 
//
//
@interface FWTOverlayScrollViewHelper : NSObject

@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGFloat hideAfterDelay;
@property (nonatomic, assign) UIViewAutoresizing flexibleMargin;
@property (nonatomic, copy) FWTOverlayLayoutBlock layoutBlock;
@property (nonatomic, copy) FWTOverlayDismissBlock dismissBlock;

- (id)initWithScrollView:(UIScrollView *)scrollView;

@end

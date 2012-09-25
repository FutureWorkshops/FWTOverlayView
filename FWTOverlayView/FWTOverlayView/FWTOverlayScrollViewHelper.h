//
//  ScrollViewHelper.h
//  FWTClockKit_Test
//
//  Created by Marco Meschini on 24/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//  This is a private class. You can access its properties through the UIScrollView (FWTOverlay) category. 
//
//
@interface FWTOverlayScrollViewHelper : NSObject

@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGFloat hideAfterDelay;

- (id)initWithScrollView:(UIScrollView *)scrollView;

@end

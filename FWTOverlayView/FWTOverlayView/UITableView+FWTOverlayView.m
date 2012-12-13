//
//  UITableView+FWTOverlay.m
//  FWTClockKit_Test
//
//  Created by Marco Meschini on 25/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "UITableView+FWTOverlayView.h"
#import "FWTOverlayScrollViewHelper.h"

@implementation UITableView (FWTOverlayView)

- (NSIndexPath *)fwt_overlayViewIndexPath
{
    UIView *overlayView = self.fwt_overlayView;
    if (overlayView)
    {
        if (self.contentOffset.y < 0)
        {
            NSArray *vr = [self indexPathsForVisibleRows];
            if (vr.count > 0)
                return [vr objectAtIndex:0];
        }
        else if (self.contentOffset.y >= (self.contentSize.height-CGRectGetHeight(self.bounds)))
        {
            NSArray *vr = [self indexPathsForVisibleRows];
            if (vr.count > 0)
                return [vr lastObject];
        }
        else
        {
            return [self indexPathForRowAtPoint:overlayView.center];
        }
    }
    return nil;
}

@end

//
//  UITableView+FWTOverlay.m
//  FWTClockKit_Test
//
//  Created by Marco Meschini on 25/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "UITableView+FWTOverlayView.h"
#import "FWTOverlayScrollViewHelper.h"

@interface UIScrollView ()
- (FWTOverlayScrollViewHelper *)_getAssociatedScrollViewHelperAndInitIfNeeded:(BOOL)value;
@end

@implementation UITableView (FWTOverlayView)

- (NSIndexPath *)fwt_overlayViewIndexPath
{
    FWTOverlayScrollViewHelper *helper = [self _getAssociatedScrollViewHelperAndInitIfNeeded:NO];
    if (helper)
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
            return [self indexPathForRowAtPoint:helper.overlayView.center];
        }
    }
    return nil;
}

@end

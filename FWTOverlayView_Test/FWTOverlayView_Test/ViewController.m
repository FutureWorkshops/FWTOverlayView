//
//  ViewController.m
//  FWTOverlayView_Test
//
//  Created by Marco Meschini on 25/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "ViewController.h"
#import "OverlayView.h"
#import "UIScrollView+FWTOverlayView.h"

@interface ViewController () <UIScrollViewDelegate>
@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    
    UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:self.view.bounds] autorelease];
    scrollView.autoresizingMask = self.view.autoresizingMask;
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.frame), 3000.0f);
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    scrollView.fwt_overlayView = [[[OverlayView alloc] initWithFrame:CGRectMake(.0f, .0f, 70.0f, 30.0f)] autorelease];
    scrollView.fwt_overlayViewEdgeInsets = UIEdgeInsetsMake(2.0f, .0f, 2.0f, 10.0f);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat maxTableHeight = scrollView.contentSize.height;
    CGFloat frameTableHeight = scrollView.frame.size.height;
    CGFloat workingTableHeight = maxTableHeight - frameTableHeight;
    CGFloat currentTablePosition = scrollView.contentOffset.y;
    CGFloat currentTablePositionPercentage = currentTablePosition / workingTableHeight;
    
    OverlayView *overlayView = (OverlayView *)scrollView.fwt_overlayView;
    overlayView.textLabel.text = [NSString stringWithFormat:@"%f", currentTablePositionPercentage];
}

@end

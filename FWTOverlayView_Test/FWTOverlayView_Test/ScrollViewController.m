//
//  ViewController.m
//  FWTOverlayView_Test
//
//  Created by Marco Meschini on 25/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "ScrollViewController.h"
#import "OverlayView.h"
#import "UIScrollView+FWTOverlayView.h"

@interface ScrollViewController () <UIScrollViewDelegate>
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) CGSize contentSize;
@end

@implementation ScrollViewController

- (void)dealloc
{
    self.scrollView = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    self.scrollView = [[[UIScrollView alloc] initWithFrame:self.view.bounds] autorelease];
    self.scrollView.autoresizingMask = self.view.autoresizingMask;
    self.scrollView.contentSize = self.contentSize;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    OverlayView *overlayView = [[[OverlayView alloc] initWithFrame:CGRectMake(.0f, .0f, 70.0f, 30.0f)] autorelease];
    overlayView.textLabel.numberOfLines = 0;
    self.scrollView.fwt_overlayView = overlayView;
    
    if (self.contentSize.width > self.contentSize.height)
        self.scrollView.fwt_overlayViewEdgeInsets = UIEdgeInsetsMake(2.0f, 2.0f, .0f, 2.0f);
    else
        self.scrollView.fwt_overlayViewEdgeInsets = UIEdgeInsetsMake(2.0f, .0f, 2.0f, 10.0f);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scrollView flashScrollIndicators];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat percentage = [scrollView fwt_contentOffsetPercentageClampEnabled:NO];
    OverlayView *overlayView = (OverlayView *)scrollView.fwt_overlayView;
    overlayView.textLabel.text = [NSString stringWithFormat:@"%f", percentage];
}

+ (id)scrollViewControllerWithContentSize:(CGSize)contentSize
{
    ScrollViewController *toReturn = [[[ScrollViewController alloc] init] autorelease];
    toReturn.contentSize = contentSize;
    toReturn.title = contentSize.width > contentSize.height ? @"horizontal" : @"vertical";
    return toReturn;
}

@end

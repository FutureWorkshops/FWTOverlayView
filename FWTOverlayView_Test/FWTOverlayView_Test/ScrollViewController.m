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
    
    OverlayView *overlayView = [[[OverlayView alloc] initWithFrame:CGRectMake(.0f, .0f, 80.0f, 34.0f)] autorelease];
    overlayView.textLabel.numberOfLines = 0;
    self.scrollView.fwt_overlayView = overlayView;
    
    CGSize viewSize = self.view.frame.size;
    if (self.contentSize.width > viewSize.width && self.contentSize.height > viewSize.height)
    {
//        self.scrollView.fwt_overlayViewEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 200.0f, 200.0f);
    }
    else if (self.contentSize.width > self.view.frame.size.width)
    {
        self.scrollView.fwt_overlayViewEdgeInsets = UIEdgeInsetsMake(2.0f, 2.0f, 10.0f, 2.0f);
//        self.scrollView.fwt_overlayViewFlexibleMargin = UIViewAutoresizingFlexibleTopMargin;
    }
    else if (self.contentSize.height > viewSize.height)
    {
        self.scrollView.fwt_overlayViewEdgeInsets = (UIEdgeInsets){2.0f, 2.0f, 2.0f, 10.0f};
        self.scrollView.fwt_overlayViewFlexibleMargin = UIViewAutoresizingFlexibleLeftMargin;

    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scrollView flashScrollIndicators];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint relativeContentOffset = [scrollView fwt_relativeContentOffsetNormalized:NO];
    OverlayView *overlayView = (OverlayView *)scrollView.fwt_overlayView;
    overlayView.textLabel.text = [NSString stringWithFormat:@"%@", NSStringFromCGPoint(relativeContentOffset)];
}

+ (id)scrollViewControllerWithContentSize:(CGSize)contentSize title:(NSString *)title
{
    ScrollViewController *toReturn = [[[ScrollViewController alloc] init] autorelease];
    toReturn.contentSize = contentSize;
    toReturn.title = title;
//    toReturn.title = contentSize.width > contentSize.height ? @"horizontal" : @"vertical";
    return toReturn;
}

@end

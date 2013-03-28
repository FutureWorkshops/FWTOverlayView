//
//  AppDelegate.m
//  FWTOverlayView_Test
//
//  Created by Marco Meschini on 25/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "AppDelegate.h"
#import "SamplePickerViewController.h"
#import "ScrollViewController.h"
#import "TableViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *vc0 = [ScrollViewController scrollViewControllerWithContentSize:CGSizeMake(320.0f, 3000.0f) title:@"vertical"];
    UIViewController *vc1 = [ScrollViewController scrollViewControllerWithContentSize:CGSizeMake(3000.0f, 400) title:@"horizontal"];
    UIViewController *vc2 = [[[TableViewController alloc] init] autorelease];
    
    //
    RistrettoTableViewController *rootViewController = [[[RistrettoTableViewController alloc] init] autorelease];
    NSArray *samples = @[[RistrettoSampleDescriptor descriptorWithTitle:@"vertical" instance:vc0],
                         [RistrettoSampleDescriptor descriptorWithTitle:@"horizontal" instance:vc1],
                         [RistrettoSampleDescriptor descriptorWithTitle:@"table" instance:vc2],
                         ];
    rootViewController.items = samples;
    rootViewController.title = @"FWTOverlayView";
    
    //
    UIView *headerView = [[[UIView alloc] initWithFrame:(CGRect){.0f, .0f, 240.0f, 200.0f}] autorelease];
    [rootViewController setTableHeaderView:headerView insets:(UIEdgeInsets){58.0f, 40.0f, 45.0f, 40.0f}];
    
    UIImageView *iconView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_overlayview.png"]] autorelease];
    iconView.center = CGPointMake(CGRectGetMidX(headerView.bounds), iconView.center.y);
    [headerView addSubview:iconView];
    
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.text = @"Choose a sample:";
    label.font = [UIFont Ristretto_lightFontOfSize:18.0f];
    label.textColor = [UIColor Ristretto_darkGrayColor];
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetMidX(headerView.bounds), CGRectGetHeight(headerView.bounds)-CGRectGetHeight(label.bounds)*.5f);
    [headerView addSubview:label];
    
    self.window.rootViewController = [UINavigationController Ristretto_navigationControllerWithRootViewController:rootViewController];
    
//    self.window.rootViewController = [RistrettoTableViewController navigationControllerWithRootViewController:rootViewController];
    
//    self.window.rootViewController = [[[UINavigationController alloc] initWithRootViewController:[[[SamplePickerViewController alloc] init] autorelease]] autorelease];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

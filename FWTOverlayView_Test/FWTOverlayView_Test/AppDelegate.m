//
//  AppDelegate.m
//  FWTOverlayView_Test
//
//  Created by Marco Meschini on 25/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "AppDelegate.h"
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
    self.window.backgroundColor = [UIColor whiteColor];
    
    //
    UIViewController *vc0 = [ScrollViewController scrollViewControllerWithContentSize:CGSizeMake(320.0f, 3000.0f) title:@"vertical"];
    UIViewController *vc1 = [ScrollViewController scrollViewControllerWithContentSize:CGSizeMake(3000.0f, 400) title:@"horizontal"];
    UIViewController *vc2 = [[[TableViewController alloc] init] autorelease];
    NSArray *samples = @[[RistrettoSampleDescriptor descriptorWithTitle:@"vertical" instance:vc0],
                         [RistrettoSampleDescriptor descriptorWithTitle:@"horizontal" instance:vc1],
                         [RistrettoSampleDescriptor descriptorWithTitle:@"table" instance:vc2],
                         ];
    RistrettoTableViewController *rootViewController = [[[RistrettoTableViewController alloc] init] autorelease];
    rootViewController.items = samples;

    //
    self.window.rootViewController = [UINavigationController Ristretto_navigationControllerWithRootViewController:rootViewController
                                                                                             defaultHeaderEnabled:YES];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end

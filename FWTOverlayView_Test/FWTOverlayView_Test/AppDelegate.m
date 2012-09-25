//
//  AppDelegate.m
//  FWTOverlayView_Test
//
//  Created by Marco Meschini on 25/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "AppDelegate.h"
#import "SamplePickerViewController.h"

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
    self.window.backgroundColor = [UIColor colorWithWhite:.8f alpha:1.0f];
    self.window.rootViewController = [[[UINavigationController alloc] initWithRootViewController:[[[SamplePickerViewController alloc] init] autorelease]] autorelease];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

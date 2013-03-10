//
//  RotationAppDelegate.m
//  HeavyRotation
//
//  Created by Leo Gau on 3/9/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "RotationAppDelegate.h"
#import "HeavyViewController.h"

@implementation RotationAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Get the device object
    UIDevice *device = [UIDevice currentDevice];
    
    // Tell it to start monitoring the accelerometer for orientation
    [device beginGeneratingDeviceOrientationNotifications];
    
    [device setProximityMonitoringEnabled:YES];
    
    // Get the notification center for the app
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    // Add yourself as an observer
    [nc addObserver:self
           selector:@selector(orientationChanged:)
               name:UIDeviceOrientationDidChangeNotification
             object:device];
    
    [nc addObserver:self
           selector:@selector(proximity)
               name:UIDeviceProximityStateDidChangeNotification
             object:device];
    
    HeavyViewController *hvc = [[HeavyViewController alloc] init];
    self.window.rootViewController = hvc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)orientationChanged: (NSNotification *)note
{
    // Log the constant that represents the current orientation
    NSLog(@"orientationChanged: %d", [[note object] orientation]);
}

- (void)proximity
{
    NSLog(@"proximity changed");
}

@end

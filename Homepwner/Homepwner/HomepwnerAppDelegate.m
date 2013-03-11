//
//  HomepwnerAppDelegate.m
//  Homepwner
//
//  Created by Leo Gau on 3/9/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "HomepwnerAppDelegate.h"
#import "ItemsViewController.h"

@implementation HomepwnerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Create a ItemsViewController
    ItemsViewController *itemsViewController = [[ItemsViewController alloc] init];
    
    // Create an instance of a UINavigationController
    // its stack contains only itemsViewController
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];
    
    // Place navigation controller's view in the window hierarchy
    self.window.rootViewController = navController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end

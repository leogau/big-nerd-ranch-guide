//
//  AppDelegate.m
//  TouchTracker
//
//  Created by Leo Gau on 3/14/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "AppDelegate.h"
#import "TouchViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    TouchViewController *tvc = [[TouchViewController alloc] init];
    
    self.window.rootViewController = tvc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
#ifdef VIEW_DEBUG
    NSLog(@"%@", [self.window performSelector:@selector(recursiveDescription)]);
#endif
    
    return YES;
}

@end

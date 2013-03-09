//
//  HypnosisterAppDelegate.m
//  Hypnosister
//
//  Created by Leo Gau on 3/7/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "HypnosisterAppDelegate.h"
#import "HypnosisView.h"
#import "BNRLogoView.h"

@implementation HypnosisterAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    CGRect screenRect = self.window.bounds;
    
    // Create the UIScrollView to have the size of the window, matching its size
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 5.0;
    scrollView.delegate = self;
    [self.window addSubview:scrollView];
    
    self.view = [[HypnosisView alloc] initWithFrame:screenRect];
    [scrollView addSubview:self.view];
        
    // Tell the scrollView how big its virtual world is
    [scrollView setContentSize:screenRect.size];
    
    CGRect logoRect = CGRectMake(10, 10, 114, 114);
    BNRLogoView *logoView = [[BNRLogoView alloc] initWithFrame:logoRect];
    [self.view addSubview:logoView];
    
    BOOL success = [self.view becomeFirstResponder];
    if (success) {
        NSLog(@"HypnosisView became the first responder");
    } else {
        NSLog(@"Could not become first responder");
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.view;
}

@end

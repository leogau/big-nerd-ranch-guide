//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Leo Gau on 3/20/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@end

@implementation WebViewController

- (void)loadView
{
    // Create an instance of UIWebView as large as the screen
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:screenFrame];
    
    // Tell web view to scale web content to fit within the bounds of webview
    webView.scalesPageToFit = YES;
    self.view = webView;
}

- (UIWebView *)webView
{
    return (UIWebView *)self.view;
}

@end

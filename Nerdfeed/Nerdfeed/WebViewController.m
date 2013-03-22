//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Leo Gau on 3/20/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "WebViewController.h"
#import "RSSItem.h"

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

#pragma mark - ListViewControllerDelegate

- (void)listViewController:(ListViewController *)listViewController handleObject:(id)object
{
    // Cast the passed object to RSSItem
    RSSItem *entry = object;
    
    // Make sure that we are really getting a RSSItem
    if (![entry isKindOfClass:[RSSItem class]]) {
        return;
    }
    
    // Grab the info from the item and push it into the appropriate views
    NSURL *url = [NSURL URLWithString:entry.link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    self.navigationItem.title = entry.title;
}

#pragma mark - UISplitViewDelegate

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    // If this bar button item doesn't have a title, it won't
    // appear at all
    barButtonItem.title = @"List";
    
    // Take this bar button item and put it on the left side of our nav item
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Remove the bar button item from our navigation item
    // We'll double check that its the correct button, even though we know it is
    if (barButtonItem == self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

@end

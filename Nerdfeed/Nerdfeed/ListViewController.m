//
//  ListViewController.m
//  Nerdfeed
//
//  Created by Leo Gau on 3/19/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "ListViewController.h"
#import "RSSChannel.h"
#import "RSSItem.h"
#import "WebViewController.h"
#import "ChannelViewController.h"
#import "BNRFeedStore.h"

@interface ListViewController ()
@property (nonatomic, strong) RSSChannel *channel;
@property (nonatomic) ListViewControllerRSSType rssType;
@end

@implementation ListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleBordered target:self action:@selector(showInfo:)];
        self.navigationItem.rightBarButtonItem = bbi;
        
        UISegmentedControl *rssTypeControl = [[UISegmentedControl alloc] initWithItems:@[@"BNR", @"Apple"]];
        rssTypeControl.selectedSegmentIndex = 0;
        rssTypeControl.segmentedControlStyle = UISegmentedControlStyleBar;
        [rssTypeControl addTarget:self
                           action:@selector(changeType:)
                 forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = rssTypeControl;
                                            
        
        [self fetchEntries];
    }
    
    return self;
}

#pragma mark - Instance

- (void)fetchEntries
{
    // Get a hold of the segmented control that is currently in the title view
    UIView *currentTitleView = self.navigationItem.titleView;
    
    // Create an activity indicator and start it spinning in the nav bar
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.navigationItem.titleView = aiView;
    [aiView startAnimating];
    
    void (^completionBlock)(RSSChannel *obj, NSError *err) = ^(RSSChannel *obj, NSError *err) {
        NSLog(@"Completion block called");
        // When the request completes - success or failure - replace the
        // activity indicator with the segmented control
        self.navigationItem.titleView = currentTitleView;
        
        // When the request completes, this block will be called
        if (!err) {
            // If everything went ok, grab the channel object, and reload the table
            self.channel = obj;
            [self.tableView reloadData];
        } else {
            // If things went bad, show an alert view
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:[err localizedDescription]
                                                        delegate: nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [av show];
        }
    };
    
    // Initiate the request...
    if (self.rssType == ListViewControllerRSSTypeBNR) {
        self.channel = [[BNRFeedStore sharedStore] fetchRSSFeedWithCompletion:^(RSSChannel *obj, NSError *error) {
            // Replace the activity indicator
            self.navigationItem.titleView = currentTitleView;
            if (!error) {
                // How many items are there currently?
                int currentItemCount = [self.channel.items count];
                
                // Set our channel to the merged one
                self.channel = obj;
                
                // How many items are there now?
                int newItemCount = [self.channel.items count];
                
                // For each new item, insert a new row. The data source
                // will take care of the rest.
                int itemDelta = newItemCount - currentItemCount;
                if (itemDelta > 0) {
                    NSMutableArray *rows = [NSMutableArray array];
                    for (int i = 0; i < itemDelta; i++) {
                        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
                        [rows addObject:ip];
                    }
                    [self.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];
                }
            }
        }];
        
        [self.tableView reloadData];
    } else if (self.rssType == ListViewControllerRSSTypeApple) {
        [[BNRFeedStore sharedStore] fetchTopSongs:10 withCompletion:completionBlock];
    }
    
    NSLog(@"Executing code at the end of fetchEntries");

}

- (void)changeType:(UISegmentedControl *)sender
{
    self.rssType = sender.selectedSegmentIndex;
    [self fetchEntries];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.channel.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    RSSItem *item = self.channel.items[indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Push the web view controller onto the navigation stack -
    // this implicitly create the web view controller's view the first time through
    if (![self splitViewController]) {
        [self.navigationController pushViewController:self.webViewController animated:YES];
    } else {
        // We have to create a new navigation controller, as the old
        // one was only retained by the split view controller and
        // is now gone
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.webViewController];
        NSArray *vcs = @[self.navigationController, nav];
        self.splitViewController.viewControllers = vcs;
        
        // Make the detail view controller the delegate of the split view controller
        self.splitViewController.delegate = self.webViewController;
    }

    // Grab the selected item
    RSSItem *entry = self.channel.items[indexPath.row];
    
    [self.webViewController listViewController:self handleObject:entry];
}

#pragma mark - IBAction

- (void)showInfo:(id)sender
{
    // Create the channel view controller
    ChannelViewController *channelViewController = [[ChannelViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    if ([self splitViewController]) {
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:channelViewController];
        
        // Create the array with our nav controller and this new
        // VC's nav controller
        NSArray *vcs = @[self.navigationController, nvc];
        
        // Grab a pointer to the split view controller
        // and reset its view controllers array
        [[self splitViewController] setViewControllers:vcs];
        
        // Make detail view controller the delegate of the split view controller
        [[self splitViewController] setDelegate:channelViewController];
        
        // If a row has been selected, deselect it so that a row
        // is not selected when viewing the info
        NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
        if (selectedRow) {
            [self.tableView deselectRowAtIndexPath:selectedRow animated:YES];
        }
    } else {
        [self.navigationController pushViewController:channelViewController animated:YES];
    }
    
    // Give the VC the channel object through the protocol message
    [channelViewController listViewController:self handleObject:self.channel];
}

@end

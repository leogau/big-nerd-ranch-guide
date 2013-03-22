//
//  ChannelViewController.m
//  Nerdfeed
//
//  Created by Leo Gau on 3/21/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "ChannelViewController.h"
#import "RSSChannel.h"

@implementation ChannelViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"UITableViewCell"];
    }
    
    if (indexPath.row == 0) {
        // Put the title of the channel in row 0
        cell.textLabel.text = @"Title";
        cell.detailTextLabel.text = self.channel.title;
    } else {
        // Put the description of the channel in row 1
        cell.textLabel.text = @"Info";
        cell.detailTextLabel.text = self.channel.infoString;
    }
    return cell;
}

#pragma mark - ListViewControllerDelegate

- (void)listViewController:(ListViewController *)listViewController handleObject:(id)object
{
    // Make sure the ListViewController gave us the right object
    if (![object isKindOfClass:[RSSChannel class]]) {
        return;
    }
    
    self.channel = object;
    
    [self.tableView reloadData];
}

#pragma mark - UISplitViewDelegate

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"List";
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if (barButtonItem == self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

@end

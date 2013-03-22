//
//  ChannelViewController.h
//  Nerdfeed
//
//  Created by Leo Gau on 3/21/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"

@class RSSChannel;

@interface ChannelViewController : UITableViewController    <ListViewControllerDelegate, UISplitViewControllerDelegate>

@property (nonatomic, strong) RSSChannel *channel;

@end

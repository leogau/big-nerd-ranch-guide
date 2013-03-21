//
//  ListViewController.h
//  Nerdfeed
//
//  Created by Leo Gau on 3/19/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebViewController;

@interface ListViewController : UITableViewController <NSURLConnectionDataDelegate, NSXMLParserDelegate>

@property (nonatomic, strong) WebViewController *webViewController;

@end

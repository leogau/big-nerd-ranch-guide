//
//  ListViewController.h
//  Nerdfeed
//
//  Created by Leo Gau on 3/19/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ListViewControllerRSSTypeBNR,
    ListViewControllerRSSTypeApple
} ListViewControllerRSSType;

@class WebViewController;

@interface ListViewController : UITableViewController

@property (nonatomic, strong) WebViewController *webViewController;

@end

@protocol ListViewControllerDelegate <NSObject>

- (void)listViewController:(ListViewController *)listViewController
              handleObject:(id)object;

@end
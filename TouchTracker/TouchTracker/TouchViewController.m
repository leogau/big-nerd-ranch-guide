//
//  TouchViewController.m
//  TouchTracker
//
//  Created by Leo Gau on 3/14/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "TouchViewController.h"
#import "TouchDrawView.h"

@implementation TouchViewController

- (void)loadView
{
    self.view = [[TouchDrawView alloc] initWithFrame:CGRectZero];
}

@end

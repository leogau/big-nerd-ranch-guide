//
//  ImageViewController.m
//  Homepwner
//
//  Created by Leo Gau on 3/14/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize sz = [self.image size];
    self.scrollView.contentSize = sz;
    self.imageView.frame = CGRectMake(0, 0, sz.width, sz.height);
    self.imageView.image = self.image;
}

@end

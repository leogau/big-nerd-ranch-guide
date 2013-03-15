//
//  ImageViewController.h
//  Homepwner
//
//  Created by Leo Gau on 3/14/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@end

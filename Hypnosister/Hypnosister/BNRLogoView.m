//
//  BNRLogoView.m
//  Hypnosister
//
//  Created by Leo Gau on 3/9/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "BNRLogoView.h"

@implementation BNRLogoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Icon@2x.png"]];
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    // Use CGContextClip to create a circle
//    // set the image to ICON
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGCOntextCli
//    
//}

@end

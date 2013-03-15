//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Leo Gau on 3/12/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell

- (IBAction)showImage:(UIButton *)sender
{
    // Get the name of the method, "showImage:"
    NSString *selector = NSStringFromSelector(_cmd);
    
    // make selector "showImage:atIndexPath:"
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    // Prepare a selector from this string
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [self.cellTableView indexPathForCell:self];
    if (indexPath) {
        if ([self.controller respondsToSelector:newSelector]) {
            [self.controller performSelector:newSelector withObject:sender withObject:indexPath];
        }
    }
}

@end

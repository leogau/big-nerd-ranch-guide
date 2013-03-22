//
//  BNRExecutor.m
//  Blocky
//
//  Created by Leo Gau on 3/21/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "BNRExecutor.h"

@implementation BNRExecutor

- (int)computeWithValue:(int)value1 andValue:(int)value2
{
    // If a block variable is executed but doesn't point at a block,
    // it will crash - return 0 if there is no block
    if (!self.equation) return 0;
    
    // Return value of block with value1 and value2
    return self.equation(value1, value2);
}

- (void)dealloc
{
    NSLog(@"Executor is being destroyed.");
}

@end

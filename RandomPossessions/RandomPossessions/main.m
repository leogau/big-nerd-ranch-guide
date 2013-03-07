//
//  main.m
//  RandomPossessions
//
//  Created by Leo Gau on 3/6/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {

        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        BNRItem *backpack = [[BNRItem alloc] init];
        backpack.itemName = @"Backpack";
        [items addObject:backpack];
        
        BNRItem *calculator = [[BNRItem alloc] init];
        calculator.itemName = @"Calculator";
        [items addObject:calculator];
        
        backpack.containedItem = calculator;
        
        NSLog(@"Setting items to nil...");
        items = nil;
    }
    
    return 0;
}


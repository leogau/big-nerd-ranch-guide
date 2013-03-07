//
//  BNRContainer.m
//  RandomPossessions
//
//  Created by Leo Gau on 3/6/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "BNRContainer.h"

@implementation BNRContainer

- (int)valueInDollars
{
    int total = 0;
    for (BNRItem *item in self.subitems) {
        total += item.valueInDollars;
    }
    return total;
}

- (NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"%@: Items: %@ Total value: %d", self.itemName, self.subitems, self.valueInDollars];
    return descriptionString;
}

@end

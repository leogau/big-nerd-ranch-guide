//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Leo Gau on 3/9/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemStore ()
@property (nonatomic) NSMutableArray *allItems;
@end

@implementation BNRItemStore

- (id)init
{
    self = [super init];
    if (self) {
        self.allItems = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Class

+ (BNRItemStore *)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

#pragma mark - Instance

- (NSArray *)allItems
{
    return _allItems;
}

- (BNRItem *)createItem
{
    BNRItem *item = [BNRItem randomItem];
    [_allItems addObject:item];
    return item;
}

@end

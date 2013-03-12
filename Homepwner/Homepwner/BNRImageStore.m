//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Leo Gau on 3/10/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()
@property (nonatomic) NSMutableDictionary *dictionary;
@end

@implementation BNRImageStore

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (BNRImageStore *)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    if (!sharedStore) {
        // Create the singleton
        sharedStore = [[super allocWithZone:NULL] init];
    }
    return sharedStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Instance

- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
    self.dictionary[s] = i;
}

- (UIImage *)imageForKey:(NSString *)s
{
    return self.dictionary[s];
}

- (void)deleteImageForKey:(NSString *)s
{
    if (!s) {
        return;
    }
    [self.dictionary removeObjectForKey:s];
}

@end

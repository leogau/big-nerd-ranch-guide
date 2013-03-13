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
    
    // Create full path for image
    NSString *imagePath = [self imagePathForKey:s];
    
    // Turn image into JPEG data
    NSData *d = UIImagePNGRepresentation(i);

    // Write it to full path
    [d writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)s
{
    // If possible, get it from the dictionary
    UIImage *result = self.dictionary[s];
    if (!result) {
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        
        // If we found an image on the file system, place it into the cache
        if (result) {
            self.dictionary[s] = result;
        } else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:s]);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)s
{
    if (!s) {
        return;
    }
    [self.dictionary removeObjectForKey:s];
    
    NSString *filePath = [self imagePathForKey:s];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories lastObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}

@end

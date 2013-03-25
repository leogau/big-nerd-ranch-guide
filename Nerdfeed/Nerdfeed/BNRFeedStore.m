//
//  BNRFeedStore.m
//  Nerdfeed
//
//  Created by Leo Gau on 3/24/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "BNRFeedStore.h"
#import "RSSChannel.h"
#import "BNRConnection.h"
#import "RSSItem.h"

@implementation BNRFeedStore
@synthesize topSongsCacheDate = _topSongsCacheDate;

- (id)init
{
    self = [super init];
    if (self) {
        self.model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        
        NSError *error = nil;
        NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        dbPath = [dbPath stringByAppendingPathComponent:@"feed.db"];
        NSURL *dbURL = [NSURL fileURLWithPath:dbPath];
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:dbURL
                                     options:nil
                                       error:&error]) {
            [NSException raise:@"Open failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.context = [[NSManagedObjectContext alloc] init];
        [self.context setPersistentStoreCoordinator:psc];
        [self.context setUndoManager:nil];
    }
    return self;
}

#pragma mark - Properties

- (void)setTopSongsCacheDate:(NSDate *)topSongsCacheDate
{
    [[NSUserDefaults standardUserDefaults] setObject:_topSongsCacheDate forKey:@"topSongsCacheDate"];
}

- (NSDate *)topSongsCacheDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"topSongsCacheDate"];
}

#pragma mark - Class

+ (BNRFeedStore *)sharedStore
{
    static BNRFeedStore *feedStore = nil;
    if (!feedStore) {
        feedStore = [[BNRFeedStore alloc] init];
    }
    return feedStore;
}

#pragma mark - Instance

- (RSSChannel *)fetchRSSFeedWithCompletion:(void (^)(RSSChannel *, NSError *))block
{
    NSURL *url = [NSURL URLWithString:@"http://forums.bignerdranch.com/"
                        @"smartfeed.php?limit=1_DAY&sort_by=standard"
                        @"&feed_type=RSS2.0&feed_style=COMPACT"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create an empty channel
    RSSChannel *channel = [[RSSChannel alloc] init];
    
    // Create a connection "actor" object that will transfer data from the server
    BNRConnection *connection = [[BNRConnection alloc] initWithRequest:request];
    
    // When the connection completes, this block from the controller will be called
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    cachePath = [cachePath stringByAppendingPathComponent:@"nerd.archive"];
    
    // Load the cached channel
    RSSChannel *cachedChannel = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    
    // If one hasn't already been cached, create a blank one to fill up
    if (!cachedChannel) {
        cachedChannel = [[RSSChannel alloc] init];
    }
    
    RSSChannel *channelCopy = [cachedChannel copy];
    
    connection.completionBlock = ^(RSSChannel *obj, NSError *error) {
        // This is the store' callback code
        if (!error) {
            [channelCopy addItemsFromChannel:obj];
            [NSKeyedArchiver archiveRootObject:channelCopy toFile:cachePath];
        }
            
        // This is the controller's callback code
        block(cachedChannel, error);
    };
    
    
    // Let the empty channel parse the returning data from the web service
    connection.xmlRootObject = channel;
    
    // Begin the connection
    [connection start];
    
    return cachedChannel;
}

- (void)fetchTopSongs:(int)count withCompletion:(void (^)(RSSChannel *, NSError *))block
{
    // Construct the cache path
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    cachePath = [cachePath stringByAppendingPathComponent:@"apple.archive"];
    
    // Make sure we have cached at least once before by cheching to see if the date exists
    NSDate *tscDate = self.topSongsCacheDate;
    if (tscDate) {
        // How old is the cache?
        NSTimeInterval cacheAge = [tscDate timeIntervalSinceNow];
        
        if (cacheAge > -300.0) {
            // If it is less than 300 seconds old, return cache
            NSLog(@"Returning cache!");
            RSSChannel *cachedChannel = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
            if (cachedChannel) {
                // Execute the controller's completion block to reload its table
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    block(cachedChannel, nil);
                }];

                // Don't need to make the request, just get out of this method
                return;
            }
        }
    }
    
    // Prepare a request URL, including the argument from the controller
    NSString *requestString = [NSString stringWithFormat:@"http://itunes.apple.com/us/rss/topsongs"
                               @"/limit=%d/json", count];
    
    NSURL *url = [NSURL URLWithString:requestString];
    
    // Set up the connection as normal
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RSSChannel *channel = [[RSSChannel alloc] init];
    
    BNRConnection *connection = [[BNRConnection alloc] initWithRequest:request];
    connection.jsonRootObject = channel;
    
    connection.completionBlock = ^(RSSChannel *obj, NSError *err) {
        // This is the store's completion code.
        // If everything went smoothly, save the channel to disk and set cache date
        if (!err) {
            self.topSongsCacheDate = [NSDate date];
            [NSKeyedArchiver archiveRootObject:obj toFile:cachePath];
        }
        
        // This is the controller's completion code
        block(obj, err);
    };
    
    [connection start];
}

- (void)markItemAsRead:(RSSItem *)item
{
    // If the item is already in Core Data, no need for duplicates
    if ([self hasItemBeenRead:item]) {
        return;
    }
    
    // Create a new Link object and insert it into the context
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Link" inManagedObjectContext:self.context];
    
    // Set the Link's urlString from the RSSItem
    [obj setValue:item.link forKey:@"urlString"];
    
    // immediately save the changes
    [self.context save:nil];
}

- (BOOL)hasItemBeenRead:(RSSItem *)item
{
    // Create a request to fetch all Link's with the same urlString as this item's link
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Link"];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"urlString like %@", item.link];
    [request setPredicate:pred];
    
    // If there is at least 1 Link, then this item has been read before
    NSArray *entities = [self.context executeFetchRequest:request error:nil];
    if ([entities count] > 0) {
        return YES;
    }
    
    // If Core Data has never seen this link, then it hasn't been read
    return NO;
}


@end

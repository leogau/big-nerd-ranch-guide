//
//  BNRFeedStore.h
//  Nerdfeed
//
//  Created by Leo Gau on 3/24/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RSSChannel;
@class RSSItem;

@interface BNRFeedStore : NSObject

@property (nonatomic, strong) NSDate *topSongsCacheDate;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

+ (BNRFeedStore *)sharedStore;

- (RSSChannel *)fetchRSSFeedWithCompletion:(void (^) (RSSChannel *obj, NSError *err)) block;
- (void)fetchTopSongs:(int)count withCompletion:(void (^)(RSSChannel *obj, NSError *error))block;
- (void)markItemAsRead:(RSSItem *)item;
- (BOOL)hasItemBeenRead:(RSSItem *)item;

@end

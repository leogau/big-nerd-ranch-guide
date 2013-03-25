//
//  BNRFeedStore.h
//  Nerdfeed
//
//  Created by Leo Gau on 3/24/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSSChannel;

@interface BNRFeedStore : NSObject

+ (BNRFeedStore *)sharedStore;

- (RSSChannel *)fetchRSSFeedWithCompletion:(void (^) (RSSChannel *obj, NSError *err)) block;
- (void)fetchTopSongs:(int)count withCompletion:(void (^)(RSSChannel *obj, NSError *error))block;

@property (nonatomic, strong) NSDate *topSongsCacheDate;

@end

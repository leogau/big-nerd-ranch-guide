//
//  RSSChannel.m
//  Nerdfeed
//
//  Created by Leo Gau on 3/20/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "RSSChannel.h"
#import "RSSItem.h"

@interface RSSChannel ()
@property (nonatomic, strong) NSMutableString *currentString;
@end

@implementation RSSChannel

- (id)init
{
    self = [super init];
    if (self) {
        // Create the container for the RSSItems this channel has;
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqualToString:@"title"]) {
        self.currentString = [[NSMutableString alloc] init];
        self.title = self.currentString;
    } else if ([elementName isEqualToString:@"description"]) {
        self.currentString = [[NSMutableString alloc] init];
        self.infoString = self.currentString;
    } else if ([elementName isEqualToString:@"item"] ||
               [elementName isEqualToString:@"entry"]) {
        // When we find an item, create an instance of RSSItem
        RSSItem *entry = [[RSSItem alloc] init];
        
        // Set up its parent as ourselves so we can regain control
        // of the parser
        entry.parentParserDelegate = self;
        
        // Turn the parser to the RSSItem
        parser.delegate = entry;
        
        // Add the item to our array and release our hold on it
        [self.items addObject:entry];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // If we were in an element that we were collecting the string for,
    // this appropriately releases our hold on it and the permanent ivar keeps
    // ownership of it. If we weren't parsing such an element, currentString
    // is nil already.
    self.currentString = nil;
    
    // If the element that ended was the channel, give up control to
    // who gave us control in the first place
    if ([elementName isEqualToString:@"channel"]) {
        parser.delegate = self.parentParserDelegate;
        [self trimItemTitle];
    }
}

#pragma mark - Instance

- (void)trimItemTitle
{
    // Create a regular expression with the pattern: Author
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@".* :: (.*) :: .*"
                                                                      options:0
                                                                        error:nil];
    // Loop through every title of the items in channel
    for (RSSItem *item in self.items) {
        NSString *itemTitle = item.title;
        
        // Find matches in the title string. The range argument specifies how much
        // of the title to search; in this case, all of it
        NSArray *matches = [regex matchesInString:itemTitle
                                          options:0
                                            range:NSMakeRange(0, [itemTitle length])];
        
        // If there was a match...
        if ([matches count] > 0) {
            // Print the location of the match in the string
            NSTextCheckingResult *result = matches[0];
            NSRange r = [result range];
            NSLog(@"Match at {%d, %d} for %@!", r.location, r.length, itemTitle);
            
            // One capture group, so two ranges, let's verify
            if ([result numberOfRanges] == 2) {
                // Pull out the 2nd range, which will be the capture group
                NSRange r = [result rangeAtIndex:1];
                
                // Set the title of the item to the string within the capture group
                item.title = [itemTitle substringWithRange:r];
            }
        }
    }
}

- (void)addItemsFromChannel:(RSSChannel *)otherChannel
{
    for (RSSItem *item in otherChannel.items) {
        // If self's items does not contain this item, add it
        if (![self.items containsObject:item]) {
            [self.items addObject:item];
        }
    }
    
    // Sort the array of items by publication date
    [self.items sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 publicationDate] compare:[obj1 publicationDate]];
    }];
}

#pragma mark - JSONSerializable

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    // The top-level object contains a "feed" object, which is the channel
    NSDictionary *feed = d[@"feed"];
    
    // The feed has a title property, make this the title of our channel
    self.title = feed[@"title"];
    
    // The feed also has an array of entries, for each one, make a new RSSItem
    NSArray *entries = feed[@"entry"];
    for (NSDictionary *entry in entries) {
        RSSItem *item = [[RSSItem alloc] init];
        
        // Pass the entry dictionary to the item so it can grab its ivars
        [item readFromJSONDictionary:entry];
        [self.items addObject:item];
    }
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.items forKey:@"items"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.infoString forKey:@"infoString"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _items = [aDecoder decodeObjectForKey:@"items"];
        self.infoString = [aDecoder decodeObjectForKey:@"infoString"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    RSSChannel *c = [[[self class] alloc] init];
    
    c.title = self.title;
    c.infoString = self.infoString;
    c->_items = [self.items mutableCopy];
    
    return c;
}

@end

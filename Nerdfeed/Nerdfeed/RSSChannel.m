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
    } else if ([elementName isEqualToString:@"item"]) {
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
    }
}

@end

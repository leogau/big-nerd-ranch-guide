//
//  RSSItem.m
//  Nerdfeed
//
//  Created by Leo Gau on 3/20/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "RSSItem.h"

@interface RSSItem ()
@property (nonatomic, strong) NSMutableString *currentString;
@end

@implementation RSSItem

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"\t\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqualToString:@"title"]) {
        self.currentString = [[NSMutableString alloc] init];
        self.title = self.currentString;
    } else if ([elementName isEqualToString:@"link"]) {
        self.currentString = [[NSMutableString alloc] init];
        self.link = self.currentString;
    } else if ([elementName isEqualToString:@"pubDate"]) {
        // Create the string, but do not put it into an ivar yet
        self.currentString = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // If the pubDate ends, use a date formatter to turn it into an NSDate
    if ([elementName isEqualToString:@"pubDate"]) {
        static NSDateFormatter *dateFormatter = nil;
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, dd MM yyyy HH:mm:ss z"];
        }
        self.publicationDate = [dateFormatter dateFromString:self.currentString];
    }
    
    self.currentString = nil;
    
    if ([elementName isEqualToString:@"item"] ||
        [elementName isEqualToString:@"entry"]) {
        parser.delegate = self.parentParserDelegate;
    }
}

#pragma mark - JSONSerializable

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    self.title = d[@"title"][@"label"];
    
    // Inside each entry is an array of links, each has an attribute object
    NSArray *links = d[@"link"];
    if ([links count] > 1) {
        NSDictionary *sampleDict = links[1][@"attributes"];
        
        // The href of an attribute object is the URL for the sample audio file
        self.link = sampleDict[@"href"];
    }
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.link forKey:@"link"];
    [aCoder encodeObject:self.publicationDate forKey:@"publicationDate"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.link = [aDecoder decodeObjectForKey:@"link"];
        self.publicationDate = [aDecoder decodeObjectForKey:@"publicationDate"];
    }
    return self;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    // Make sure we are comparing an RSSItem!
    if (![object isKindOfClass:[RSSItem class]]) {
        return NO;
    }
    
    return [self.link isEqual:[object link]];
}

@end

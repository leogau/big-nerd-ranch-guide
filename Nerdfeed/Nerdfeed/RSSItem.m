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
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    self.currentString = nil;
    
    if ([elementName isEqualToString:@"item"]) {
        parser.delegate = self.parentParserDelegate;
    }
}

@end

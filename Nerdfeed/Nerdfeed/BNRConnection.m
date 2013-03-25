//
//  BNRConnection.m
//  Nerdfeed
//
//  Created by Leo Gau on 3/24/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "BNRConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@interface BNRConnection ()
@property (nonatomic, strong) NSURLConnection *internalConnection;
@property (nonatomic, strong) NSMutableData *container;
@end

@implementation BNRConnection

- (id)initWithRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

#pragma mark - Instance

- (void)start
{
    // Initialize container for data collected from NSURLConnection
    self.container = [[NSMutableData alloc] init];
    
    // Spawn connection
    self.internalConnection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES];
    
    // If this is the first connection started, create the array
    if (!sharedConnectionList) {
        sharedConnectionList = [[NSMutableArray alloc] init];
    }
    
    // Add the connection to the array so it doesn't get destroyed
    [sharedConnectionList addObject:self];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.container appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    id rootObject = nil;
    // If there is a "root object"
    if (self.xmlRootObject) {
        // Create a parser with the incoming data and let the root object parse its contents
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.container];
        parser.delegate = self.xmlRootObject;
        [parser parse];
        rootObject = self.xmlRootObject;
    } else if (self.jsonRootObject) {
        // Turn JSON data into basic model objects
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:self.container options:0 error:nil];
        
        // Have the root object construct itself from basic model objects
        [self.jsonRootObject readFromJSONDictionary:d];
        
        rootObject = self.jsonRootObject;
    }
    
    // Then, pass the root object to the completion block -
    // remember, this is the block that the controller supplied
    if (self.completionBlock) {
        self.completionBlock(rootObject, nil);
    }
    
    // Now, destroy this connection
    [sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Pass the error from the connection to the completionBlock
    if (self.completionBlock) {
        self.completionBlock(nil, error);
    }
    
    // Destroy this connection
    [sharedConnectionList removeObject:self];
}

@end

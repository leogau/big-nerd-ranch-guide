//
//  ListViewController.m
//  Nerdfeed
//
//  Created by Leo Gau on 3/19/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "ListViewController.h"
#import "RSSChannel.h"
#import "RSSItem.h"
#import "WebViewController.h"

@interface ListViewController ()
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *xmlData;
@property (nonatomic, strong) RSSChannel *channel;
@end

@implementation ListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self fetchEntries];
    }
    
    return self;
}

#pragma mark - Instance

- (void)fetchEntries
{
    // Create a new data container for the stuff that comes back from the service
    self.xmlData = [[NSMutableData alloc] init];
    
    // Construct a URL that will ask the service for what you want
    // note we can concatenate literal strings together on multiple
    // lines in this way - this results in a single NSString instance
    NSURL *url = [NSURL URLWithString:@"http://forums.bignerdranch.com/smartfeed.php?"
                  @"limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];
    
    // For Apple's Hot News feed, replace the line above with
    // NSURL *url = [NSURL URLWithString:@"http://www.apple.com/pr/feeds/pr.rss"];
    
    // Put that URL into a NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create a connection that will exchange this request for data from the URL
    self.connection = [[NSURLConnection alloc] initWithRequest:request
                                                      delegate:self
                                              startImmediately:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.channel.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    RSSItem *item = self.channel.items[indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Push the web view controller onto the navigation stack -
    // this implicitly create the web view controller's view the first time through
    [self.navigationController pushViewController:self.webViewController animated:YES];

    // Grab the selected item
    RSSItem *entry = self.channel.items[indexPath.row];
    
    // Construct a URL with the link string of the item
    NSURL *url = [NSURL URLWithString:entry.link];
    
    // Construct a request object with that URL
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Load the request into the web view
    [self.webViewController.webView loadRequest:request];
    
    // Set the title of the web view controller's navigation item
    self.webViewController.navigationItem.title = entry.title;
}

#pragma mark - NSURLConnectionDataDelegate

// This method will be called serveral times as the data arrives
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Add the incoming chunk of data to the container we are keeping
    // The data always comes in the correct order
    [self.xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Create the parser object with the data received from the web service
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.xmlData];
    
    // Give it a delegate
    parser.delegate = self;
    
    // Tell it to start parsing - the document will be parsed and
    // the delegate of NSXMLParser will get all of its delegate messages
    // sent to it before this line finishes execution - it is blocking
    [parser parse];
    
    // Get rid of the XML data as we no longer need it
    self.xmlData = nil;
    
    // Get rid of the connection, no longer need it
    self.connection = nil;
    
    // Reload the table. For now, the table will be empty.
    [self.tableView reloadData];
    
    NSLog(@"%@\n %@\n %@\n", self.channel, self.channel.title, self.channel.infoString);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Release the connection object, we're done with it
    self.connection = nil;
    
    // Release the xmlData object, we're done with it
    self.xmlData = nil;
    
    // Grab the description of the error object passed to us
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    
    // Create and show an alert view with this error displayed
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:errorString
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"%@ found a %@ element", self, elementName);
    if ([elementName isEqualToString:@"channel"]) {
        // If the parser saw a channel, create new instance
        self.channel = [[RSSChannel alloc] init];
        
        // Give the channel object a point back to ourselves for later
        self.channel.parentParserDelegate = self;
        
        // Set the parser's delegate to the channel object
        parser.delegate = self.channel;
    }
}

@end
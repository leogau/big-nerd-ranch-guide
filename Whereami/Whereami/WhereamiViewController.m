//
//  WhereamiViewController.m
//  Whereami
//
//  Created by Leo Gau on 3/6/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "WhereamiViewController.h"

@interface WhereamiViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *worldView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *locationTitleField;

@end

@implementation WhereamiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Create location manager object
        self.locationManager = [[CLLocationManager alloc] init];
        
        // Set the locationManager's delegate to self
        self.locationManager.delegate = self;
        
        // And we want it to be as accurate as possible
        // regardless of how much time/power it takes
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        // Tell our manager to start looking for its location immediately
        [self.locationManager startUpdatingLocation];
        
        // Start updateing heading
        [self.locationManager startUpdatingHeading];
    }
    
    return self;
}

- (void)dealloc
{
    // Tell the location manager to stop sending us messages
    self.locationManager.delegate = nil;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations) {
        NSLog(@"%@", location);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"%@", newHeading);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

@end

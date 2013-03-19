//
//  WhereamiViewController.m
//  Whereami
//
//  Created by Leo Gau on 3/6/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "WhereamiViewController.h"
#import "BNRMapPoint.h"

@interface WhereamiViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *worldView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *locationTitleField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeControl;

@end

NSString * const WhereamiMapTypePrefKey = @"WhereamiMapTypePrefKey";

@implementation WhereamiViewController

+ (void)initialize
{
    NSDictionary *defaults = @{WhereamiMapTypePrefKey: @1};
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

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
    }
    
    return self;
}

- (void)dealloc
{
    // Tell the location manager to stop sending us messages
    self.locationManager.delegate = nil;
}

#pragma mark - ViewController

- (void)viewDidLoad
{
    self.worldView.showsUserLocation = YES;
    
    NSInteger mapTypeValue = [[NSUserDefaults standardUserDefaults] integerForKey:WhereamiMapTypePrefKey];
    
    // Update the UI
    self.mapTypeControl.selectedSegmentIndex = mapTypeValue;
    
    // Update the map
    [self changeMapType:self.mapTypeControl];
}

#pragma mark - IBActions

- (IBAction)changeMapType:(UISegmentedControl *)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex
                                               forKey:WhereamiMapTypePrefKey];
    
    NSInteger selected = sender.selectedSegmentIndex;
    switch (selected) {
        case 0:
            self.worldView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.worldView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.worldView.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations lastObject];
    // How many seconds ago was this new location created?
    NSTimeInterval t = [[loc timestamp] timeIntervalSinceNow];
    
    // CLLocationManagers will return the last found location of the
    // device first, you don't wan that data in this case.
    // If this location was made more than 3 minutes ago, ignore it.
    if (t < -180) {
        // This is cached data, you don't want it, keep looking
        return;
    }
    
    [self foundLocation:loc];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"%@", newHeading);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [self.worldView setRegion:region animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self findLocation];
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - private

- (void)findLocation
{
    [self.locationManager startUpdatingLocation];
    [self.activityIndicator startAnimating];
    [self.locationTitleField setHidden:YES];
}

- (void)foundLocation:(CLLocation *)loc
{
    CLLocationCoordinate2D coord = [loc coordinate];

    // Get formatted date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *subtitle = [dateFormatter stringFromDate:[NSDate date]];
    
    // Create an instance of BNRMapPoint with the current data
    BNRMapPoint *mp = [[BNRMapPoint alloc] initWithCoordinate:coord title:self.locationTitleField.text subtitle:subtitle];
    

    
    // Add it to the map view
    [self.worldView addAnnotation:mp];
    
    // Zoom the region to this location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [self.worldView setRegion:region animated:YES];
    
    // Reset the UI
    self.locationTitleField.text = @"";
    [self.activityIndicator stopAnimating];
    self.locationTitleField.hidden = NO;
    [self.locationManager stopUpdatingLocation];
}

@end

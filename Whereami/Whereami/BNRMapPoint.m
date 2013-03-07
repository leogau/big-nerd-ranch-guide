//
//  BNRMapPoint.m
//  Whereami
//
//  Created by Leo Gau on 3/7/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "BNRMapPoint.h"

@interface BNRMapPoint ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end

@implementation BNRMapPoint 

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.coordinate = c;
        self.title = title;
    }
    
    return self;
}

- (id)init
{
    return [self initWithCoordinate:CLLocationCoordinate2DMake(43.07, -89.32) title:@"Hometown"];
}

@end

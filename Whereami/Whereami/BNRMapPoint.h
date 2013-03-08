//
//  BNRMapPoint.h
//  Whereami
//
//  Created by Leo Gau on 3/7/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface BNRMapPoint : NSObject <MKAnnotation>

- (id)initWithCoordinate:(CLLocationCoordinate2D)c
                   title:(NSString *)title
                subtitle:(NSString *)subtitle;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end

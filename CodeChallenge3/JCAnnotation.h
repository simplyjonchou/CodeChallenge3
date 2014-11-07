//
//  JCAnnotation.h
//  CodeChallenge3
//
//  Created by Jonathan Chou on 11/7/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface JCAnnotation : MKPointAnnotation

@property CLLocationCoordinate2D coord;

- (instancetype)initWithCoord:(CLLocationCoordinate2D)coord;
@end

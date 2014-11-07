//
//  JCAnnotation.m
//  CodeChallenge3
//
//  Created by Jonathan Chou on 11/7/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "JCAnnotation.h"

@implementation JCAnnotation

- (instancetype)initWithCoord:(CLLocationCoordinate2D)coord
{
    self = [super init];
    self.coord = coord;
    return self;
}

@end

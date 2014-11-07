//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()
@property NSDictionary *stationDictionary;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self zoomToBikeLocation];
    // Do any additional setup after loading the view.
}

- (void)setInitialValues:(NSDictionary *)stationDictionary
{
    self.stationDictionary = stationDictionary;
}

- (void)zoomToBikeLocation{
    
    NSNumber *latitude = self.stationDictionary[@"latitude"];  //declares lat/long of bike stop
    NSNumber *longitude = self.stationDictionary[@"longitude"];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    
    [self pinBikeLocation:coord]; //pins bike location
    
    MKCoordinateSpan coordinateSpan; //sets coordinate span / zooms to user
    coordinateSpan.latitudeDelta = .05;
    coordinateSpan.longitudeDelta = .05;
    MKCoordinateRegion region = MKCoordinateRegionMake(coord, coordinateSpan);
    [self.mapView setRegion:region];
    

}

- (void)pinBikeLocation:(CLLocationCoordinate2D)coord{

    
    
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
        pointAnnotation.coordinate = coord;
        [self.mapView addAnnotation:pointAnnotation];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{

    //sets pin image and callout
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.image = [UIImage imageNamed:@"bikeImage"] ;
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    
    return pin;
}

@end

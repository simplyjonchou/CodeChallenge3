//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import "JCAnnotation.h"
#import <MapKit/MapKit.h>
@import CoreLocation;

@interface MapViewController ()
@property NSDictionary *stationDictionary;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self zoomToBikeLocation];
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    
    
    [self.mapView setShowsUserLocation:YES];
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
    coordinateSpan.latitudeDelta = .5;
    coordinateSpan.longitudeDelta = .5;
    MKCoordinateRegion region = MKCoordinateRegionMake(coord, coordinateSpan);
    [self.mapView setRegion:region];
    
    
}

- (void)pinBikeLocation:(CLLocationCoordinate2D)coord{
    
    
    
    JCAnnotation *jonAnnotation = [[JCAnnotation alloc] initWithCoord:coord];
    jonAnnotation.coordinate = coord;
    jonAnnotation.title = self.stationDictionary[@"stationName" ];
    [self.mapView addAnnotation:jonAnnotation];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if([annotation isEqual:[mapView userLocation]]) //checks to see if annotation is user location
    {
        return nil;
    }
    //sets pin image and callout
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.image = [UIImage imageNamed:@"bikeImage"] ;
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    
    return pin;
}

- (void) displayAlertWithDirections:(NSString *)directions{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Directions from your current location:" message:directions preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    JCAnnotation *annotation = view.annotation;
    
    //setting source and destination for directions calculation
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:annotation.coord addressDictionary:nil];
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *destination = [[MKMapItem alloc]initWithPlacemark:placemark];
    [self findDirectionsFrom:source
                          to:destination];
}

- (void)findDirectionsFrom:(MKMapItem *)source
                        to:(MKMapItem *)destination
{
    //provide loading animation here
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc]init];
    
    
    [directionsRequest setSource:source];
    [directionsRequest setDestination:destination];
    
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    directionsRequest.destination = destination;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        NSArray *routes = response.routes;
        MKRoute *route = routes.firstObject;
        
        int x = 1;
        NSMutableString *directionString = [NSMutableString string];
        for(MKRouteStep *step in route.steps){
            [directionString appendFormat:@"%d: %@\n",x,step.instructions];
            x++;
        }
        [self displayAlertWithDirections: directionString];
    }];
    
}



@end

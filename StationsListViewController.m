//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//
@import CoreLocation;
#import "StationsListViewController.h"
#import "MapViewController.h"
#define kURL @"http://www.bayareabikeshare.com/stations/json"


@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *stationListArray;
@property NSMutableArray *filteredStationListArray;
@property BOOL filterUsed;
@property CLLocationManager *locationManager;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stationListArray = [@[] mutableCopy];
    self.filteredStationListArray = [@[] mutableCopy];
    self.filterUsed = NO;
    self.searchBar.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    
    
    
    
    
    NSURL *url = [NSURL URLWithString:kURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *stationListDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.stationListArray = stationListDictionary[@"stationBeanList"];
        [self.tableView reloadData];
    }];
}

#pragma mark - UISearchView

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    self.filterUsed = YES;
    [self.filteredStationListArray removeAllObjects];

    for(NSDictionary *stationListDictionary in self.stationListArray)
    {
        NSString *stationName = stationListDictionary[@"stationName"];
        if([stationName containsString:searchBar.text])
        {
            [self.filteredStationListArray addObject:stationListDictionary];
        }
        
    }
    if([searchBar.text isEqualToString: @""]){
        self.filterUsed = NO;
    }
    [self.tableView reloadData];
}



#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // TODO:
        if(!self.filterUsed){
    return self.stationListArray.count;
        }
    else
    {
        return self.filteredStationListArray.count;

    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSMutableDictionary *stationDictionary = [NSMutableDictionary dictionary];
    if(!self.filterUsed){
        stationDictionary = self.stationListArray[indexPath.row];
    }
    else{
        stationDictionary = self.filteredStationListArray[indexPath.row];
        
    }
    NSString *stationName = stationDictionary[@"stationName"];
    NSNumber *bikesAvailable = stationDictionary[@"availableDocks"];
    cell.textLabel.text = stationName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Bikes Available: %@", bikesAvailable];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MapViewController *mapVC = segue.destinationViewController;
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    
    [mapVC setInitialValues:self.stationListArray[selectedIndexPath.row]];
    
}

//-(void)sortTableViewByDistance
//{
////    [self.]
//    [self.stationListArray sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(id obj1, id obj2) {
////        for(NSDictionary *stationListDictionary in self.stationListArray){
//
//
//        NSDictionary *d1 = obj1;
//        NSDictionary *d2 = obj2;
//        NSNumber *latitude = d1[@"latitude"];  //declares lat/long of bike stop
//        NSNumber *longitude = d1[@"longitude"];
//        
//        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
//        CLLocation *currentLocation = self.locationManager.location;
//        if ( //distance comparison ) {
//            return (NSComparisonResult)NSOrderedAscending;
//        } else if ( //distancecomparison ) {
//            return (NSComparisonResult)NSOrderedDescending;
//        }
//        return (NSComparisonResult)NSOrderedSame;
//    }];
//
//    
//}

@end

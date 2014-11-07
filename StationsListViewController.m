//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "MapViewController.h"
#define kURL @"http://www.bayareabikeshare.com/stations/json"

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *stationListArray;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stationListArray = [@[] mutableCopy];

    
    
    
    NSURL *url = [NSURL URLWithString:kURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *stationListDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.stationListArray = stationListDictionary[@"stationBeanList"];
        [self.tableView reloadData];
    }];
}


#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // TODO:
    return self.stationListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *stationDictionary = self.stationListArray[indexPath.row];
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

@end

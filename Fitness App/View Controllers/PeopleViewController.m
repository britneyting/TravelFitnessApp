//
//  PeopleViewController.m
//  Fitness App
//
//  Created by britneyting on 7/17/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "PeopleViewController.h"
#import "PeopleCell.h"
#import <MapKit/MapKit.h>
#import "PeopleDetailsViewController.h"

@interface PeopleViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *nearbyPeople;

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchData];
        
    // code for activity indicator (refresh)
    self.refreshControl = [[UIRefreshControl alloc] init]; // do self refreshControl instead of UIRefreshControl *refreshControl since we already declared the variable refreshControl in properties
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0]; // inserts the activity indicator at index0 (before the first tweet)
}

- (void)fetchData {
    
    [self.activityIndicator startAnimating];
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"%@", currentUser[@"coordinates"]);
    
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"coordinates" nearGeoPoint:currentUser[@"coordinates"] withinMiles:10];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *nearbyPeople, NSError *error) {
        if (nearbyPeople) {
            // do something with the array of object returned by the call
            self.nearbyPeople = nearbyPeople;
            [self.tableView reloadData]; // step 7: reload the table view
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    [self.refreshControl endRefreshing];
    [self.activityIndicator stopAnimating];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nearbyPeople.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleCell" forIndexPath:indexPath];
    
    PFUser *nearbyPerson = self.nearbyPeople[indexPath.row];
    cell.nearbyPerson = nearbyPerson;
    cell.nameLabel.text = nearbyPerson[@"name"];
    cell.ageLabel.text = [NSString stringWithFormat:@"Age: %@,", nearbyPerson[@"age"]];
    cell.genderLabel.text = [NSString stringWithFormat:@"Gender: %@", nearbyPerson[@"gender"]];
    cell.descriptionLabel.text = nearbyPerson[@"description"];
    cell.profilePic.file = nearbyPerson[@"profilePicture"];
    [cell.profilePic loadInBackground];
    
    return cell;

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueToPeopleDetailsViewController"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        PFUser *nearbyPerson = self.nearbyPeople[indexPath.row];
        PeopleDetailsViewController *peopleDetailsViewController = [segue destinationViewController];
        peopleDetailsViewController.nearbyPerson = nearbyPerson;
        [self addChildViewController:peopleDetailsViewController];
        [tappedCell setSelected:NO];
}
}

@end

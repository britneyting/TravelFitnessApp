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

@interface PeopleViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // code for activity indicator (refresh)
    self.refreshControl = [[UIRefreshControl alloc] init]; // do self refreshControl instead of UIRefreshControl *refreshControl since we already declared the variable refreshControl in properties
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0]; // inserts the activity indicator at index0 (before the first tweet)
}

- (void)fetchData {
    
    [self.activityIndicator startAnimating];
    
    // construct query
//    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
//    [query orderByDescending:@"createdAt"];
//    [query includeKey:@"author"];
//    query.limit = 20;
    
    // fetch data asynchronously
//    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
//        if (posts) {
//            // do something with the array of object returned by the call
//            self.posts = posts;
//            [self.tableView reloadData]; // step 7: reload the table view
//        } else {
//            NSLog(@"%@", error.localizedDescription);
//        }
//    }];
    
    [self.refreshControl endRefreshing];
    [self.activityIndicator stopAnimating];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleCell"forIndexPath:indexPath];
    
    return cell;

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

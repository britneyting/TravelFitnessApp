//
//  EventsHereViewController.m
//  Fitness App
//
//  Created by britneyting on 8/2/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "EventsHereViewController.h"
#import "EventsHereCell.h"
#import "Parse/Parse.h"
#import "Event.h"
#import "UILabel+FormattedText.h"
#import "EventsViewController.h"

@import Parse;

@interface EventsHereViewController () <UITableViewDelegate, UITableViewDataSource, EventsViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet PFImageView *coverPhoto;
@property (strong, nonatomic) NSArray *eventsHere;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation EventsHereViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTableHeaderView:self.coverPhoto];
    [self fetchData];
    self.tableView.rowHeight = 350;
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser[@"eventsRSVPed"] == nil) {
        currentUser[@"eventsRSVPed"] = [[NSMutableArray alloc] init];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Initialized empty mutable events array for this user");
            } else {
                NSLog(@"Failed to initialize empty mutable events array for this user");
            }
        }];
    }
    
    // code for activity indicator (refresh)
    self.refreshControl = [[UIRefreshControl alloc] init]; // do self refreshControl instead of UIRefreshControl *refreshControl since we already declared the variable refreshControl in properties
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    NSLog(@"Events that user is attending before clicking button: %@", currentUser[@"eventsRSVPed"]);
}

- (void)fetchData {
    
    [self.activityIndicator startAnimating];

    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query includeKey:@"poster"];
//    [query whereKey:@"eventLocation" equalTo:self.locationHere];
    [query whereKey:@"eventLocation" equalTo:@"1 Hacker Way, La Jolla, San Diego, CA 91823"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *eventsHere, NSError *error) {
        if (eventsHere) {
            self.eventsHere = eventsHere;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        }];
    
    [self.refreshControl endRefreshing];
    [self.activityIndicator stopAnimating];
     }
     
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.eventsHere.count;
     }
     
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFUser *currentUser = [PFUser currentUser];
    EventsHereCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventsHereCell" forIndexPath:indexPath];
    Event *event = self.eventsHere[indexPath.row];
    cell.event = event;
    cell.dateLabel.text = event.eventDate;
    cell.titleLabel.text = event.eventTitle;
    cell.addressLabel.text = event.eventLocation;
    cell.rsvpNumAndLim.text = [NSString stringWithFormat:@"RSVPed: %d/%@ people", event.RSVPed, event.rsvpsLimit];
    [cell.rsvpNumAndLim setTextColor:[UIColor lightGrayColor] String:@"RSVPed:"];
    cell.activityTypeLabel.text = [NSString stringWithFormat:@"Type of Activity: %@", event.activityType];
    [cell.activityTypeLabel setTextColor:[UIColor lightGrayColor] String:@"Type of Activity:"];
    cell.posterLabel.text = [NSString stringWithFormat:@"Organizer: %@", event.poster[@"name"]];
    [cell.posterLabel setTextColor:[UIColor lightGrayColor] String:@"Organizer:"];
    cell.descriptionLabel.text = [NSString stringWithFormat:@"Description: %@", event.moreInfo];
    [cell.descriptionLabel setTextColor:[UIColor lightGrayColor] String:@"Description:"];
    cell.equipmentLabel.text = [NSString stringWithFormat:@"Equipment: %@", event.equipment];
    [cell.equipmentLabel setTextColor:[UIColor lightGrayColor] String:@"Equipment:"];
    
    if ([currentUser[@"eventsRSVPed"] containsObject:event.objectId]) {
        [cell.rsvpButton setSelected:YES];
    }
    
    return cell;
     }

- (void)didCreate {
    [self fetchData];
    [self.tableView reloadData];
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

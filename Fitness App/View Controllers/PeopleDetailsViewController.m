//
//  PeopleDetailsViewController.m
//  Fitness App
//
//  Created by britneyting on 7/19/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "PeopleDetailsViewController.h"
#import "ChatViewController.h"

@interface PeopleDetailsViewController ()

@end

@implementation PeopleDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ageLabel.text = [NSString stringWithFormat:@"Age: %@", self.nearbyPerson[@"age"]];
    self.genderLabel.text = [NSString stringWithFormat:@"Gender: %@", self.nearbyPerson[@"gender"]];
    self.descriptionLabel.text = self.nearbyPerson[@"description"];
    self.profilePictureImage.file = self.nearbyPerson[@"profilePicture"];
    [self.profilePictureImage loadInBackground];
    self.titleBar.title = self.nearbyPerson[@"name"];
}

- (IBAction)chat:(id)sender {
}

- (void)fetchData:(MKMapView *)mapView {
    // fetch posts from the user's Parse backend and then post it in the mapview here
    // TO DO: get posts from Parse backend and filter by the key 'author'. Then post all their images onto the mapview and label it with the address.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueToPeopleDetailsViewController"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ChatViewController *chatController = (ChatViewController*)navigationController.topViewController;
    }
}

@end

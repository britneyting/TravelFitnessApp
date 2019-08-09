//
//  PeopleDetailsViewController.m
//  Fitness App
//
//  Created by britneyting on 7/19/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "PeopleDetailsViewController.h"
#import "UILabel+FormattedText.h"
#import "ChatViewController.h"
#import "UILabel+FormattedText.h"

@interface PeopleDetailsViewController ()

@end

@implementation PeopleDetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = self.nearbyPerson[@"name"];
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.nearbyPerson.username];
    self.ageLabel.text = [NSString stringWithFormat:@"%@ years old,", self.nearbyPerson[@"age"]];
    self.genderLabel.text = [NSString stringWithFormat:@"Gender: %@", self.nearbyPerson[@"gender"]];
    self.descriptionLabel.text = self.nearbyPerson[@"description"];
    self.profilePictureImage.file = self.nearbyPerson[@"profilePicture"];
    [self.profilePictureImage loadInBackground];
    self.profilePictureImage.layer.cornerRadius = 50;
    self.titleBar.title = self.nearbyPerson[@"name"];
}

- (void)fetchData:(MKMapView *)mapView { //it is useful
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToChatViewController"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ChatViewController *chatController = (ChatViewController*)navigationController.topViewController;
        chatController.navItem.title = self.nearbyPerson[@"name"];
        chatController.currentUser = [PFUser currentUser];
        chatController.nearbyPerson = self.nearbyPerson;
    }
}

@end

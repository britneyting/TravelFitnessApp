//
//  ProfileViewController.h
//  Fitness App
//
//  Created by danyguajiba on 7/16/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@import Parse;

@class ProfileViewControllerDelegate;
@protocol ProfileViewControllerDelegate
@end

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet PFImageView *profilePictureImage;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *editProfilePic;
@property (strong, nonatomic) IBOutlet UIImageView *editProfilePicIcon;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UIImageView *usernameIcon;
@property (strong, nonatomic) IBOutlet UIImageView *ageIcon;
@property (strong, nonatomic) IBOutlet UIImageView *genderIcon;
@property (strong, nonatomic) IBOutlet UITextView *descriptionField;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) id<ProfileViewControllerDelegate> delegate;

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;

@end



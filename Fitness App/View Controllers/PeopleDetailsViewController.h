//
//  PeopleDetailsViewController.h
//  Fitness App
//
//  Created by britneyting on 7/19/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@import Parse;

@interface PeopleDetailsViewController : UIViewController

@property (strong, nonatomic) PFUser *nearbyPerson;
@property (strong, nonatomic) IBOutlet PFImageView *profilePictureImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;

@end

NS_ASSUME_NONNULL_END

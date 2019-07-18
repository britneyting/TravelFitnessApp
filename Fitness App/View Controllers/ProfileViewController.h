//
//  ProfileViewController.h
//  Fitness App
//
//  Created by danyguajiba on 7/16/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPin.h"

@import Parse;

@class ProfileViewControllerDelegate;


@protocol ProfileViewControllerDelegate
@end

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet PFImageView *profilePictureImage;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *editProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionField;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) id<ProfileViewControllerDelegate> delegate;
@end


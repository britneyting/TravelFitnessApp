//
//  SignupViewController.h
//  Fitness App
//
//  Created by britneyting on 7/16/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignupViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *ageField;
@property (strong, nonatomic) IBOutlet UITextField *genderField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;

@end

NS_ASSUME_NONNULL_END

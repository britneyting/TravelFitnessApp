//
//  SignupViewController.m
//  Fitness App
//
//  Created by britneyting on 7/16/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "SignupViewController.h"
#import "Parse/Parse.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)createAlert:(NSString *)message withTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // handle cancel response here. Doing nothing will dismiss the view.
    }];
    
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { // handle response here.
    }];
    
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

- (void)registerUser {
    // this code is to sign a user up -- login is a separate page
    // initialize a user object
    PFUser *newUser = [PFUser user];

    // set user properties
    newUser[@"name"] = self.nameField.text;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    newUser[@"age"] = [formatter numberFromString:self.ageField.text];
    newUser[@"gender"] = self.genderField.text;
    newUser[@"description"] = self.descriptionField.text;
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    
    
    if ([self.nameField.text isEqual:@""]) {
        [self createAlert:@"Please enter your name" withTitle:@"Name Required"];
    }
    else if ([self.ageField.text isEqual:@""]) {
        [self createAlert:@"Please enter your age" withTitle:@"Age Required"];
    }
    else if ([self.genderField.text isEqual:@""]) {
        [self createAlert:@"Please enter a gender" withTitle:@"Gender Required"];
    }
    else if ([self.descriptionField.text isEqual:@""]) {
        [self createAlert:@"Please enter a description" withTitle:@"Description Required"];
    }
    else if ([self.usernameField.text isEqual:@""]) {
        [self createAlert:@"Please enter a username" withTitle:@"Username Required"];
    }
    else if ([self.passwordField.text isEqual:@""]) {
        [self createAlert:@"Please enter a password" withTitle:@"Password Required"];
    }
    else if ([self.emailField.text isEqual:@""]) {
        [self createAlert:@"Please enter your email" withTitle:@"Email Required"];
    }
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        // this block of code enforces that username isn't already taken
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
            [self performSegueWithIdentifier:@"segueToHomeFromSignup" sender:self];
            
        }
    }];
}

- (IBAction)signupButton:(id)sender {
    [self registerUser];
}

- (IBAction)loginButton:(id)sender {
    [self performSegueWithIdentifier:@"segueToLogin" sender:self];
}

- (IBAction)finishEditing:(id)sender {
    [self.view endEditing:YES];
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

//
//  LoginViewController.m
//  Fitness App
//
//  Created by britneyting on 7/16/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    UIImage *logo = [UIImage imageNamed:@"official logo"];
    [self.logo setImage:logo];
}

- (void)createAlert:(NSString *)message withTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancelAction];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self createAlert:error.localizedDescription withTitle:@"Login Failed"];
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"segueToHomeFromLogin" sender:self];
        }
    }];
}

- (IBAction)loginButton:(id)sender {
    [self loginUser];
}

- (IBAction)signupButton:(id)sender {
    [self performSegueWithIdentifier:@"segueToSignup" sender:self];
}

- (IBAction)finishEditing:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -(keyboardSize.height/2.5);
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}
@end

//
//  ProfileViewController.m
//  Fitness App
//
//  Created by danyguajiba on 7/16/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
#import <MapKit/MapKit.h>
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "LoginViewController.h"


@interface ProfileViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property CLLocationManager *locationManager;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myMapView.showsUserLocation = YES;
    self.myMapView.showsBuildings = YES;
    // Do any additional setup after loading the view.
    
    self.locationManager = [CLLocationManager new];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [self.locationManager requestWhenInUseAuthorization];
        
    [self.locationManager startUpdatingLocation];
}
-(void)mapView: (MKMapView *) mapView didUpdateUserLocation:(nonnull MKUserLocation *)userLocation{
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:userLocation.coordinate fromEyeCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) eyeAltitude:10000];
    [mapView setCamera:camera animated:YES];
}
- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(PFUser.currentUser == nil) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
            appDelegate.window.rootViewController = loginViewController;
            
            NSLog(@"User logged out successfully");
        } else {
            NSLog(@"Error logging out: %@", error);
        }
    }];
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

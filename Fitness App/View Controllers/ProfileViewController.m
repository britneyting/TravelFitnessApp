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
#import "MapPin.h"


@import Parse;

@interface ProfileViewController () <MKMapViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property CLLocationManager *locationManager;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIImage *editedImage;
@property (strong, nonatomic) UIImage *propic;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myMapView.showsUserLocation = YES;
    self.myMapView.showsBuildings = YES;
    // Do any additional setup after loading the view.
    
    PFUser *currentUser = [PFUser currentUser];
    self.nameLabel.text = currentUser[@"name"];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", currentUser[@"age"]];
    self.genderLabel.text = currentUser[@"gender"];
    self.descriptionLabel.text = currentUser[@"description"];
    self.profilePictureImage.file = currentUser[@"profilePicture"];
    [self.profilePictureImage loadInBackground];
    self.locationManager = [CLLocationManager new];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [self.locationManager requestWhenInUseAuthorization];
        
    [self.locationManager startUpdatingLocation];
}
- (IBAction)editProfilePic:(id)sender {
    [self choosePicture:@"Choose an image using your camera or photo library" withTitle:@"Change Your Profile Picture"];
}
- (void)choosePicture:(NSString *)message withTitle:(NSString *)title {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an photo library action
    UIAlertAction *pickPhoto = [UIAlertAction actionWithTitle:@"Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { // handle response here.
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    
    // add the photo library action to the alert controller
    [alert addAction:pickPhoto];
    
    // create a camera action
    UIAlertAction *pickCamera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // handle camera response here. Doing nothing will dismiss the view.
        // calls camera if camera is available
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    
    // add the camera action to the alertController
    [alert addAction:pickCamera];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    self.originalImage = info[UIImagePickerControllerOriginalImage];
    self.editedImage = info[UIImagePickerControllerEditedImage];
    self.editedImage = [self resizeImage:self.originalImage withSize:CGSizeMake(400, 400)];
    
    // Do something with the images (based on your use case)
    
    self.profilePictureImage.image = self.editedImage;
    self.propic = self.editedImage;
    NSData *imageData = UIImagePNGRepresentation(self.propic);
    PFFileObject *file = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"profilePicture"] = file;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully uploaded new profile picture to backend");
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];

    
    
    

}
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
-(void)mapView: (MKMapView *) mapView didUpdateUserLocation:(nonnull MKUserLocation *)userLocation{
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:userLocation.coordinate fromEyeCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) eyeAltitude:100];
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
- (IBAction)didTapPinLocation:(id)sender {
    MKMapPoint userLocationMapPoint =
    MKMapPointForCoordinate(self.myMapView.userLocation.coordinate);
    NSString *display_coordinates = [NSString stringWithFormat:@"my latitude is %f and longitude is %f", self.myMapView.userLocation.coordinate.longitude, self.myMapView.userLocation.coordinate.latitude];

    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:self.myMapView.userLocation.coordinate];
    [annotation setTitle:@"Test"];
    [annotation setSubtitle:display_coordinates];
    [self.myMapView addAnnotation:annotation];
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

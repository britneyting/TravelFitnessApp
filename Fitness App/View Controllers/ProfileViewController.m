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
#import "MapPinAnnotationView.h"
#import "postViewController.h"
#import "Post.h"
#import "FullPostViewController.h"
#import "PhotoAnnotation.h"

@import Parse;

@interface ProfileViewController () <MKMapViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIImage *editedImage;
@property (strong, nonatomic) UIImage *originalPinImage;
@property (strong, nonatomic) UIImage *editedPinImage;
@property (strong, nonatomic) UIImage *propic;
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property CLLocationManager *locationManager;
@property CLGeocoder *loc;
@property (strong, nonatomic) NSString *placeholderText;

@end

@implementation ProfileViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    self.saveButton.hidden = YES;
    self.placeholderText = @"Write description...";
    // Do any additional setup after loading the view.
    
    PFUser *currentUser = [PFUser currentUser];
    self.nameLabel.text = currentUser[@"name"];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", currentUser[@"age"]];
    self.genderLabel.text = currentUser[@"gender"];
    self.descriptionField.text = currentUser[@"description"];
    if ([self.descriptionField.text isEqualToString:@""]) {
        self.descriptionField.text = self.placeholderText;
        self.descriptionField.textColor = [UIColor lightGrayColor];
    }
    self.profilePictureImage.file = currentUser[@"profilePicture"];
    [self.profilePictureImage loadInBackground];
    self.navItem.title = currentUser[@"name"];
    
    self.myMapView.showsUserLocation = YES;
    self.myMapView.showsBuildings = YES;
    self.myMapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
        
    [self.locationManager startUpdatingLocation];
    self.loc= [[CLGeocoder alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    CLLocationCoordinate2D coordinate;
    coordinate.latitude=self.locationManager.location.coordinate.latitude;
    coordinate.longitude=self.locationManager.location.coordinate.longitude;
    MKPointAnnotation *marker = [MKPointAnnotation new];
    marker.coordinate = coordinate;
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    [self.loc reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
    CLPlacemark *placemark = [placemarks objectAtIndex:0];
    NSLog(@"placemark %@",placemark);

        //address starts here
        NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        NSLog(@"addressDictionary %@", placemark.addressDictionary);

        NSLog(@"placemark %@",placemark.region);
        NSLog(@"placemark %@",placemark.country);
        NSLog(@"placemark %@",placemark.locality);
        NSLog(@"location %@",placemark.name);
        NSLog(@"location %@",placemark.ocean);
        NSLog(@"location %@",placemark.postalCode);
        NSLog(@"location %@",placemark.subLocality);

        NSLog(@"location %@",placemark.location);
        //Print the location to console
        NSLog(@"I am currently at %@",locatedAt);
        [self.locationManager stopUpdatingLocation];
    }];
    
    PFQuery *postsPerUser = [Post query];
    [postsPerUser whereKey:@"username" equalTo:[PFUser currentUser].username];
    
    [postsPerUser findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            for (Post *post in posts) {
                [self postPin:(post)];
            }
        } else {
            NSLog(@"Error");
        }
    }];
}

-(void)getCurrentLocation {
    PFUser *currentUser = [PFUser currentUser];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude=self.locationManager.location.coordinate.latitude;
    coordinate.longitude=self.locationManager.location.coordinate.longitude;
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    currentUser[@"coordinates"] = geoPoint;

    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully updated user's current location in backend");
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void)mapView: (MKMapView *) mapView didUpdateUserLocation:(nonnull MKUserLocation *)userLocation{
    NSLog(@"%f , %f !!", self.myMapView.userLocation.coordinate.latitude, self.myMapView.userLocation.coordinate.longitude);
    [self getCurrentLocation];
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:userLocation.coordinate fromEyeCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) eyeAltitude:10000];
    [mapView setCamera:camera animated:YES];
}

//emerson
//-(MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation:(id<MKAnnotation>) annotation {
//    if([annotation isKindOfClass: [MapPin class]]){
//        MapPin *myLocation = (MapPin *) annotation;
//        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapPin"];
//        if(annotationView == nil)
//            annotationView = [myLocation annotationView];
//        else
//            annotationView.annotation = annotation;
//
//        return annotationView;
//    }
//    return nil;
//}

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

- (IBAction)editDescription:(id)sender {
    [self.descriptionField setUserInteractionEnabled:YES];
    if ([self.descriptionField.text isEqualToString:self.placeholderText]) {
        self.descriptionField.text = @"";
        self.descriptionField.textColor = [UIColor blackColor];
    }
    [self.descriptionField becomeFirstResponder];
    self.saveButton.hidden = NO;
}
- (IBAction)finishEditing:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)saveDescription:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"description"] = self.descriptionField.text;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully updated description in backend");
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    if ([self.descriptionField.text isEqualToString:@""]) {
        self.descriptionField.text = self.placeholderText;
        self.descriptionField.textColor = [UIColor lightGrayColor];
    }
    self.saveButton.hidden = YES;
    [self.view endEditing:YES];
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

- (void)postPin:(Post *)post{
//    lo quite por emerson
//    MapPin *annotation = [MapPin new];
    PFFileObject *imageFile = post[@"image"];

    NSURL *profilePhotoURL = [NSURL URLWithString:imageFile.url];
    NSData *data = [NSData dataWithContentsOfURL:profilePhotoURL];
    self.editedPinImage = [self resizeImage:[[UIImage alloc] initWithData:data] withSize:CGSizeMake(30,30)];

    // Add a pin to the map
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(post.coordinates.latitude, post.coordinates.longitude);
    PhotoAnnotation *point = [[PhotoAnnotation alloc] init];
    point.coordinate = coordinate;
    point.photo = self.editedPinImage;
    [self.myMapView addAnnotation:point];
    
    // Pop back
    [self.navigationController popViewControllerAnimated:true];
}

//emerson
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MapPin"];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapPin"];
        annotationView.canShowCallout = true;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
//    UIImage *thumbnail = [self resizeImage:((PhotoAnnotation*)annotation).photo withSize:CGSizeMake(50.0, 50.0)];
    UIImage *thumbnail = self.editedPinImage;
    UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
    imageView.image = thumbnail;
    annotationView.image = thumbnail;
    
    return annotationView;
}

//emerson
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"fullScreen" sender:view];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"backToProfile"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        postViewController *postController = (postViewController*)navigationController.topViewController;
//        postController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"fullScreen"]) {
        FullPostViewController *fullScreen = [segue destinationViewController];
        MKPinAnnotationView *pin = sender;
        PhotoAnnotation *annotation = (PhotoAnnotation*)pin.annotation;
        fullScreen.photo = self.editedPinImage;
    }
}

@end

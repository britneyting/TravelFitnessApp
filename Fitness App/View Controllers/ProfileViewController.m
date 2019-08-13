//
//  ProfileViewController.m
//  Fitness App
//
//  Created by danyguajiba on 7/16/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ProfileViewController.h"
#import <MapKit/MapKit.h>
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
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
@property (strong, nonatomic) NSString *placeholderText;
@property CLLocationManager *locationManager;
@property MKUserLocation *userLocation;

@end

@implementation ProfileViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];

    [self.locationManager startUpdatingLocation];
    
    [self.locationManager requestWhenInUseAuthorization];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.view.backgroundColor = [self colorWithHexString:@"efeeec"];
    
    self.navigationController.navigationBar.tintColor = [self colorWithHexString:@"157F1F"];
    self.navigationController.navigationBar.barTintColor = [self colorWithHexString:@"efeeec"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[self colorWithHexString:@"0C3823"]};
    
    self.saveButton.hidden = YES;
    self.placeholderText = @"Write description...";
    PFUser *currentUser = [PFUser currentUser];
    self.nameLabel.text = currentUser[@"name"];
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", currentUser.username];
    self.ageLabel.text = [NSString stringWithFormat:@"%@ years old", currentUser[@"age"]];
    self.genderLabel.text = currentUser[@"gender"];
    [self.usernameIcon setImage:[UIImage imageNamed:@"username_icon"]];
    [self.ageIcon setImage:[UIImage imageNamed:@"age_icon"]];
    [self.genderIcon setImage:[UIImage imageNamed:@"gender_icon"]];
    self.nameLabel.textColor = [self colorWithHexString:@"0C3823"];
    self.usernameLabel.textColor = [self colorWithHexString:@"157F1F"];
    self.ageLabel.textColor = [self colorWithHexString:@"157F1F"];
    self.genderLabel.textColor = [self colorWithHexString:@"157F1F"];
    self.descriptionField.text = currentUser[@"description"];
    
    if ([self.descriptionField.text isEqualToString:@""]) {
        self.descriptionField.text = self.placeholderText;
        self.descriptionField.textColor = [UIColor lightGrayColor];
    }

    self.profilePictureImage.file = currentUser[@"profilePicture"];
    [self.profilePictureImage loadInBackground];
    self.profilePictureImage.layer.cornerRadius = self.profilePictureImage.frame.size.width/2;
    [[self.profilePictureImage layer] setBorderWidth:5.0f];
    [[self.profilePictureImage layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.editProfilePicIcon.image = [UIImage imageNamed:@"camera_icon"];
    self.editProfilePicIcon.backgroundColor = [self colorWithHexString:@"dbdbdb"];
    self.editProfilePicIcon.layer.cornerRadius = 3;
    [[self.editProfilePicIcon layer] setBorderColor:[self colorWithHexString:@"dbdbdb"].CGColor];
    self.editProfilePicIcon.layer.borderWidth = 2.0f;
    self.navItem.title = currentUser[@"name"];
    
    self.myMapView.showsUserLocation = YES;
    self.myMapView.showsBuildings = YES;
    self.myMapView.delegate = self;
    self.myMapView.layer.cornerRadius = 15;
    
    PFQuery *postsPerUser = [Post query];
    [postsPerUser whereKey:@"username" equalTo:[PFUser currentUser].username];

    [postsPerUser findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if (posts)
            for (Post *post in posts)
                [self postPin:(post)];
    }];
    [self.locationManager stopUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.myMapView.userLocation.coordinate.latitude != 0 && self.myMapView.userLocation.coordinate.longitude != 0) {
        MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:self.myMapView.userLocation.coordinate fromEyeCoordinate:CLLocationCoordinate2DMake(self.myMapView.userLocation.coordinate.latitude, self.myMapView.userLocation.coordinate.longitude) eyeAltitude:1000000];
        [self.myMapView setCamera:camera animated:YES];
    }
}

-(void)getCurrentLocation {
    PFUser *currentUser = [PFUser currentUser];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude=self.locationManager.location.coordinate.latitude;
    coordinate.longitude=self.locationManager.location.coordinate.longitude;
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    currentUser[@"coordinates"] = geoPoint;
    [currentUser saveInBackground];
}

- (IBAction)editProfilePic:(id)sender {
    [self choosePicture:@"Choose an image using your camera or photo library" withTitle:@"Change Your Profile Picture"];
}

- (void)choosePicture:(NSString *)message withTitle:(NSString *)title {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *pickPhoto = [UIAlertAction actionWithTitle:@"Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    
    [alert addAction:pickPhoto];
    UIAlertAction *pickCamera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    
    [alert addAction:pickCamera];
    [self presentViewController:alert animated:YES completion:^{
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.originalImage = info[UIImagePickerControllerOriginalImage];
    self.editedImage = info[UIImagePickerControllerEditedImage];
    self.editedImage = [self resizeImage:self.originalImage withSize:CGSizeMake(400, 400)];
    
    self.profilePictureImage.image = self.editedImage;
    self.propic = self.editedImage;
    NSData *imageData = UIImagePNGRepresentation(self.propic);
    PFFileObject *file = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"profilePicture"] = file;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded)
            NSLog(@"Successfully uploaded new profile picture to backend");
    }];
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
        if (succeeded)
            NSLog(@"Successfully updated description in backend");
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
        }
    }];
}

- (UIImage *)addBorderToImage:(UIImage *)image {
    CGImageRef bgimage = [image CGImage];
    float width = CGImageGetWidth(bgimage);
    float height = CGImageGetHeight(bgimage);
    
    // Create a temporary texture data buffer
    void *data = malloc(width * height * 4);
    
    // Draw image to buffer
    CGContextRef ctx = CGBitmapContextCreate(data,
                                             width,
                                             height,
                                             8,
                                             width * 4,
                                             CGImageGetColorSpace(image.CGImage),
                                             kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(ctx, CGRectMake(0, 0, (CGFloat)width, (CGFloat)height), bgimage);
    
    //Set the stroke (pen) color
    CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    
    //Set the width of the pen mark
    CGFloat borderWidth = (float)width*0.05;
    CGContextSetLineWidth(ctx, borderWidth);
    
    //Start at 0,0 and draw a square
    CGContextMoveToPoint(ctx, 0.0, 0.0);
    CGContextAddLineToPoint(ctx, 0.0, height);
    CGContextAddLineToPoint(ctx, width, height);
    CGContextAddLineToPoint(ctx, width, 0.0);
    CGContextAddLineToPoint(ctx, 0.0, 0.0);
    
    //Draw it
    CGContextStrokePath(ctx);
    
    // write it to a new image
    CGImageRef cgimage = CGBitmapContextCreateImage(ctx);
    UIImage *newImage = [UIImage imageWithCGImage:cgimage];
    CFRelease(cgimage);
    CGContextRelease(ctx);
    
    // auto-released
    return newImage;
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void)postPin:(Post *)post{
    PFFileObject *imageFile = post[@"image"];
    NSURL *postPic = [NSURL URLWithString:imageFile.url];
    NSData *data = [NSData dataWithContentsOfURL:postPic];
    self.originalPinImage = [UIImage imageWithData:data];
    self.editedPinImage = [self resizeImage:[[UIImage alloc] initWithData:data] withSize:CGSizeMake(50,50)];
    
    // Add a pin to the map
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(post.coordinates.latitude, post.coordinates.longitude);
    PhotoAnnotation *point = [[PhotoAnnotation alloc] init];
    point.coordinate = coordinate;
    point.subtitletitle = post[@"caption"];
    point.photo = [self circularScaleAndCropImage:self.editedPinImage frame:CGRectMake(0, 0, 40, 40)];
    point.fullPhoto = self.originalPinImage;
    
    [self.myMapView addAnnotation:point];
    [self.navigationController popViewControllerAnimated:true];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MapPin"];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapPin"];
        annotationView.canShowCallout = true;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    if([annotation isKindOfClass:[PhotoAnnotation class]]) {
        PhotoAnnotation *point = (PhotoAnnotation *)annotation;
        UIImage *thumbnail = point.photo;
        UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
        imageView.image = thumbnail;
        annotationView.image = thumbnail;
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"fullScreen" sender:view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fullScreen"]) {
        FullPostViewController *fullScreen = [segue destinationViewController];
        fullScreen.hidesBottomBarWhenPushed = YES;
        MKPinAnnotationView *pin = sender;
        PhotoAnnotation *annotation = (PhotoAnnotation*)pin.annotation;
        fullScreen.photo = annotation.fullPhoto;
        fullScreen.annotation = annotation;
    }
}

- (IBAction)unwindFromViewController2:(UIStoryboardSegue *)segue{ //although it seems it's doing nothing, this is needed to conduct the unwind
    [self viewDidLoad];
}

- (UIImage*)circularScaleAndCropImage:(UIImage*)image frame:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rectWidth = frame.size.width;
    CGFloat rectHeight = frame.size.height;
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2; CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

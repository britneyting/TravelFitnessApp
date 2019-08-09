//
//  PeopleDetailsViewController.m
//  Fitness App
//
//  Created by britneyting on 7/19/19.
//  Copyright © 2019 britneyting. All rights reserved.
//


#import "PeopleDetailsViewController.h"
#import "UILabel+FormattedText.h"
#import "ChatViewController.h"
#import "ProfileViewController.h"
#import <MapKit/MapKit.h>
#import "Parse/Parse.h"
#import "postViewController.h"
#import "Post.h"
#import "FullPostViewController.h"
#import "PhotoAnnotation.h"

@interface PeopleDetailsViewController ()<MKMapViewDelegate>
@property (strong, nonatomic) UIImage *originalPinImage;
@property (strong, nonatomic) UIImage *editedPinImage;
@property CLLocationManager *locationManager;

@end

@implementation PeopleDetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = self.nearbyPerson[@"name"];
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.nearbyPerson.username];
    self.ageLabel.text = [NSString stringWithFormat:@"%@ years old,", self.nearbyPerson[@"age"]];
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager startUpdatingLocation];
    
    self.myMapView.delegate = self;
    self.myMapView.showsUserLocation = YES;
    self.genderLabel.text = [NSString stringWithFormat:@"Gender: %@", self.nearbyPerson[@"gender"]];
    self.descriptionLabel.text = self.nearbyPerson[@"description"];
    self.profilePictureImage.file = self.nearbyPerson[@"profilePicture"];
    [self.profilePictureImage loadInBackground];
    self.profilePictureImage.layer.cornerRadius = 50;
    self.titleBar.title = self.nearbyPerson[@"name"];
    
    PFQuery *userPosts = [Post query];
    [userPosts whereKey:@"username" equalTo:self.nearbyPerson.username];

    [userPosts findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if (posts)
            for (Post *post in posts)
                [self postPin:(post)];
    }];

    if (self.myMapView.userLocation.coordinate.latitude != 0 && self.myMapView.userLocation.coordinate.longitude != 0) {
        MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:self.myMapView.userLocation.coordinate fromEyeCoordinate:CLLocationCoordinate2DMake(self.myMapView.userLocation.coordinate.latitude, self.myMapView.userLocation.coordinate.longitude) eyeAltitude:100000];
            [self.myMapView setCamera:camera animated:NO];

    }
}

- (void)fetchData:(MKMapView *)mapView { //it is useful
}

- (void)postPin:(Post *)post{
    NSLog(@"post");
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
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"fullScreen2" sender:view];
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToChatViewController"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ChatViewController *chatController = (ChatViewController*)navigationController.topViewController;
        chatController.navItem.title = self.nearbyPerson[@"name"];
        chatController.currentUser = [PFUser currentUser];
        chatController.nearbyPerson = self.nearbyPerson;
    }
 else if ([segue.identifier isEqualToString:@"fullScreen2"]) {
        FullPostViewController *fullScreen = [segue destinationViewController];
        fullScreen.hidesBottomBarWhenPushed = YES;
        MKPinAnnotationView *pin = sender;
        PhotoAnnotation *annotation = (PhotoAnnotation*)pin.annotation;
        fullScreen.photo = annotation.fullPhoto;
        fullScreen.annotation = annotation;
    }
}
@end

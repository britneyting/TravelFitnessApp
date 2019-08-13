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
    
    self.navigationController.navigationBar.tintColor = [self colorWithHexString:@"157F1F"];
    
    self.nameLabel.text = self.nearbyPerson[@"name"];
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.nearbyPerson.username];
    self.ageLabel.text = [NSString stringWithFormat:@"%@ years old", self.nearbyPerson[@"age"]];
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager startUpdatingLocation];
    
    self.myMapView.delegate = self;
    self.myMapView.showsUserLocation = YES;
    self.genderLabel.text = [NSString stringWithFormat:@"%@", self.nearbyPerson[@"gender"]];
    [self.usernameIcon setImage:[UIImage imageNamed:@"username_icon"]];
    [self.ageIcon setImage:[UIImage imageNamed:@"age_icon"]];
    [self.genderIcon setImage:[UIImage imageNamed:@"gender_icon"]];
    self.nameLabel.textColor = [self colorWithHexString:@"0C3823"];
    self.usernameLabel.textColor = [self colorWithHexString:@"157F1F"];
    self.ageLabel.textColor = [self colorWithHexString:@"157F1F"];
    self.genderLabel.textColor = [self colorWithHexString:@"157F1F"];
    self.descriptionLabel.text = self.nearbyPerson[@"description"];
    self.profilePictureImage.file = self.nearbyPerson[@"profilePicture"];
    [self.profilePictureImage loadInBackground];
    self.profilePictureImage.layer.cornerRadius = self.profilePictureImage.frame.size.height/2;
    [[self.profilePictureImage layer] setBorderWidth:5.0f];
    [[self.profilePictureImage layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.titleBar.title = self.nearbyPerson[@"name"];
    self.myMapView.layer.cornerRadius = 15;
    self.followButton.layer.cornerRadius = 8;
    
    PFQuery *userPosts = [Post query];
    [userPosts whereKey:@"username" equalTo:self.nearbyPerson.username];

    [userPosts findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if (posts)
            for (Post *post in posts)
                [self postPin:(post)];
    }];

    if (self.myMapView.userLocation.coordinate.latitude != 0 && self.myMapView.userLocation.coordinate.longitude != 0) {
        MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:self.myMapView.userLocation.coordinate fromEyeCoordinate:CLLocationCoordinate2DMake(self.myMapView.userLocation.coordinate.latitude, self.myMapView.userLocation.coordinate.longitude) eyeAltitude:1000000];
            [self.myMapView setCamera:camera animated:NO];

    }
}

- (void)fetchData:(MKMapView *)mapView { //it is useful
}

- (IBAction)followedUser:(id)sender {
    if (![self.followButton isSelected]) {
        [self.followButton setSelected:YES];
    }
    else {
        [self.followButton setSelected:NO];
    }
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

//
//  MapPin.m
//  Fitness App
//
//  Created by danyguajiba on 7/17/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "MapPin.h"
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import "ProfileViewController.h"
#import "FullPostViewController.h"

@implementation MapPin

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;

//-(MKAnnotationView *) annotationView{
////    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
////    annotationView.enabled = YES;
////    annotationView.canShowCallout = YES;
////    annotationView.image = self.image;
////    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
////    annotationView.rightCalloutAccessoryView = infoButton;
////
////    [infoButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
////
////    return annotationView;
//}

- (void)buttonPressed:(UIButton *)button {
    NSLog (@"Si se imprimio cuando lo tocaste");
//    self.image = [self resizeImage:self.image withSize:CGSizeMake(400, 400)];
//    self.annotationView.image = [self resizeImage:self.annotationView.image withSize:CGSizeMake(400, 400)];

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


@end


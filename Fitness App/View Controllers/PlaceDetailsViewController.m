//
//  PlaceDetailsViewController.m
//  Fitness App
//
//  Created by danyguajiba on 8/5/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "PlaceDetailsViewController.h"
#import <MapKit/MapKit.h>


@interface PlaceDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdrop;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property CLGeocoder *loc;
@property NSString *locatedAt;

@end

@implementation PlaceDetailsViewController

- (void)viewDidLoad {
    self.name.text = self.location.placeName;
    self.backdrop.image = [UIImage imageNamed:self.location.placeName];
    self.address.text = [self coordinatesIntoAddress];
    NSLog(@"latitude: %f, longitude: %f", self.location.placeCoordinates.latitude, self.location.placeCoordinates.longitude);
    [super viewDidLoad];
}

-(NSString *)coordinatesIntoAddress{
    self.loc= [[CLGeocoder alloc]init];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude=self.location.placeCoordinates.latitude;
    coordinate.longitude=self.location.placeCoordinates.longitude;
    
    NSLog(@"inside method latitude %f, longitude %f ", coordinate.latitude, coordinate.longitude);
    
    MKPointAnnotation *marker = [MKPointAnnotation new];
    marker.coordinate = coordinate;
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    __block NSString *address = [NSString new];

    [self.loc reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSLog(@"placemark %@",placemark);
        
        self.locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        self.address.text = self.locatedAt;
        NSLog(@"I am currently at %@",self.locatedAt);
    }];
    
    NSLog(@"I am currently at bueno %@",self.address.text);
    return address;
}
@end

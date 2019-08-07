//
//  PlaceDetailsViewController.m
//  Fitness App
//
//  Created by danyguajiba on 8/5/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "PlaceDetailsViewController.h"
#import <MapKit/MapKit.h>
#import "EventsViewController.h"
#import "EventsHereViewController.h"

@interface PlaceDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdrop;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *placeDescription;
@property CLGeocoder *loc;
@property NSString *locatedAt;

@end

@implementation PlaceDetailsViewController

- (void)viewDidLoad {
    self.name.text = self.location.placeName;
    self.backdrop.image = [UIImage imageNamed:self.location.placeName];
    self.address.text = [self coordinatesIntoAddress];
    if([self.name.text isEqualToString:(@"Yosemite National Park")])
        self.placeDescription.text = @"The bulk of Yosemite National Park lies above the valley, a vast expanse of high-country meadows, mountains, and forest that includes the headwaters of several mighty rivers and more than 1,100 square miles (2,848.9 sq km) of designated wilderness. Most of this region is accessible only by foot.";
    else if([self.name.text isEqualToString:(@"Tenaya Creek")])
        self.placeDescription.text = @"The Tenaya Waterslide is a 100 foot long natural granite waterslide. The rock face is mostly smooth and becomes a little slick from the growth of algae on the rock. The waterslide is located at upper Tenaya valley about 2 miles from the Tioga Pass road. The valley is lined with smooth granite rock polished from the glacier activity from the past ice age. The waterslide dumps you out into a little pool of water about 3 feet deep.";
    else if([self.name.text isEqualToString:(@"Merced River")])
        self.placeDescription.text = @"The main fork of the Merced River is a great place for swimming, hiking, fishing, rafting, gold-panning, camping and general recreation during the summer months. It’s low elevation also makes it a great place for a day hike in the winter. There is day use and picnicking along Highway 140 and Briceburg, with overnight camping or fires only at designated campsites.";
    else if([self.name.text isEqualToString:(@"North Dome")])
        self.placeDescription.text = @"North Dome is one of the more prominent dome formations located far above the northern side of Yosemite Valley and it stands directly across from the face of Half Dome. Hikers who reach the top of North Dome are treated to amazing views in all directions.";
    else if([self.name.text isEqualToString:(@"Moran Point")])
        self.placeDescription.text = @"The scenery starts slowly from the bottom, since you need to climb above the timber that blankets much of the valley before the views really start to pop, but the early stretches are still pleasant, as you pass lots of moss-covered boulders and, if your timing is good, wildflowers.";
    else if([self.name.text isEqualToString:(@"Sentinel Dome")])
        self.placeDescription.text = @" Hiking to the top of Sentinel Dome is by far an easy way to experience miles and miles of views in whatever direction you care to turn. Looking west, you'll see down Yosemite Valley and beyond to the Merced River canyon and, on exceptionally clear days, all the way to Mt. Diablo in the coastal range. To the north you'll see Yosemite Valley, including El Capitan and Yosemite Falls. To the east, you'll see Nevada Fall, Half Dome and Clouds Rest, and an assortment of High Sierra peaks.";
    else if([self.name.text isEqualToString:(@"Three Brothers")])
        self.placeDescription.text = @"The Three Brothers is a rock formation, in California. It is located just east of El Capitan and consists of Eagle Peak (the uppermost 'brother'), and Middle and Lower Brothers.[3]";
    else if([self.name.text isEqualToString:(@"Eagle Peak")])
        self.placeDescription.text = @"Eagle Peak is the highest of the Three Brothers, a rock formation, above Yosemite Valley in California. This independent peak is located just east of El Capitan. John Muir considered the view from the summit to be “most comprehensive of all the views” available from the north wall.";
    else if([self.name.text isEqualToString:(@"Union Point")])
        self.placeDescription.text = @"Glacier Point to Union Point is a 3.7 mile moderately trafficked out and back trail located near Yosemite Valley, California that features a great forest setting and is rated as moderate. The trail is primarily used for hiking and nature trips and is best used from April until September.";
    [super viewDidLoad];
}

-(NSString *)coordinatesIntoAddress{
    self.loc= [[CLGeocoder alloc]init];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude=self.location.placeCoordinates.latitude;
    coordinate.longitude=self.location.placeCoordinates.longitude;
    
    MKPointAnnotation *marker = [MKPointAnnotation new];
    marker.coordinate = coordinate;
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    __block NSString *address = [NSString new];

    [self.loc reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        self.locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        self.address.text = self.locatedAt;
    }];
    return address;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueToEventsVC"]){
        UINavigationController *navigationController = [segue destinationViewController];
        EventsViewController *eventController = (EventsViewController*)navigationController.topViewController;
        eventController.locationHere = self.locatedAt;
    }
    if ([segue.identifier isEqualToString:@"segueToEventsHereVC"]){
//        UINavigationController *navigationController = [segue destinationViewController];
//        EventsHereViewController *eventHereController = (EventsHereViewController*)navigationController.topViewController;
        EventsHereViewController *eventHereController = [segue destinationViewController];
        eventHereController.locationHere = self.locatedAt;
        eventHereController.coverPhotoImage = [UIImage imageNamed:self.location.placeName];
    }
}
@end

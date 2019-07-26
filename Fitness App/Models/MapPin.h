//
//  MapPin.h
//  Fitness App
//
//  Created by danyguajiba on 7/17/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface MapPin : MKPointAnnotation{
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitletitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) UIImage *image;

-(MKAnnotationView *) annotationView;
-(MKAnnotationView *) annotationView:(UIImage *)image;
-(void)buttonPressed:(UIButton *)button;
- (void)mapView:(MKMapView *)mapViewannotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;

@end

NS_ASSUME_NONNULL_END

    

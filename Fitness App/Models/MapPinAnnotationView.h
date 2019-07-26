//
//  MapPinAnnotationView.h
//  Fitness App
//
//  Created by danyguajiba on 7/25/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <MapKit/MapKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface MapPinAnnotationView : MKAnnotationView
@property (nonatomic, copy) PFImageView *imageFile;


@end

NS_ASSUME_NONNULL_END

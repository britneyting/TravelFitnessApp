//
//  PhotoAnnotation.h
//  Fitness App
//
//  Created by danyguajiba on 7/26/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface PhotoAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) UIImage *photo;

@end

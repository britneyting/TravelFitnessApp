//
//  PhotoAnnotation.m
//  Fitness App
//
//  Created by danyguajiba on 7/26/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "PhotoAnnotation.h"

@interface PhotoAnnotation()

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation PhotoAnnotation

- (NSString *)title {
    return [NSString stringWithFormat:@"%@", self.subtitletitle];
}

@end

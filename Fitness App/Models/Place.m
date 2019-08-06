//
//  Place.m
//  Fitness App
//
//  Created by danyguajiba on 8/2/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "Place.h"

@implementation Place

@dynamic placeName;
@dynamic placeType;
@dynamic placeCoordinates;

+ (nonnull NSString *)parseClassName {
    return @"Place";
}

+(void) createPlace: (NSString *) placeName withType: (NSString *) placeType withCoordinates: (PFGeoPoint *)placeCoordinates withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    Place *place = [Place new];
    place.placeName = placeName;
    place.placeType = placeType;
    place.placeCoordinates = placeCoordinates;
}

+ (void) savePlaceBackend: (Place *) place withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    [place saveInBackgroundWithBlock: completion];

}


@end

//
//  Place.h
//  Fitness App
//
//  Created by danyguajiba on 8/2/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface Place : PFObject <PFSubclassing>
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *placeType;
@property (nonatomic, strong) PFGeoPoint *placeCoordinates;
@property (nonatomic, strong) PFFileObject *image;

+(void) createPlace: (NSString *) placeName withType: (NSString *) placeType withCoordinates: (PFGeoPoint *)placeCoordinates withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void) savePlaceBackend: (Place *)place withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END

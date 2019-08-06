//
//  Event.h
//  Fitness App
//
//  Created by britneyting on 8/1/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Event : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *poster;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *eventTitle;
@property (nonatomic, strong) NSString *eventLocation;
@property (nonatomic, strong) NSString *eventDate;
@property (nonatomic, strong) NSString *activityType;
@property (nonatomic, strong) NSNumber *rsvpsLimit;
@property (nonatomic, strong) NSString *equipment;
@property (nonatomic, strong) NSString *moreInfo;
@property (nonatomic) int RSVPed;

+ (void) createEvent: (NSString *)eventTitle withLocation: (PFGeoPoint *)eventlocation withEventDate:(NSString *)eventDate withActivityType:(NSString *)activityType withRSVPsLimit:(NSNumber *)rsvpsLimit withEquipment:(NSString *)equipment withMoreInfo:(NSString *)moreInfo withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END

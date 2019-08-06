//
//  Event.m
//  Fitness App
//
//  Created by britneyting on 8/1/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "Event.h"

@implementation Event

@dynamic poster;
@dynamic username;
@dynamic eventTitle;
@dynamic eventLocation;
@dynamic eventDate;
@dynamic activityType;
@dynamic rsvpsLimit;
@dynamic equipment;
@dynamic moreInfo;
@dynamic RSVPed;

+ (nonnull NSString *)parseClassName {
    return @"Event";
}

+ (void) createEvent: (NSString *)eventTitle withLocation: (NSString *)eventlocation withEventDate:(NSString *)eventDate withActivityType:(NSString *)activityType withRSVPsLimit:(NSNumber *)rsvpsLimit withEquipment:(NSString *)equipment withMoreInfo:(NSString *)moreInfo withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Event *newEvent = [Event new];
    newEvent.poster = [PFUser currentUser];
    newEvent.username = newEvent.poster.username;
    newEvent.eventTitle = eventTitle;
    newEvent.eventLocation = eventlocation;
    newEvent.eventDate = eventDate;
    newEvent.activityType = activityType;
    newEvent.rsvpsLimit = rsvpsLimit;
    newEvent.equipment = equipment;
    newEvent.moreInfo = moreInfo;
    newEvent.RSVPed = 0;
    [newEvent saveInBackgroundWithBlock: completion];
}

@end

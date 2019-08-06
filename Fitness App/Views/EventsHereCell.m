//
//  EventsHereCell.m
//  Fitness App
//
//  Created by britneyting on 8/2/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "EventsHereCell.h"
#import "UILabel+FormattedText.h"
#import "Parse/Parse.h"

@implementation EventsHereCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapRSVP:(id)sender {
    
    PFUser *currentUser = [PFUser currentUser];

    // updates color and count of RSVP when pressed/unpressed
    if ([currentUser[@"eventsRSVPed"] containsObject:self.event.objectId]) {
        self.event.RSVPed -= 1;
        [currentUser[@"eventsRSVPed"] removeObject:self.event.objectId];
        [self saveEventInBackground:self.event withAction:@"unRSVPed"];
        [self saveUserInBackground:currentUser withAction:@"removed"];
    }
    else if (![currentUser[@"eventsRSVPed"] containsObject:self.event.objectId]) {
        self.event.RSVPed += 1;
        [currentUser[@"eventsRSVPed"] addObject:self.event.objectId];
        [self saveEventInBackground:self.event withAction:@"RSVPed"];
        [self saveUserInBackground:currentUser withAction:@"added"];
    }
    [self refreshData:self.event];
}

- (void)saveEventInBackground:(Event *)event withAction:(NSString *)action {
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully %@!", action);
        } else {
            NSLog(@"Error in %@ :^(", action);
        }
    }];
     }

- (void)saveUserInBackground:(PFUser *)currentUser withAction:(NSString *)action {
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully %@ event in user's backend", action);
            NSLog(@"Events that user is attending after clicking button: %@", currentUser[@"eventsRSVPed"]);
        } else {
            NSLog(@"Error in %@ event from user's backend", action);
        }
    }];
}

- (void)refreshData:(Event *)event {
    
    PFUser *currentUser = [PFUser currentUser];

    if ([currentUser[@"eventsRSVPed"] containsObject:self.event.objectId]) {
        [self.rsvpButton setSelected:YES];
        
    } else {
        [self.rsvpButton setSelected:NO];
    }
    self.rsvpNumAndLim.text = [NSString stringWithFormat:@"RSVPed: %d/%@ people", event.RSVPed, event.rsvpsLimit];
    [self.rsvpNumAndLim setTextColor:[UIColor lightGrayColor] String:@"RSVPed:"];
}
@end

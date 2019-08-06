//
//  EventsHereCell.h
//  Fitness App
//
//  Created by britneyting on 8/2/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventsHereCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *rsvpButton;
@property (strong, nonatomic) IBOutlet UILabel *rsvpNumAndLim;
@property (strong, nonatomic) IBOutlet UILabel *activityTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *posterLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *equipmentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *rsvpIcon;
@property (strong, nonatomic) IBOutlet UIImageView *activityTypeIcon;
@property (strong, nonatomic) IBOutlet UIImageView *descriptionIcon;
@property (strong, nonatomic) IBOutlet UIImageView *eqipmentIcon;
@property (strong, nonatomic) IBOutlet UIImageView *posterIcon;
@property (strong, nonnull) Event *event;

@end

NS_ASSUME_NONNULL_END

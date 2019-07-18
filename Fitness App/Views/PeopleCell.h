//
//  PeopleCell.h
//  Fitness App
//
//  Created by britneyting on 7/17/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PeopleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet PFImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

NS_ASSUME_NONNULL_END

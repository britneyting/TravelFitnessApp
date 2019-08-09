//
//  ChatCell.h
//  Fitness App
//
//  Created by britneyting on 7/22/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

- (void)showOutgoingMessageWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END

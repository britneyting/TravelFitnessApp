//
//  EventsViewController.h
//  Fitness App
//
//  Created by britneyting on 7/31/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *createBarButton;
@property (strong, nonatomic) NSString *locationHere;

@end

NS_ASSUME_NONNULL_END

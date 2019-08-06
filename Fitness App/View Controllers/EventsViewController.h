//
//  EventsViewController.h
//  Fitness App
//
//  Created by britneyting on 7/31/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EventsViewControllerDelegate

- (void)didCreate; // automatically reloads data so event appears without having to manually refresh the page

@end

@interface EventsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *createBarButton;
@property (nonatomic, weak) id<EventsViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *locationHere;

@end

NS_ASSUME_NONNULL_END

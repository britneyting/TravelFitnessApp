//
//  ExploreViewController.h
//  Fitness App
//
//  Created by britneyting on 7/17/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExploreViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIView *peopleContainerView;
@property (strong, nonatomic) IBOutlet UIView *placesContainerView;

@end

NS_ASSUME_NONNULL_END

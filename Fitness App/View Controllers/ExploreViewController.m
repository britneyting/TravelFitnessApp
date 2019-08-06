//
//  ExploreViewController.m
//  Fitness App
//
//  Created by britneyting on 7/17/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "ExploreViewController.h"

@interface ExploreViewController ()

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)switchViews:(id)sender {
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [UIView animateWithDuration:(0.1) animations:^{
            self.peopleContainerView.alpha = 1;
            self.placesContainerView.alpha = 0;
        }];
    } else {
        [UIView animateWithDuration:(0.1) animations:^{
            self.peopleContainerView.alpha = 0;
            self.placesContainerView.alpha = 1;
        }];
    }
}
@end

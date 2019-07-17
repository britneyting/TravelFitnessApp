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
    // Do any additional setup after loading the view.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  ExploreViewController.m
//  Fitness App
//
//  Created by britneyting on 7/17/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "ExploreViewController.h"

@interface ExploreViewController ()

@property (strong, nonatomic) UIView *buttonBar;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentControl.backgroundColor = [UIColor clearColor];
    self.segmentControl.tintColor = [UIColor clearColor];
    [self.segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:18.0f], NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [self.segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:18.0f], NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    NSLayoutConstraint *segmentControlWidthConstraint = [self.segmentControl.widthAnchor constraintEqualToConstant:self.view.frame.size.width];

    self.buttonBar = [[UIView alloc] init];
    self.buttonBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.buttonBar.backgroundColor = [UIColor redColor];
    [self.segmentControl addSubview:self.buttonBar];
    NSLayoutConstraint *buttonBarTopConstraint = [self.buttonBar.topAnchor constraintEqualToAnchor:self.segmentControl.bottomAnchor];
    NSLayoutConstraint *buttonBarHeightConstraint = [self.buttonBar.heightAnchor constraintEqualToConstant:(CGFloat)4];
    NSLayoutConstraint *buttonBarLeftConstraint = [self.buttonBar.leftAnchor constraintEqualToAnchor:self.segmentControl.leftAnchor];
    NSLayoutConstraint *buttonBarWidthConstraint = [self.buttonBar.widthAnchor constraintEqualToAnchor:self.segmentControl.widthAnchor multiplier:(1/(CGFloat)self.segmentControl.numberOfSegments)];
    
    // activating constraints for segmented control and button
    NSArray *layoutConstraints = [[NSArray alloc] initWithObjects:segmentControlWidthConstraint, buttonBarTopConstraint, buttonBarLeftConstraint, buttonBarHeightConstraint, buttonBarWidthConstraint, nil];
    [NSLayoutConstraint activateConstraints:layoutConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    CGRect frame = self.buttonBar.frame;
    frame.origin.x = ((self.segmentControl.frame.size.width / (CGFloat)self.segmentControl.numberOfSegments) * (CGFloat)self.segmentControl.selectedSegmentIndex);
    self.buttonBar.frame = frame;
}

- (IBAction)switchViews:(id)sender {
    [UIView animateWithDuration:(0.2) animations:^{
        CGRect frame = self.buttonBar.frame;
        frame.origin.x = ((self.segmentControl.frame.size.width / (CGFloat)self.segmentControl.numberOfSegments) * (CGFloat)self.segmentControl.selectedSegmentIndex);
        self.buttonBar.frame = frame;
    }];
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [UIView animateWithDuration:(0.2) animations:^{
            self.peopleContainerView.alpha = 1;
            self.placesContainerView.alpha = 0;
        }];
    } else {
        [UIView animateWithDuration:(0.2) animations:^{
            self.peopleContainerView.alpha = 0;
            self.placesContainerView.alpha = 1;
        }];
    }
}
@end

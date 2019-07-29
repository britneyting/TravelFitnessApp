//
//  FullPostViewController.m
//  Fitness App
//
//  Created by danyguajiba on 7/25/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "FullPostViewController.h"

@interface FullPostViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FullPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.imageView.image = self.photo;
    self.caption.text = self.annotation.subtitletitle;
    NSLog (@"subtitle third time %@", self.caption.text);

//    self.caption.text = caption.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end

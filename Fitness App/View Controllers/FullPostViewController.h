//
//  FullPostViewController.h
//  Fitness App
//
//  Created by danyguajiba on 7/25/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAnnotation.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface FullPostViewController : UIViewController
@property (strong, nonatomic) UIImage *photo;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (strong, nonatomic) PhotoAnnotation *annotation;

@end

NS_ASSUME_NONNULL_END

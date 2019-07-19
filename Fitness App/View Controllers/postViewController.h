//
//  postViewController.h
//  Fitness App
//
//  Created by danyguajiba on 7/17/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol postViewControllerDelegate

- (void)didPostImage:(UIImage *)photo withCaption:(NSString *)caption;

@end

@interface postViewController : UIViewController
//@property (weak, nonatomic) IBOutlet PFImageView *postImage;

@property (nonatomic, weak) id<postViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

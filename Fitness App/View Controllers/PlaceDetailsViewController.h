//
//  PlaceDetailsViewController.h
//  Fitness App
//
//  Created by danyguajiba on 8/5/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaceDetailsViewController : UIViewController
@property (nonatomic, strong) NSDictionary *place;
@property Place *location;
-(NSString *)coordinatesIntoAddress;


@end

NS_ASSUME_NONNULL_END

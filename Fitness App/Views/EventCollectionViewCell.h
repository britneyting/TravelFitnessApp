//
//  EventCollectionViewCell.h
//  Fitness App
//
//  Created by danyguajiba on 8/2/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface EventCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (nonatomic, strong) NSString *placeType;
@property (nonatomic, strong) Place *place;

@end

NS_ASSUME_NONNULL_END

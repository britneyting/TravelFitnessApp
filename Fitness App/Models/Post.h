//
//  Post.h
//  Fitness App
//
//  Created by danyguajiba on 7/18/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) PFGeoPoint *coordinates;

@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;

@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *locality;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *postalCode;

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END



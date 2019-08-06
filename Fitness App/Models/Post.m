//
//  Post.m
//  Fitness App
//
//  Created by danyguajiba on 7/18/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
PFUser *author;
@dynamic caption;
@dynamic image;
@dynamic username;
@dynamic country;
@dynamic locality;
@dynamic name;
@dynamic postalCode;


+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    NSLog(@"username: %@", newPost.author.username);
    newPost.caption = caption;
    newPost.username = newPost.author.username;
    PFGeoPoint *coordinates = newPost.author[@"coordinates"];
    newPost[@"coordinates"] = coordinates;
    [newPost saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    if (!image)
        return nil;
    
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData)
        return nil;
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end

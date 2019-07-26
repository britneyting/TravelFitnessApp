//
//  MapPinAnnotationView.m
//  Fitness App
//
//  Created by danyguajiba on 7/25/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "MapPinAnnotationView.h"

@implementation MapPinAnnotationView
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation price:(float)price{
    self = [super initWithAnnotation:annotation reuseIdentifier:nil];
    self.canShowCallout = YES; //callout bubble
    self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return self;
}

- (instancetype)initWithImage:(id<MKAnnotation>)annotation image:(UIImage*)image{
    self = [super initWithAnnotation:annotation reuseIdentifier:nil];
    self.canShowCallout = YES;
    self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    self.image = image;
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil){
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside){
        for (UIView *view in self.subviews){
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}
@end

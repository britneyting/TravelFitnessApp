//
//  CustomTextField.m
//  Fitness App
//
//  Created by britneyting on 7/29/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "CustomTextField.h"

@interface CustomTextField()

@property (strong) CAShapeLayer *shapeLayer;

@end

@implementation CustomTextField


- (void)drawRect:(CGRect)rect {
    self.borderStyle = UITextBorderStyleNone;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.frame.size.height - (self.bottomBorderWidth / 2))];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - (self.bottomBorderWidth / 2))];
    
    if (self.shapeLayer != nil) {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    }
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.path = [path CGPath];
    self.shapeLayer.lineWidth = self.bottomBorderWidth;
    self.shapeLayer.strokeColor = self.bottomBorderColor.CGColor;
    self.shapeLayer.fillColor = self.bottomBorderColor.CGColor;
    
    [self.layer addSublayer:self.shapeLayer];
}

@end

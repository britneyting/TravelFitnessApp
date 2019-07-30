//
//  CustomTextField.h
//  Fitness App
//
//  Created by britneyting on 7/29/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CustomTextField : UITextField

@property (nonatomic) IBInspectable UIColor *bottomBorderColor;
@property (nonatomic) IBInspectable CGFloat bottomBorderWidth;

@end

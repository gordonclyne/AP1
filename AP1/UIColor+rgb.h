//
//  UIColor+rgb.h
//  AP1
//
//  Created by Casey Marshall on 9/9/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor (rgb)

- (CGFloat) redValue;
- (CGFloat) greenValue;
- (CGFloat) blueValue;
- (CGFloat) alphaValue;

+ (UIColor *) interpolateFromColor: (UIColor *) startColor
                           toColor: (UIColor *) endColor
                           atIndex: (NSInteger) index
                             steps: (NSInteger) steps;

- (UIColor *) invertWithAlpha: (CGFloat) alpha;

@end

//
//  UIColor+rgb.m
//  AP1
//
//  Created by Casey Marshall on 9/9/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "UIColor+rgb.h"


@implementation UIColor (rgb)

- (CGFloat) redValue
{
    CGColorRef r = [self CGColor];
    const CGFloat *comps = CGColorGetComponents(r);
    if (CGColorGetNumberOfComponents(r) == 2) // grayscale
    {
        return comps[0];
    }
    else // rgba, we hope
    {
        return comps[0];
    }
}

- (CGFloat) greenValue
{
    CGColorRef r = [self CGColor];
    const CGFloat *comps = CGColorGetComponents(r);
    if (CGColorGetNumberOfComponents(r) == 2) // grayscale
    {
        return comps[0];
    }
    else // rgba, we hope
    {
        return comps[1];
    }
}

- (CGFloat) blueValue
{
    CGColorRef r = [self CGColor];
    const CGFloat *comps = CGColorGetComponents(r);
    if (CGColorGetNumberOfComponents(r) == 2) // grayscale
    {
        return comps[0];
    }
    else // rgba, we hope
    {
        return comps[2];
    }
}

- (CGFloat) alphaValue
{
    CGColorRef r = [self CGColor];
    const CGFloat *comps = CGColorGetComponents(r);
    if (CGColorGetNumberOfComponents(r) == 2) // grayscale
    {
        return comps[1];
    }
    else // rgba, we hope
    {
        return comps[3];
    }
}

+ (UIColor *) interpolateFromColor: (UIColor *) startColor
                           toColor: (UIColor *) endColor
                           atIndex: (NSInteger) index
                             steps: (NSInteger) steps
{
    if (steps < 1)
        [[NSException exceptionWithName: @"StepsOutOfRange"
                                 reason: @"steps must be at least 1"
                               userInfo: nil] raise];
    if (index < 0 || index > steps)
        [[NSException exceptionWithName: @"IndexOutOfRange"
                                 reason: [NSString stringWithFormat: @"index must be between 0 and %ld", (long)steps]
                               userInfo: nil] raise];
    
    CGFloat r1 = [startColor redValue];
    CGFloat g1 = [startColor greenValue];
    CGFloat b1 = [startColor blueValue];
    CGFloat a1 = [startColor alphaValue];
    CGFloat r2 = [endColor redValue];
    CGFloat g2 = [endColor greenValue];
    CGFloat b2 = [endColor blueValue];
    CGFloat a2 = [endColor alphaValue];
    
    CGFloat rd = r2 - r1;
    CGFloat gd = g2 - g1;
    CGFloat bd = b2 - b1;
    CGFloat ad = a2 - a1;
    
    UIColor *ret = [UIColor colorWithRed: r1 + (rd / (CGFloat) steps) * (CGFloat) index
                                   green: g1 + (gd / (CGFloat) steps) * (CGFloat) index
                                    blue: b1 + (bd / (CGFloat) steps) * (CGFloat) index
                                   alpha: a1 + (ad / (CGFloat) steps) * (CGFloat) index];
/*#if defined(DEBUG)
    NSLog(@"interpolate %@ to %@, %d/%d (%f, %f, %f), (%f, %f, %f), (%f, %f, %f) -- %@",
          startColor, endColor, index, steps, r1, g1, b1, r2, g2, b2, rd, gd, bd, ret);
#endif*/
    return ret;
}

- (UIColor *) invertWithAlpha: (CGFloat) alpha
{
    return [UIColor colorWithRed: 1.0 - [self redValue]
                           green: 1.0 - [self greenValue]
                            blue: 1.0 - [self blueValue]
                           alpha: alpha];
}

@end

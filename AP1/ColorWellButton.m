//
//  ColorWellButton.m
//  AP1
//
//  Created by Casey Marshall on 9/10/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "ColorWellButton.h"
#import "CGContextAddRoundRect.h"


@implementation ColorWellButton

- (UIColor *) color
{
    return color;
}

- (void) setColor:(UIColor *)c
{
    if (color != nil)
        [color release];
    color = c;
    if (color != nil)
        [color retain];
    [self setNeedsDisplay];
}

- (void) drawRect: (CGRect) rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: rect
    //                                                cornerRadius: 7.0];
    
    //CGContextAddPath(ctx, [path CGPath]);
    CGContextAddRoundedRect(ctx, rect, 7.0);
    CGContextSetFillColorWithColor(ctx, [self.color CGColor]);
    CGContextFillPath(ctx);
    CGContextAddRoundedRect(ctx, rect, 7.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor lightGrayColor] CGColor]);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextStrokePath(ctx);
}

- (void) dealloc
{
    if (color != nil) [color release];
    [super dealloc];
}

@end

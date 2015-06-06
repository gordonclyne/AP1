//
//  RGBSliderView.m
//  AP1
//
//  Created by Casey Marshall on 9/9/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "RGBSliderView.h"
#import "CGContextAddRoundRect.h"

#define isInside(point,rect) (((point).x >= (rect).origin.x) && ((point).x <= ((rect).origin.x + (rect).size.width)) \
                              && ((point).y >= (rect).origin.y) && ((point).y <= ((rect).origin.y + (rect).size.height)))

@implementation RGBSliderView

@synthesize delegate;

@synthesize mode;

- (CGFloat) red { return red; }
- (CGFloat) green { return green; }
- (CGFloat) blue { return blue; }
- (CGFloat) opacity { return opacity; }

- (void) setRed:(CGFloat)r
{
    if (red != r)
    {
        red = r;
        [self setNeedsDisplay];
    }
}

- (void) setGreen:(CGFloat)g
{
    if (green != g)
    {
        green = g;
        [self setNeedsDisplay];
    }
}

- (void) setBlue:(CGFloat)b
{
    if (blue != b)
    {
        blue = b;
        [self setNeedsDisplay];
    }
}

- (void) setOpacity:(CGFloat)o
{
    if (opacity != o)
    {
        opacity = o;
        [self setNeedsDisplay];
    }
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect: (CGRect) rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity: 2];
    
    //UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: rect
    //                                                cornerRadius: 7.0];
    CGContextSaveGState(ctx);
    //CGContextAddPath(ctx, [path CGPath]);
    CGContextAddRoundedRect(ctx, rect, 7.0);
    CGContextClip(ctx);
    
    // Draw checkerboard underneath to show opacity.
    if (mode == RGBSliderModeOpacity)
    {
        CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(ctx, rect);
        BOOL r = YES;
        BOOL c = YES;
        CGFloat rw = 10;
        CGContextSetFillColorWithColor(ctx, [[UIColor lightGrayColor] CGColor]);
        for (CGFloat x = 0; x < rect.size.width; x += rw)
        {
            for (CGFloat y = 0; y < rect.size.height; y += rw)
            {
                if ((r && c) || (!r && !c))
                    CGContextFillRect(ctx, CGRectMake(x, y, rw, rw));
                r = !r;
            }
            c = !c;
        }
    }
    
    switch (mode)
    {
        case RGBSliderModeRed:
            [colors addObject: (id) [[UIColor colorWithRed: 0.0
                                                     green: green
                                                      blue: blue
                                                     alpha: 1.0] CGColor]];
            [colors addObject: (id) [[UIColor colorWithRed: 1.0
                                                     green: green
                                                      blue: blue
                                                     alpha: 1.0] CGColor]];
            break;
        case RGBSliderModeGreen:
            [colors addObject: (id) [[UIColor colorWithRed: red
                                                     green: 0.0
                                                      blue: blue
                                                     alpha: 1.0] CGColor]];
            [colors addObject: (id) [[UIColor colorWithRed: red
                                                     green: 1.0
                                                      blue: blue
                                                     alpha: 1.0] CGColor]];
            break;
        case RGBSliderModeBlue:
            [colors addObject: (id) [[UIColor colorWithRed: red
                                                     green: green
                                                      blue: 0.0
                                                     alpha: 1.0] CGColor]];
            [colors addObject: (id) [[UIColor colorWithRed: red
                                                     green: green
                                                      blue: 1.0
                                                     alpha: 1.0] CGColor]];
            break;
        case RGBSliderModeOpacity:
            [colors addObject: (id) [[UIColor colorWithRed: red
                                                     green: green
                                                      blue: blue
                                                     alpha: 0.0] CGColor]];
            [colors addObject: (id) [[UIColor colorWithRed: red
                                                     green: green
                                                      blue: blue
                                                     alpha: 1.0] CGColor]];
            break;
    }
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (CFArrayRef) colors, NULL);
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, self.center.y),
                                CGPointMake(self.bounds.size.width, self.center.y),
                                0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(space);
    
    UIColor *invert = [UIColor colorWithRed: 1.0 - red
                                      green: 1.0 - green
                                       blue: 1.0 - blue
                                      alpha: 1.0];
    CGContextSetStrokeColorWithColor(ctx, [invert CGColor]);
    CGContextSetLineWidth(ctx, 2.0);
    CGPoint points[2];
    switch (mode)
    {
        case RGBSliderModeRed:
            points[0] = CGPointMake(self.bounds.size.width * red, 0);
            points[1] = CGPointMake(self.bounds.size.width * red,
                                    self.bounds.size.height);
            break;
        case RGBSliderModeGreen:
            points[0] = CGPointMake(self.bounds.size.width * green, 0);
            points[1] = CGPointMake(self.bounds.size.width * green,
                                    self.bounds.size.height);
            break;
        case RGBSliderModeBlue:
            points[0] = CGPointMake(self.bounds.size.width * blue, 0);
            points[1] = CGPointMake(self.bounds.size.width * blue,
                                    self.bounds.size.height);
            break;
        case RGBSliderModeOpacity:
            points[0] = CGPointMake(self.bounds.size.width * opacity, 0);
            points[1] = CGPointMake(self.bounds.size.width * opacity,
                                    self.bounds.size.height);
            
            break;
    }
    CGContextStrokeLineSegments(ctx, (const CGPoint *) points, 2);
    
    //CGContextAddPath(ctx, [path CGPath]);
    CGContextAddRoundedRect(ctx, rect, 7.0);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor lightGrayColor] CGColor]);
    //CGContextAddPath(ctx, [path CGPath]);
    CGContextAddRoundedRect(ctx, rect, 7.0);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

#pragma mark -
#pragma mark Touch Handling

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint loc = [touch locationInView: self];
        if (isInside(loc, self.bounds))
        {
            CGFloat value = loc.x / self.bounds.size.width;
            switch (mode) {
                case RGBSliderModeRed:
                    self.red = value;
                    break;
                case RGBSliderModeGreen:
                    self.green = value;
                    break;
                case RGBSliderModeBlue:
                    self.blue = value;
                    break;
                case RGBSliderModeOpacity:
                    self.opacity = value;
                    break;
            }
            if (delegate != nil)
                [delegate sliderView: self
                    didChangeToValue: value];
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint loc = [touch locationInView: self];
        if (isInside(loc, self.bounds))
        {
            CGFloat value = loc.x / self.bounds.size.width;
            switch (mode) {
                case RGBSliderModeRed:
                    self.red = value;
                    break;
                case RGBSliderModeGreen:
                    self.green = value;
                    break;
                case RGBSliderModeBlue:
                    self.blue = value;
                    break;
                case RGBSliderModeOpacity:
                    self.opacity = value;
                    break;
            }
            if (delegate != nil)
                [delegate sliderView: self
                    didChangeToValue: value];
        }
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint loc = [touch locationInView: self];
        if (isInside(loc, self.bounds))
        {
            CGFloat value = loc.x / self.bounds.size.width;
            switch (mode) {
                case RGBSliderModeRed:
                    self.red = value;
                    break;
                case RGBSliderModeGreen:
                    self.green = value;
                    break;
                case RGBSliderModeBlue:
                    self.blue = value;
                    break;
                case RGBSliderModeOpacity:
                    self.opacity = value;
                    break;
            }
            if (delegate != nil)
                [delegate sliderView: self
                    didChangeToValue: value];
        }
    }
}

- (void)dealloc {
    [super dealloc];
}


@end

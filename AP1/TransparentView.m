//
//  TransparentView.m
//  AP1
//
//  Created by Casey Marshall on 9/9/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "TransparentView.h"


@implementation TransparentView

@synthesize forwardingResponder;
@synthesize forwarding;
@synthesize forwardingBottomHeight;

@synthesize trackingGridWidth;

- (BOOL) isGridOn
{
    return gridOn;
}

- (void) setIsGridOn:(BOOL) on
{
    if (gridOn != on)
    {
        gridOn = on;
        [self setNeedsDisplay];
    }
}

- (CGFloat) gridWidth
{
    return gridWidth;
}

- (void) setGridWidth:(CGFloat) w
{
    if (w != gridWidth)
    {
        gridWidth = w;
        [self setNeedsDisplay];
    }
}

- (UIColor *) gridColor
{
    return gridColor;
}

- (void) setGridColor:(UIColor *) c
{
    if (gridColor != nil)
        [gridColor release];
    gridColor = c;
    if (gridColor != nil)
        [gridColor retain];
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


// Here the grid is drawn
- (void)drawRect:(CGRect)rect
{
    if (self.isGridOn)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGContextSetStrokeColorWithColor(ctx, [self.gridColor CGColor]);
        for (CGFloat x = 0; x < rect.size.width; x += self.gridWidth)
        {
            CGContextMoveToPoint(ctx, x, 0);
            CGContextAddLineToPoint(ctx, x, rect.size.height);
            CGContextStrokePath(ctx);
        }
        for (CGFloat y = 0; y < rect.size.height; y += self.gridWidth)
        {
            CGContextMoveToPoint(ctx, 0, y);
            CGContextAddLineToPoint(ctx, rect.size.width, y);
            CGContextStrokePath(ctx);
        }
    }
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark Touch Handling

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    trackingGridWidth = gridWidth;
    if (forwarding)
    {
        [forwardingResponder touchesBegan: touches withEvent: event];
        return;
    }
    NSMutableSet *toForward = [NSMutableSet setWithCapacity: [touches count]];
    
    for (UITouch *touch in touches)
    {
        CGPoint p = [touch locationInView: self];
        if (p.y < self.bounds.size.height - forwardingBottomHeight)
            [toForward addObject: touch];
    }
    
    [forwardingResponder touchesBegan: toForward withEvent: event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (forwarding)
    {
        [forwardingResponder touchesEnded: touches withEvent: event];
        return;
    }
    NSMutableSet *toForward = [NSMutableSet setWithCapacity: [touches count]];
    
    for (UITouch *touch in touches)
    {
        CGPoint p = [touch locationInView: self];
        if (p.y < self.bounds.size.height - forwardingBottomHeight)
            [toForward addObject: touch];
    }
    
    [forwardingResponder touchesEnded: toForward withEvent: event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (forwarding)
    {
        [forwardingResponder touchesMoved: touches withEvent: event];
        return;
    }
    NSMutableSet *toForward = [NSMutableSet setWithCapacity: [touches count]];
    
    for (UITouch *touch in touches)
    {
        CGPoint p = [touch locationInView: self];
        if (p.y < self.bounds.size.height - forwardingBottomHeight)
            [toForward addObject: touch];
    }
    
    [forwardingResponder touchesMoved: toForward withEvent: event];
}

@end

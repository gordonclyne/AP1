//
//  CrosshairView.m
//  AP1
//
//  Created by Casey Marshall on 9/21/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "CrosshairView.h"


@implementation CrosshairView

@synthesize container;

- (CGPoint) firstPoint
{
    return firstPoint;
}

- (void) setFirstPoint:(CGPoint) p
{
    firstPoint = p;
    [self setNeedsDisplay];
}

- (CGPoint) secondPoint
{
    return secondPoint;
}

- (void) setSecondPoint:(CGPoint) p
{
    secondPoint = p;
    [self setNeedsDisplay];
}

- (void) setFirstPoint:(CGPoint) p1
           secondPoint: (CGPoint) p2
{
    firstPoint = p1;
    secondPoint = p2;
    [self setNeedsDisplay];
}

- (UIColor *) strokeColor
{
    return strokeColor;
}

- (void) setStrokeColor:(UIColor *) c
{
    if (strokeColor != nil)
        [strokeColor release];
    strokeColor = c;
    if (strokeColor != nil)
        [strokeColor retain];
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]))
    {
        firstPoint = CGInvalidPoint;
        secondPoint = CGInvalidPoint;
        strokeColor = [[UIColor whiteColor] retain];
    }
    return self;
}

static CGFloat
xh1()
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 44.0;
    else
        return 22.0;
}

static CGFloat
xh2()
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 30;
    return 15;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [strokeColor CGColor]);
    if (!isInvalidCGPoint(firstPoint))
    {
        CGPoint p = firstPoint;
        if (!isInvalidCGPoint(secondPoint))
        {
            p = secondPoint;
            CGContextMoveToPoint(ctx, firstPoint.x, firstPoint.y);
            CGContextAddLineToPoint(ctx, secondPoint.x, secondPoint.y);
            CGContextStrokePath(ctx);
        }
        
        CGMutablePathRef xhair = CGPathCreateMutable();
        const CGPoint xp[] = { CGPointMake(p.x - xh1(), p.y), CGPointMake(p.x + xh1(), p.y) };
        const CGPoint yp[] = { CGPointMake(p.x, p.y - xh1()), CGPointMake(p.x, p.y + xh1()) };
        
        CGPathAddEllipseInRect(xhair, NULL, CGRectMake(p.x-xh2(), p.y-xh2(), (2 * xh2()), (2 * xh2())));
        CGPathCloseSubpath(xhair);
        CGPathMoveToPoint(xhair, NULL, xp[0].x, xp[0].y);
        CGPathAddLineToPoint(xhair, NULL, xp[1].x, xp[1].y);
        CGPathMoveToPoint(xhair, NULL, yp[0].x, yp[0].y);
        CGPathAddLineToPoint(xhair, NULL, yp[1].x, yp[1].y);
        CGContextAddPath(ctx, xhair);
        CGContextStrokePath(ctx);
        CGPathRelease(xhair);
    }
}

- (void)dealloc {
    [strokeColor release];
    [super dealloc];
}

// FUCK THIS IS LAME

- (void) touchesBegan: (NSSet *) touches
            withEvent: (UIEvent *) event
{
    [self.container touchesBegan:touches withEvent: event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.container touchesEnded:touches withEvent: event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.container touchesMoved: touches withEvent: event];
}

@end

//
//  ColorWellView.m
//  AP1
//
//  Created by Casey Marshall on 9/10/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "ColorWellView.h"
#import "UIColor+rgb.h"
#import "CGContextAddRoundRect.h"

@implementation ColorWellView

@synthesize delegate;

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

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: rect
    //                                                cornerRadius: 7.0];
    if ([self.color alphaValue] < 1.0)
    {
        CGContextSaveGState(ctx);
        //CGContextAddPath(ctx, [path CGPath]);
        CGContextAddRoundedRect(ctx, rect, 7.0);
        CGContextClip(ctx);
        CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(ctx, rect);
        CGContextSetFillColorWithColor(ctx, [[UIColor lightGrayColor] CGColor]);
        CGFloat f = 10;
        BOOL c = YES;
        BOOL r = YES;
        for (CGFloat x = 0; x < rect.size.width; x += f)
        {
            for (CGFloat y = 0; y < rect.size.height; y += f)
            {
                if ((c && r) || (!c && !r))
                    CGContextFillRect(ctx, CGRectMake(x, y, f, f));
                r = !r;
            }
            c = !c;
        }
        
        CGContextSetFillColorWithColor(ctx, [self.color CGColor]);
        CGContextFillRect(ctx, rect);
        
        CGMutablePathRef path2 = CGPathCreateMutable();
        CGPathMoveToPoint(path2, NULL, 0, 0);
        CGPathAddLineToPoint(path2, NULL, rect.size.width, 0);
        CGPathAddLineToPoint(path2, NULL, 0, rect.size.height);
        CGPathCloseSubpath(path2);
        CGContextAddPath(ctx, path2);        
        CGContextSetFillColorWithColor(ctx, [[self.color colorWithAlphaComponent: 1.0] CGColor]);
        CGContextFillPath(ctx);
        CGPathRelease(path2);
        
        CGContextRestoreGState(ctx);
    }
    else
    {
        CGContextSetFillColorWithColor(ctx, [self.color CGColor]);
        //CGContextAddPath(ctx, [path CGPath]);
        CGContextAddRoundedRect(ctx, rect, 7.0);
        CGContextFillPath(ctx);
    }
    
    //CGContextAddPath(ctx, [path CGPath]);
    CGContextAddRoundedRect(ctx, rect, 7.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor lightGrayColor] CGColor]);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextStrokePath(ctx);
}

- (void)dealloc {
    [color release];
    [super dealloc];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded:%@ withEvent:%@", touches, event);
    for (UITouch *touch in touches)
    {
        CGPoint p = [touch locationInView: self];
        if (p.x >= 0 && p.y >= 0 && p.x < self.bounds.size.width
            && p.y < self.bounds.size.height)
        {
            NSLog(@"touch inside -- %@", delegate);
            if (delegate != nil)
                [delegate colorWellTouchUpInside: self];
        }
    }
}

@end

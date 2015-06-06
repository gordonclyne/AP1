//
//  APSegmentedControl.m
//  AP1
//
//  Created by Casey Marshall on 9/14/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "APSegmentedControl.h"


@implementation APSegmentedControl

- (void) setSelectedSegmentIndex:(NSInteger) index
{
    if (index == self.selectedSegmentIndex)
    {
        [self sendActionsForControlEvents: UIControlEventValueChanged];
    }
    [super setSelectedSegmentIndex: index];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self sendActionsForControlEvents: UIControlEventTouchDown];
    [super touchesBegan:touches withEvent: event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL inside = NO;
    for (UITouch *t in touches)
    {
        CGPoint p = [t locationInView: self];
        if (p.x >= self.bounds.origin.x && p.y >= self.bounds.origin.y
            && p.x < self.bounds.size.width && p.y < self.bounds.size.height)
        {
            inside = YES;
        }
    }
    
    if (inside)
        [self sendActionsForControlEvents: UIControlEventTouchUpInside];
    else
        [self sendActionsForControlEvents: UIControlEventTouchUpOutside];
    [super touchesEnded: touches withEvent: event];
}

@end

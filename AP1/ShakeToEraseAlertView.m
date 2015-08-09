//
//  ShakeToEraseAlertView.m
//  AP1
//
//  Created by Casey Marshall on 9/12/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "ShakeToEraseAlertView.h"


@implementation ShakeToEraseAlertView

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"alertView motionEnded:%ld withEvent:%@", (long)motion, event);
    [super motionEnded: motion
             withEvent: event];
    if (motion == UIEventSubtypeMotionShake)
    {
        [self dismissWithClickedButtonIndex: 1
                                   animated: YES];
    }
}

@end

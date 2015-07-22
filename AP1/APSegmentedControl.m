//
//  APSegmentedControl.m
//  AP1
//
//  Created by Casey Marshall on 9/14/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "APSegmentedControl.h"


@implementation APSegmentedControl


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
    [super touchesEnded:touches withEvent:event];
    
    if (previousSelectedSegmentIndex == self.selectedSegmentIndex) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end

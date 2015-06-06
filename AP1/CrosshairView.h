//
//  CrosshairView.h
//  AP1
//
//  Created by Casey Marshall on 9/21/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvalidPoint.h"

@interface CrosshairView : UIView
{
    UIView *container;
    UIColor *strokeColor;
    CGPoint firstPoint;
    CGPoint secondPoint;
}

@property (assign) UIView *container;
@property (retain) UIColor *strokeColor;
@property (assign) CGPoint firstPoint;
@property (assign) CGPoint secondPoint;

- (void) setFirstPoint: (CGPoint) p1
           secondPoint: (CGPoint) p2;

@end

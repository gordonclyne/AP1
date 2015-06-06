//
//  TransparentView.h
//  AP1
//
//  Created by Casey Marshall on 9/9/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TransparentView : UIView
{
    UIResponder *forwardingResponder;
    BOOL forwarding;
    CGFloat forwardingBottomHeight;
    
    CGFloat gridWidth;
    BOOL gridOn;
    UIColor *gridColor;
    
    CGFloat trackingGridWidth;
}

@property (retain) UIResponder *forwardingResponder;
@property (assign) BOOL forwarding;
@property (assign) CGFloat forwardingBottomHeight;

@property (assign) BOOL isGridOn;
@property (assign) CGFloat gridWidth;
@property (retain) UIColor *gridColor;
@property (readonly) CGFloat trackingGridWidth;

@end

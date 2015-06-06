//
//  ColorWellView.h
//  AP1
//
//  Created by Casey Marshall on 9/10/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorWellView;
@protocol ColorWellTouchDelegate

- (void) colorWellTouchUpInside: (ColorWellView *) sender;

@end


@interface ColorWellView : UIView
{
    UIColor *color;
    id<ColorWellTouchDelegate> delegate;
}

@property (retain) UIColor *color;
@property (assign) id<ColorWellTouchDelegate> delegate;

@end

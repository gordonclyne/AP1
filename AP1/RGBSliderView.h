//
//  RGBSliderView.h
//  AP1
//
//  Created by Casey Marshall on 9/9/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RGBSliderView;
@protocol RGBSliderViewDelegate

- (void) sliderView: (RGBSliderView *) sliderView
   didChangeToValue: (CGFloat) value;

@end


typedef enum RGBSliderMode
{
    RGBSliderModeRed,
    RGBSliderModeGreen,
    RGBSliderModeBlue,
    RGBSliderModeOpacity
} RGBSliderMode;

@interface RGBSliderView : UIView
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat opacity;
    
    RGBSliderMode mode;
    
    id<RGBSliderViewDelegate> delegate;
}

@property (assign) CGFloat red;
@property (assign) CGFloat green;
@property (assign) CGFloat blue;
@property (assign) CGFloat opacity;
@property (assign) RGBSliderMode mode;
@property (assign) IBOutlet id<RGBSliderViewDelegate> delegate;

@end

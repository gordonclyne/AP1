//
//  ColorPickerViewController.h
//  AP1
//
//  Created by Casey Marshall on 9/8/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RGBSliderView.h"
#import "ColorWellView.h"

@interface ColorPickerViewController : UIViewController <RGBSliderViewDelegate>
{
    IBOutlet ColorWellView *colorView;
    IBOutlet RGBSliderView *redSlider;
    IBOutlet RGBSliderView *greenSlider;
    IBOutlet RGBSliderView *blueSlider;
    IBOutlet RGBSliderView *opacitySlider;
    
    UIColor *selectedColor;
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat opacity;
    
    id colorChosenTarget;
    SEL colorChosenAction;
}

@property (readonly) ColorWellView *colorWell;

@property (assign) UIColor *selectedColor;

@property (assign) CGFloat red;
@property (assign) CGFloat green;
@property (assign) CGFloat blue;
@property (assign) CGFloat opacity;

@property (assign) id colorChosenTarget;
@property (assign) SEL colorChosenAction;

// iPhone interface actions:

- (IBAction) cancelButtonTapped: (id) sender;
- (IBAction) doneButtonTapped: (id) sender;

@end

//
//  ColorPickerViewController.m
//  AP1
//
//  Created by Casey Marshall on 9/8/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "UIColor+rgb.h"

@implementation ColorPickerViewController

@synthesize colorWell = colorView;

@synthesize colorChosenTarget;
@synthesize colorChosenAction;

- (UIColor *) selectedColor
{
    return [UIColor colorWithRed: red
                           green: green
                            blue: blue
                           alpha: opacity];
}

- (void) setSelectedColor:(UIColor *) c
{
    self.red = [c redValue];
    self.green = [c greenValue];
    self.blue = [c blueValue];
    self.opacity = [c alphaValue];
}

- (CGFloat) red { return red; }
- (CGFloat) green { return green; }
- (CGFloat) blue { return blue; }
- (CGFloat) opacity { return opacity; }

- (void) setRed:(CGFloat) r
{
    if (red != r)
    {
        red = r;
        greenSlider.red = r;
        blueSlider.red = r;
        opacitySlider.red = r;
        colorView.color = self.selectedColor;
    }
}

- (void) setGreen:(CGFloat)g
{
    if (green != g)
    {
        green = g;
        redSlider.green = g;
        blueSlider.green = g;
        opacitySlider.green = g;
        colorView.color = self.selectedColor;
    }
}

- (void) setBlue:(CGFloat)b
{
    if (blue != b)
    {
        blue = b;
        redSlider.blue = b;
        greenSlider.blue = b;
        opacitySlider.blue = b;
        colorView.color = self.selectedColor;
    }
}

- (void) setOpacity:(CGFloat)o
{
    if (opacity != o)
    {
        opacity = o;
        colorView.color = self.selectedColor;
    }
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;    
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    redSlider.mode = RGBSliderModeRed;
    greenSlider.mode = RGBSliderModeGreen;
    blueSlider.mode = RGBSliderModeBlue;
    opacitySlider.mode = RGBSliderModeOpacity;
    
    redSlider.backgroundColor = [UIColor clearColor];
    redSlider.red = self.red;
    redSlider.green = self.green;
    redSlider.blue = self.blue;
    redSlider.opacity = 1.0;
    
    greenSlider.backgroundColor = [UIColor clearColor];
    greenSlider.red = self.red;
    greenSlider.blue = self.blue;
    greenSlider.green = self.green;
    greenSlider.opacity = 1.0;
    
    blueSlider.backgroundColor = [UIColor clearColor];
    blueSlider.red = self.red;
    blueSlider.green = self.green;
    blueSlider.blue = self.blue;
    blueSlider.opacity = 1.0;
    
    opacitySlider.backgroundColor = [UIColor clearColor];
    opacitySlider.red = self.red;
    opacitySlider.green = self.green;
    opacitySlider.blue = self.blue;
    opacitySlider.opacity = self.opacity;
    
    colorView.backgroundColor = [UIColor clearColor];
    colorView.color = self.selectedColor;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    if (colorView != nil) [colorView release];
    if (redSlider != nil) [redSlider release];
    if (greenSlider != nil) [greenSlider release];
    if (blueSlider != nil) [blueSlider release];
    if (opacitySlider != nil) [opacitySlider release];
    [super dealloc];
}

- (void) sliderView: (RGBSliderView *) sliderView
   didChangeToValue: (CGFloat) value
{
    if (sliderView == redSlider)
    {
        self.red = redSlider.red;
    }
    if (sliderView == greenSlider)
    {
        self.green = greenSlider.green;
    }
    if (sliderView == blueSlider)
    {
        self.blue = blueSlider.blue;
    }
    if (sliderView == opacitySlider)
    {
        self.opacity = opacitySlider.opacity;
    }
}

- (IBAction) cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction) doneButtonTapped: (id) sender
{
    if (colorChosenTarget != nil)
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: [((NSObject *) colorChosenTarget) methodSignatureForSelector: colorChosenAction]];
        [invocation setTarget: colorChosenTarget];
        [invocation setSelector: colorChosenAction];
        [invocation setArgument: &self
                        atIndex: 2];
        UIColor *color = self.selectedColor;
        [invocation setArgument: &color
                        atIndex: 3];
        [invocation invoke];
    }
    [self dismissViewControllerAnimated: YES completion: nil];
}

@end

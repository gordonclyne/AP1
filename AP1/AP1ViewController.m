//
//  AP1ViewController.m
//  AP1
//
//  Created by Casey Marshall on 8/30/10.
//  Copyright Modal Domains 2010. All rights reserved.
//

#import "AP1ViewController.h"
#import "CanvasView.h"
#import "ColorPickerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ShakeToEraseAlertView.h"
#import "UIColor+rgb.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
//#import "hpdf.h"

@implementation AP1ViewController

@synthesize canvas;
#define kPaperSizeA4 CGSizeMake(595.2,841.8)
#define kPaperSizeA2 CGSizeMake(1191,1684)

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(bool)preferStatusBarHidden
{
    return YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.transparentView = [[TransparentView alloc] initWithFrame:self.view.frame];
    [self.transparentView setBackgroundColor:[UIColor clearColor]];
    self.transparentView.forwardingResponder = canvas;
    self.transparentView.forwarding = YES;
    self.transparentView.gridWidth = 25.0;
    self.transparentView.isGridOn = NO;
    self.transparentView.gridColor = [UIColor colorWithRed:0.960 green:0.730 blue:0.730 alpha:1.000];
    self.transparentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_transparentView];
    
    [self.view bringSubviewToFront:settingsView];
    [self.view bringSubviewToFront:toolbar];
    
    /************ Hidden save to PDF Feature **********/
    UILongPressGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(createPDF:)];
    lpgr.minimumPressDuration = 3.0f;
    lpgr.allowableMovement = 100.0f;
    UIView *buttonView = [takePictureItem valueForKey:@"view"];
    [buttonView addGestureRecognizer:lpgr];
    
    /***************** Further Setup *****************/
    
    leftLinesSlider.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    //leftLinesSlider.transform = CGAffineTransformMakeRotation(3.14159);
    
    backgroundColorButton.backgroundColor = [UIColor clearColor];
    leftLineColorButton.backgroundColor = [UIColor clearColor];
    rightLineColorButton.backgroundColor = [UIColor clearColor];
    leftOutlierColorButton.backgroundColor = [UIColor clearColor];
    rightOutlierColorButton.backgroundColor = [UIColor clearColor];
    
    UIPinchGestureRecognizer *pgr = [[UIPinchGestureRecognizer alloc] initWithTarget: self
                                                                              action: @selector(handlePinch:)];
    [self.view addGestureRecognizer: pgr];
    [pgr release];
    [utilityControl setSelectedSegmentIndex: UISegmentedControlNoSegment];
	
	NSBundle *bundle = [NSBundle mainBundle];
	[versionLabel setText: [NSString stringWithFormat: @"%@ (%@)",
							[bundle objectForInfoDictionaryKey: @"CFBundleShortVersionString"],
							[bundle objectForInfoDictionaryKey: @"CFBundleVersion"]]];
    
    
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    CGAffineTransform targetRotation = [coordinator targetTransform];
    CGAffineTransform inverseRotation = CGAffineTransformInvert(targetRotation);
    
    [_transparentView setNeedsDisplay];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        self.canvas.transform = CGAffineTransformConcat(self.canvas.transform, inverseRotation);
        
        self.canvas.frame = self.view.bounds;
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    }];
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    
//    CGFloat origin = ABS(self.view.frame.size.height - self.view.frame.size.width);
//    
//    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
//        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
//    {
//        CGRect frame = canvas.frame;
//        frame.origin.x = 0;
//        frame.origin.y = -origin/2;
//        canvas.frame = frame;
//    }
//    else
//    {
//        
//        CGRect frame = canvas.frame;
//        frame.origin.x = -origin/2;
//        frame.origin.y = 0;
//        canvas.frame = frame;
//    }
//    
//    
//}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"mainController motionEnded: %d withEvent: %@", motion, event);
    if (motion == UIEventSubtypeMotionShake)
    {
        // Note, this does not work. We can't seem to get motion events while
        // the alert view is being displayed.
        if (eraseImageAlert != nil)
        {
            [eraseImageAlert dismissWithClickedButtonIndex: 1
                                                  animated: YES];            
        }
        else
        {
            eraseImageAlert = [[UIAlertView alloc] initWithTitle: nil
                                                         message: NSLocalizedString(@"Erase the current drawing?", @"erase message")
                                                        delegate: self
                                               cancelButtonTitle: @"Keep"
                                               otherButtonTitles: @"Erase", nil];
            [eraseImageAlert show];
        }
    }
}

- (void)dealloc {
    [super dealloc];
}

- (BOOL) canPrint
{
    CGFloat sysversion = [[[UIDevice currentDevice] systemVersion] floatValue];
	NSLog(@"sysversion %f", sysversion);
	if (sysversion >= 4.19)
	{
		BOOL canPrint = [UIPrintInteractionController isPrintingAvailable];
		NSLog(@"sysversion %f canPrint %d", sysversion, canPrint);
		return [UIPrintInteractionController isPrintingAvailable];
	}
	return NO;
}

- (IBAction) shareItemTapped: (id) sender
{

    CGFloat imgWidth = canvas.bounds.size.width;
    CGFloat imgHeight = canvas.bounds.size.height;
    CGFloat scale = 1.0;
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(imgHeight, imgWidth), NO, scale);
    else
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(imgWidth, imgHeight), NO, scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    switch ([[UIDevice currentDevice] orientation])
    {
        case UIDeviceOrientationPortraitUpsideDown:
            CGContextRotateCTM(ctx, 3.14159);
            CGContextTranslateCTM(ctx, -imgWidth, -imgHeight);
            break;
        case UIDeviceOrientationLandscapeLeft:
            //NSLog(@"landscape left");
            CGContextRotateCTM(ctx, -3.14159 / 2);
            CGContextTranslateCTM(ctx, -imgWidth, 0);
            break;
        case UIDeviceOrientationLandscapeRight:
            //NSLog(@"landscape right");
            CGContextRotateCTM(ctx, 3.14159 / 2);
            CGContextTranslateCTM(ctx, 0, -imgHeight);
            break;
    }
    [canvas.layer renderInContext: ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:@[@"Created with Artonics",image] applicationActivities:nil];
    activityVC.popoverPresentationController.barButtonItem = shareItem;
    [self presentViewController:activityVC animated:YES completion:nil];
    
    
}

- (IBAction) takePictureItemTapped: (id) sender
{
    CGFloat sysversion = [[[UIDevice currentDevice] systemVersion] floatValue];
	NSLog(@"can send email %d sysversion %f", [MFMailComposeViewController canSendMail], sysversion);
	if (sysversion >= 4.19 && [self canPrint])
        saveImageActionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                           delegate: self
                                                  cancelButtonTitle: NSLocalizedString(@"Cancel", @"Cancel")
                                             destructiveButtonTitle: nil
                                                  otherButtonTitles:
								NSLocalizedString(@"Save To Photos", @"Save To Photo Library"),
								NSLocalizedString(@"Email This", @"Email This"),
								NSLocalizedString(@"Submit to Gallery", @"Submit to Gallery"),
                                NSLocalizedString(@"Save High-res PNG", @"Save High-res PNG"),
								NSLocalizedString(@"Print", @"Print"),
								nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [saveImageActionSheet showFromBarButtonItem: takePictureItem
                                           animated: YES];
    else
        [saveImageActionSheet showInView: self.view];
    
}


- (IBAction) settingsItemTapped: (id) sender
{
    if (saveImageActionSheet != nil)
    {
        [saveImageActionSheet dismissWithClickedButtonIndex: [saveImageActionSheet cancelButtonIndex]
                                                   animated: YES];
    }
    
    if (!showingSettings)
    {
        [leftLinesSlider setValue: canvas.leftOutlierCount
                         animated: YES];
        [rightLinesSlider setValue: canvas.rightOutlierCount
                          animated: YES];
        [lineCountSlider setValue: canvas.lineCount
                         animated: YES];
        [lineSizeSlider setValue: canvas.lineThickness
                        animated: YES];
        [curvedJointControl setSelectedSegmentIndex: canvas.curvedJoints ? 1 : 0];
        [backgroundColorButton setColor: canvas.backgroundColor];
        [leftLineColorButton setColor: canvas.leftLineColor];
        [rightLineColorButton setColor: canvas.rightLineColor];
        [leftOutlierColorButton setColor: canvas.leftOutlierColor];
        [rightOutlierColorButton setColor: canvas.rightOutlierColor];
        
        [UIView beginAnimations: @"slideUpSettings" context: NULL];
        [UIView setAnimationDuration: 0.5];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        
        CGRect frame = settingsView.bounds;
        toolbar.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
        settingsView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
        
        [UIView commitAnimations];
        _transparentView.forwarding = NO;
        _transparentView.forwardingBottomHeight = settingsView.bounds.size.height + toolbar.bounds.size.height;
        showingSettings = YES;
    }
    else
    {
        [UIView beginAnimations: @"slideDownSettings" context: NULL];
        [UIView setAnimationDuration: 0.5];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        
        toolbar.transform = CGAffineTransformIdentity;
        settingsView.transform = CGAffineTransformIdentity;
        
        [UIView commitAnimations];
        _transparentView.forwarding = YES;
        showingSettings = NO;
    }
}

- (IBAction) leftOutlierSliderChanged: (id) sender
{
    canvas.leftOutlierCount = (NSInteger) [leftLinesSlider value];
}

- (IBAction) lineCountSliderChanged: (id) sender
{
    canvas.lineCount = (NSInteger) [lineCountSlider value];
}

- (IBAction) rightOutlierSliderChanged: (id) sender
{
    canvas.rightOutlierCount = (NSInteger) [rightLinesSlider value];
}

- (IBAction) backgroundColorButtonTapped: (id) sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        ColorPickerViewController *cpvc = [[ColorPickerViewController alloc] initWithNibName: @"ColorPickerViewController"
                                                                                      bundle: nil];
        cpvc.selectedColor = canvas.backgroundColor;
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController: cpvc];
        pop.popoverContentSize = cpvc.view.bounds.size;
        pop.delegate = self;
        chooserTarget = ColorChooserTargetBackground;
        [pop presentPopoverFromRect: backgroundColorButton.bounds
                             inView: backgroundColorButton
           permittedArrowDirections: UIPopoverArrowDirectionAny
                           animated: YES];
        colorPickerPopover = pop;
        cpvc.colorWell.delegate = self;
        [cpvc release];
    }
    else
    {
        ColorPickerViewController *cpvc = [[ColorPickerViewController alloc] initWithNibName: @"ColorPickerViewController-iPhone"
                                                                                      bundle: nil];
        cpvc.selectedColor = canvas.backgroundColor;
        cpvc.colorChosenTarget = self;
        cpvc.colorChosenAction = @selector(colorPicker:didChooseColor:);
        chooserTarget = ColorChooserTargetBackground;
        [self presentModalViewController: cpvc
                                animated: YES];
    }
}

- (IBAction) leftLineColorButtonTapped: (id) sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        ColorPickerViewController *cpvc = [[ColorPickerViewController alloc] initWithNibName: @"ColorPickerViewController"
                                                                                      bundle: nil];
        cpvc.selectedColor = canvas.leftLineColor;
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController: cpvc];
        pop.popoverContentSize = cpvc.view.bounds.size;
        pop.delegate = self;
        chooserTarget = ColorChooserTargetLeftLine;
        [pop presentPopoverFromRect: leftLineColorButton.bounds
                             inView: leftLineColorButton
           permittedArrowDirections: UIPopoverArrowDirectionAny
                           animated: YES];
        colorPickerPopover = pop;
        cpvc.colorWell.delegate = self;
        [cpvc release];
    }
    else
    {
        ColorPickerViewController *cpvc = [[ColorPickerViewController alloc] initWithNibName: @"ColorPickerViewController-iPhone"
                                                                                      bundle: nil];
        cpvc.selectedColor = canvas.leftLineColor;
        cpvc.colorChosenTarget = self;
        cpvc.colorChosenAction = @selector(colorPicker:didChooseColor:);
        chooserTarget = ColorChooserTargetLeftLine;
        [self presentModalViewController: cpvc animated: YES];
    }
}

- (IBAction) rightLineColorButtonTapped: (id) sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        ColorPickerViewController *cpvc = [[ColorPickerViewController alloc] initWithNibName: @"ColorPickerViewController"
                                                                                      bundle: nil];
        cpvc.selectedColor = canvas.rightLineColor;
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController: cpvc];
        pop.popoverContentSize = cpvc.view.bounds.size;
        pop.delegate = self;
        chooserTarget = ColorChooserTargetRightLine;
        [pop presentPopoverFromRect: rightLineColorButton.bounds
                             inView: rightLineColorButton
           permittedArrowDirections: UIPopoverArrowDirectionAny
                           animated: YES];
        colorPickerPopover = pop;
        cpvc.colorWell.delegate = self;
        [cpvc release];
    }
    else
    {
        ColorPickerViewController *cpvc = [[ColorPickerViewController alloc] initWithNibName: @"ColorPickerViewController-iPhone"
                                                                                      bundle: nil];
        cpvc.selectedColor = canvas.rightLineColor;
        cpvc.colorChosenTarget = self;
        cpvc.colorChosenAction = @selector(colorPicker:didChooseColor:);
        chooserTarget = ColorChooserTargetRightLine;
        [self presentModalViewController: cpvc animated: YES];
        [cpvc autorelease];
    }
}

- (IBAction) leftOutlierColorButtonTapped: (id) sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        ColorPickerViewController *cpvc = [[ColorPickerViewController alloc] initWithNibName: @"ColorPickerViewController"
                                                                                      bundle: nil];
        cpvc.selectedColor = canvas.leftOutlierColor;
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController: cpvc];
        pop.popoverContentSize = cpvc.view.bounds.size;
        pop.delegate = self;
        chooserTarget = ColorChooserTargetLeftOutlier;
        [pop presentPopoverFromRect: leftOutlierColorButton.bounds
                             inView: leftOutlierColorButton
           permittedArrowDirections: UIPopoverArrowDirectionAny
                           animated: YES];
        colorPickerPopover = pop;
        cpvc.colorWell.delegate = self;
        [cpvc release];
    }
    else
    {
        ColorPickerViewController *cpvc = [[ColorPickerViewController alloc] initWithNibName: @"ColorPickerViewController-iPhone"
                                                                                      bundle: nil];
        cpvc.selectedColor = canvas.leftOutlierColor;
        cpvc.colorChosenTarget = self;
        cpvc.colorChosenAction = @selector(colorPicker:didChooseColor:);
        chooserTarget = ColorChooserTargetLeftOutlier;
        [self presentModalViewController: cpvc animated: YES];
        [cpvc autorelease];
    }
}

- (IBAction) rightOutlierColorButtonTapped: (id) sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        ColorPickerViewController *cpvc = [[ColorPickerViewController alloc] initWithNibName: @"ColorPickerViewController"
                                                                                      bundle: nil];
        cpvc.selectedColor = canvas.rightOutlierColor;
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController: cpvc];
        pop.popoverContentSize = cpvc.view.bounds.size;
        pop.delegate = self;
        chooserTarget = ColorChooserTargetRightOutlier;
        [pop presentPopoverFromRect: rightOutlierColorButton.bounds
                             inView: rightOutlierColorButton
           permittedArrowDirections: UIPopoverArrowDirectionAny
                           animated: YES];
        colorPickerPopover = pop;
        cpvc.colorWell.delegate = self;
        [cpvc release];
    }
    else
    {
        ColorPickerViewController *cpvc = [[ColorPickerViewController alloc] initWithNibName: @"ColorPickerViewController-iPhone"
                                                                                      bundle: nil];
        cpvc.selectedColor = canvas.rightOutlierColor;
        cpvc.colorChosenTarget = self;
        cpvc.colorChosenAction = @selector(colorPicker:didChooseColor:);
        chooserTarget = ColorChooserTargetRightOutlier;
        [self presentModalViewController: cpvc animated: YES];
        [cpvc autorelease];
    }    
}

- (void) colorPicker:(ColorPickerViewController *) picker didChooseColor:(UIColor *)color
{
    switch (chooserTarget)
    {
        case ColorChooserTargetBackground:
            canvas.backgroundColor = color;
            [backgroundColorButton setColor: color];
            break;
        case ColorChooserTargetLeftLine:
            canvas.leftLineColor = color;
            [leftLineColorButton setColor: color];
            break;
        case ColorChooserTargetRightLine:
            canvas.rightLineColor = color;
            [rightLineColorButton setColor: color];
            break;
        case ColorChooserTargetLeftOutlier:
            canvas.leftOutlierColor = color;
            [leftOutlierColorButton setColor: color];
            break;
        case ColorChooserTargetRightOutlier:
            canvas.rightOutlierColor = color;
            [rightOutlierColorButton setColor: color];
            break;
    }
}

- (IBAction) curvedJointControlChanged: (id) sender
{
    canvas.curvedJoints = [curvedJointControl selectedSegmentIndex] == 1;
}


- (IBAction) aboutDone: (id) sender
{
    [aboutViewController dismissModalViewControllerAnimated: YES];
}

- (IBAction) lineSizeSliderChanged: (id) sender
{
    canvas.lineThickness = [lineSizeSlider value];
}

- (IBAction) undoButtonTapped: (id) sender
{
    [canvas undo];
}

- (IBAction) trashButtonTapped: (id) sender
{
	eraseImageAlert = [[UIAlertView alloc] initWithTitle: nil
												 message: NSLocalizedString(@"Clear the page?", @"erase message")
												delegate: self
									   cancelButtonTitle: @"Keep"
									   otherButtonTitles: @"Clear", nil];
	[eraseImageAlert show];
}



- (IBAction) utilityControlChanged: (id) sender
{

    
    if (handlingUtilityControl)
        return;

    handlingUtilityControl = YES;
    if ([utilityControl selectedSegmentIndex] == 0)
    {
        [canvas closeCurrentPath];
        
        if (_transparentView.isGridOn)
            [utilityControl setSelectedSegmentIndex: 1];
        // else if (canvas.backgroundImage != nil)
        //   [utilityControl setSelectedSegmentIndex: 2];
        else
            [utilityControl setSelectedSegmentIndex: -1];
    }
    else if ([utilityControl selectedSegmentIndex] == 1)
    {
        // Toggle grid.
        _transparentView.isGridOn = !_transparentView.isGridOn;
        canvas.griddedMode = !canvas.griddedMode;
        if (!_transparentView.isGridOn)
            [utilityControl setSelectedSegmentIndex: -1];
    }
    else if ([utilityControl selectedSegmentIndex] == 2)
    {
        canvas.backgroundImage = nil;
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            imageSourceActionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                                 delegate: self
                                                        cancelButtonTitle: @"Cancel"
                                                   destructiveButtonTitle: nil
                                                        otherButtonTitles: @"Take Photo", @"Choose from Library", nil]; 
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                CGRect rect  = CGRectMake((utilityControl.bounds.size.width / 3) * 2, 0,
                                          utilityControl.bounds.size.width / 3,
                                          utilityControl.bounds.size.height);
                [imageSourceActionSheet showFromRect: rect
                                              inView: utilityControl
                                            animated: YES];
            }
            else
                [imageSourceActionSheet showInView: self.view];
        }
        else
        {
            // Choose image, set background image.
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationPageSheet;
        
        
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController: picker];
                pop.delegate = self;
                CGRect rect  = CGRectMake((utilityControl.bounds.size.width / 3) * 2, 0,
                                          utilityControl.bounds.size.width / 3,
                                          utilityControl.bounds.size.height);
                chooserTarget = ColorChooserTargetNone;
                [pop presentPopoverFromRect: rect
                                     inView: utilityControl
                   permittedArrowDirections: UIPopoverArrowDirectionAny
                                   animated: YES];
                [picker release];
                imagePickerPopover = pop;
            }
            else
            {
                [self presentModalViewController: picker
                                        animated: YES];
            }

            if (_transparentView.isGridOn)
                [utilityControl setSelectedSegmentIndex: 1];
        }
    }
    handlingUtilityControl = NO;
}

- (IBAction) dontShowAgainButtonTapped: (id) sender
{
	BOOL selected = [dontShowAgainButton isSelected];
	[dontShowAgainButton setSelected: !selected];
	
	[[NSUserDefaults standardUserDefaults] setBool: !selected
											forKey: @"omit-png-save-alert"];
}

/*- (IBAction) testColorPicker: (id) sender
{
    ColorPickerViewController *cpvc = [[ColorPickerViewController alloc] initWithNibName: @"ColorPickerViewController"
                                                                                  bundle: nil];
    cpvc.red = 1.0;
    cpvc.green = 0.75;
    cpvc.blue = 0.97;
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController: cpvc];
    pop.popoverContentSize = cpvc.view.bounds.size;
    [pop presentPopoverFromBarButtonItem: barItem
                permittedArrowDirections: UIPopoverArrowDirectionAny
                                animated: YES];
}*/

#pragma mark -
#pragma mark UIPopoverControllerDelegate methods

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (chooserTarget != ColorChooserTargetNone)
    {
        ColorPickerViewController *cpvc = (ColorPickerViewController *) popoverController.contentViewController;
        [self colorPicker: cpvc
           didChooseColor: cpvc.selectedColor];
    }    
    [popoverController release];
    colorPickerPopover = nil;
}

#pragma mark -
#pragma mark UIActionSheetDelegate methods

- (void) animationDidStop: (NSString *) animationID
                 finished: (NSNumber *) finished
                  context: (void *) context
{
    if ([animationID isEqualToString: @"SaveImageAnimation"])
    {
        [saveImageView removeFromSuperview];
        [saveImageView release];
        saveImageView = nil;
        [takePictureItem setImage: nil];
        
        if (pngSaveAlert != nil)
        {
            [pngSaveAlert show];
        }
    }
}

- (void) image: (UIImage *) image
didFinishSavingWithError: (NSError *) error
   contextInfo: (void *) contextInfo
{
    [UIView beginAnimations: @"SaveImageAnimation"
                    context: NULL];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration: 0.7];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
    
    saveImageView.alpha = 0.1;
    saveImageView.frame = CGRectMake(5, self.view.bounds.size.height-25, 25, 25);
    //saveImageView.transform = CGAffineTransformMake(0.01, 0, 0, 0.01, -self.view.center.x + 10, self.view.center.y - 10);
    //[takePictureItem setImage: image];
    
    [UIView commitAnimations];
}

- (void) createPDF:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        __block NSString *filePath = nil;
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt autorelease];
        [fmt setDateFormat: @"yyyy-MM-dd HH:mm"];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *base = [fmt stringFromDate: [NSDate date]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex: 0] stringByAppendingPathComponent:
                          [base stringByAppendingString: @".pdf"]];
        int i = 0;
        while ([fm fileExistsAtPath: path])
        {
            i++;
            path = [[paths objectAtIndex: 0] stringByAppendingPathComponent:
                    [NSString stringWithFormat: @"%@ (%d).pdf", base, i]];
        }
        filePath = path;
        
        [self drawToPDF: filePath];
    }
}

- (BOOL) drawToPDF: (NSString *) filepath
    {
        // Creates a mutable data object for updating with binary data, like a byte array
        NSMutableData *pdfData = [NSMutableData data];
        
        // Points the pdf converter to the mutable data object and to the UIView to be converted
        UIGraphicsBeginPDFContextToData(pdfData, /*rect*/ canvas.bounds, nil);
        UIGraphicsBeginPDFPage();
        CGContextRef pdfContext = UIGraphicsGetCurrentContext();
        
        
        // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
        
        [canvas.layer renderInContext:pdfContext];
        
        // remove PDF rendering context
        UIGraphicsEndPDFContext();
        
        // instructs the mutable data object to write its context to a file on disk
        [pdfData writeToFile:filepath atomically:YES];
        NSLog(@"documentDirectoryFileName: %@",filepath);
        
        return YES;
}

- (void) actionSheet: (UIActionSheet *) sheet
didDismissWithButtonIndex: (NSInteger) buttonIndex
{
    if (sheet == shareActionSheet){
        // 0 Facebook
        // 1 Twitter
        // 2 Instagram
        // 3 Pinterest
        
        CGFloat imgWidth = canvas.bounds.size.width;
        CGFloat imgHeight = canvas.bounds.size.height;
        CGFloat scale = 1.0;
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
            || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(imgHeight, imgWidth), NO, scale);
        else
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(imgWidth, imgHeight), NO, scale);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        switch ([[UIDevice currentDevice] orientation])
        {
            case UIDeviceOrientationPortraitUpsideDown:
                CGContextRotateCTM(ctx, 3.14159);
                CGContextTranslateCTM(ctx, -imgWidth, -imgHeight);
                break;
            case UIDeviceOrientationLandscapeLeft:
                //NSLog(@"landscape left");
                CGContextRotateCTM(ctx, -3.14159 / 2);
                CGContextTranslateCTM(ctx, -imgWidth, 0);
                break;
            case UIDeviceOrientationLandscapeRight:
                //NSLog(@"landscape right");
                CGContextRotateCTM(ctx, 3.14159 / 2);
                CGContextTranslateCTM(ctx, 0, -imgHeight);
                break;
        }
        [canvas.layer renderInContext: ctx];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        saveImageView = [[UIImageView alloc] initWithImage: image];
        saveImageView.frame = self.view.bounds;
        saveImageView.contentMode = UIViewContentModeScaleToFill;
        //[self.view addSubview: saveImageView];
        
        switch (buttonIndex) {
            case 0:
                ;
                SLComposeViewController *shareToFacebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [shareToFacebook setInitialText:@"Created with Artonics"];
                [shareToFacebook addImage:image];
                [self presentViewController:shareToFacebook animated:YES completion:nil];
                break;
                
            case 1:
                ;SLComposeViewController *shareToTwitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [shareToTwitter setInitialText:@"Created with Artonics"];
                [shareToTwitter addImage:image];
                [self presentViewController:shareToTwitter animated:YES completion:nil];
                
            default:
                break;
        }
        
        return;
    }
    
    if (sheet == imageSourceActionSheet)
    {
        NSInteger cancelIndex = [sheet cancelButtonIndex];
        [imageSourceActionSheet release];
        imageSourceActionSheet = nil;
        if (cancelIndex == buttonIndex)
            return;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        if (buttonIndex == 0)
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        else
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            picker.modalPresentationStyle = UIModalPresentationPageSheet;
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController: picker];
            pop.delegate = self;
            CGRect rect  = CGRectMake((utilityControl.bounds.size.width / 3) * 2, 0,
                                      utilityControl.bounds.size.width / 3,
                                      utilityControl.bounds.size.height);
            chooserTarget = ColorChooserTargetNone;
            [pop presentPopoverFromRect: rect
                                 inView: utilityControl
               permittedArrowDirections: UIPopoverArrowDirectionAny
                               animated: YES];
            [picker release];
            imagePickerPopover = pop;
        }
        else
        {
            [self presentModalViewController: picker
                                    animated: YES];
        }
        
        return;
    }

	// 0 Save to photo gallery
	// 1 Email this
	// 2 Submit to gallery
	// 3 Save Hi Res
	// 4 Print
	int realButtonIndex = buttonIndex - [sheet firstOtherButtonIndex];
    
	NSLog(@"button index: %d real button index: %d", buttonIndex, realButtonIndex);
	
    if (buttonIndex != [sheet cancelButtonIndex])
    {
        if (realButtonIndex != 4)
        {
            canvas.drawCrosshair = NO;
            CGFloat imgWidth = canvas.bounds.size.width;
            CGFloat imgHeight = canvas.bounds.size.height;
            CGFloat scale = 2.0;
            if (realButtonIndex == 3 || realButtonIndex == 4)
            {
                scale = 4.0;
                imgWidth *= 4;
                imgHeight *= 4;
            }
            else if (realButtonIndex == 1 || realButtonIndex == 2)
            {
                scale = 2.0;
                imgWidth *= 2;
                imgHeight *= 2;
            }
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
                || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(imgHeight, imgWidth), NO, scale);
            else
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(imgWidth, imgHeight), NO, scale);
            CGContextRef ctx = UIGraphicsGetCurrentContext();        
            switch ([[UIDevice currentDevice] orientation])
            {
                case UIDeviceOrientationPortraitUpsideDown:
                    CGContextRotateCTM(ctx, 3.14159);
                    CGContextTranslateCTM(ctx, -imgWidth, -imgHeight);
                    break;
                case UIDeviceOrientationLandscapeLeft:
                    //NSLog(@"landscape left");
                    CGContextRotateCTM(ctx, -3.14159 / 2);
                    CGContextTranslateCTM(ctx, -imgWidth, 0);
                    break;
                case UIDeviceOrientationLandscapeRight:
                    //NSLog(@"landscape right");
                    CGContextRotateCTM(ctx, 3.14159 / 2);
                    CGContextTranslateCTM(ctx, 0, -imgHeight);
                    break;
            }
            if (realButtonIndex == 3 || realButtonIndex == 4)
                CGContextScaleCTM(ctx, 4.0, 4.0);
            else if (realButtonIndex == 1 || realButtonIndex == 2)
                CGContextScaleCTM(ctx, 2.0, 2.0);
            [canvas.layer renderInContext: ctx];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            if (realButtonIndex == 0 || realButtonIndex == 3 )
            {
                saveImageView = [[UIImageView alloc] initWithImage: image];
                saveImageView.frame = self.view.bounds;
                saveImageView.contentMode = UIViewContentModeScaleToFill;
                [self.view addSubview: saveImageView];
            }
            
            if (realButtonIndex == 0)
            {
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }
            else if (realButtonIndex == 1) // email
            {
                MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
                composer.mailComposeDelegate = self;
                [composer addAttachmentData: UIImagePNGRepresentation(image)
                                   mimeType: @"image/png"
                                   fileName: @"image.png"];
                NSLog(@"present mail composer: %@", composer);
                [self resignFirstResponder];
                [self presentModalViewController: composer
                                        animated: YES];
                [composer autorelease];
            }
            else if (realButtonIndex == 2) // submit to gallery
            {
                MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
                composer.mailComposeDelegate = self;
                [composer addAttachmentData: UIImagePNGRepresentation(image)
                                   mimeType: @"image/png"
                                   fileName: @"image.png"];
                [composer setToRecipients: [NSArray arrayWithObject: @"Gallery@artonics-international.com"]];
                [composer setSubject: NSLocalizedString(@"Artonics User Gallery Submission", @"Artonics User Gallery Submission")];
                [self resignFirstResponder];
                [self presentModalViewController: composer
                                        animated: YES];
                [composer autorelease];
            }
            else if (realButtonIndex == 3) // save hi-res
            {
                NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
                [fmt autorelease];
                [fmt setDateFormat: @"yyyy-MM-dd HH:mm"];
                NSFileManager *fm = [NSFileManager defaultManager];
                NSString *base = [fmt stringFromDate: [NSDate date]];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *path = [[paths objectAtIndex: 0] stringByAppendingPathComponent:
                                  [base stringByAppendingString: @".png"]];
                int i = 0;
                while ([fm fileExistsAtPath: path])
                {
                    i++;
                    path = [[paths objectAtIndex: 0] stringByAppendingPathComponent:
                            [NSString stringWithFormat: @"%@ (%d).png", base, i]];
                }
                NSData *pngData = UIImagePNGRepresentation(image);
                [pngData writeToFile: path
                          atomically: NO];
                
                ;                [self image: image didFinishSavingWithError: nil contextInfo: NULL];
            }
        }
		else // Print.
        {
            __block NSString *filePath = nil;
            
            filePath = [NSTemporaryDirectory() stringByAppendingFormat: @"printing.pdf"];
            [filePath retain];
            
            
            if (![self drawToPDF: filePath])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Failed to create PDF"
                                                                message: @"A PDF of the current drawing could not be created."
                                                               delegate: nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                [alert autorelease];
                return;
            }
            else
            {
                UIPrintInteractionController *printer = [UIPrintInteractionController sharedPrintController];
                UIPrintInfo *printInfo = [UIPrintInfo printInfo];
                printInfo.outputType = UIPrintInfoOutputPhoto;
                printInfo.jobName = @"Artonics";
                printer.printInfo = printInfo;
                printer.printingItem = [NSURL URLWithString: [@"file:" stringByAppendingString: filePath]];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    [printer presentFromBarButtonItem: takePictureItem
                                             animated: YES
                                    completionHandler: ^(UIPrintInteractionController *printInteractionController,BOOL completed, NSError *error)
                     {
                         [[NSFileManager defaultManager] removeItemAtPath: filePath
                                                                    error: NULL];
                         [filePath release];
                     }];
                }
                else
                {
                    [printer presentAnimated: YES
                           completionHandler: ^(UIPrintInteractionController *printInteractionController,BOOL completed, NSError *error)
                     {
                         [[NSFileManager defaultManager] removeItemAtPath: filePath
                                                                    error: NULL];
                         [filePath release];
                     }];
                }
            }
		}

        canvas.drawCrosshair = YES;
    }
    
    [saveImageActionSheet release];
    saveImageActionSheet = nil;
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == pngSaveAlert)
    {
        [pngSaveAlert release];
        pngSaveAlert = nil;
        [self image: nil didFinishSavingWithError: nil contextInfo: NULL];

		[[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        [canvas clearPoints];
    }
    [eraseImageAlert release];
    eraseImageAlert = nil;
}

#pragma mark -
#pragma mark ColorWellTouchDelegate methods

- (void) colorWellTouchUpInside:(ColorWellView *)sender
{
#if defined(DEBUG)
    NSLog(@"colorWellTouchUpInside: %@", sender);
#endif
    if (colorPickerPopover != nil)
    {
        [colorPickerPopover dismissPopoverAnimated: YES];
        [self popoverControllerDidDismissPopover: colorPickerPopover];
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [imagePickerPopover dismissPopoverAnimated: YES];
    else
        [self dismissModalViewControllerAnimated: YES];
    canvas.backgroundImage = nil;
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    canvas.backgroundImage = image;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [imagePickerPopover dismissPopoverAnimated: YES];
    else
        [self dismissModalViewControllerAnimated: YES];
}

#pragma mark -
#pragma mark gesture recognition

- (void) handlePinch: (UIGestureRecognizer *) gestureRecognizer
{
    UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *) gestureRecognizer;
#if defined(DEBUG)
    NSLog(@"pinch scale: %f", pinch.scale);
#endif
    CGFloat width = _transparentView.trackingGridWidth * pinch.scale;
    if (width < 5.0)
        width = 5.0;
    if (width > 300.0)
        width = 300.0;
    
    canvas.gridWidth = width;
    _transparentView.gridWidth = width;
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[controller dismissModalViewControllerAnimated: YES];
	[self becomeFirstResponder];
}
#pragma mark -
#pragma mark Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIViewController* controller = segue.destinationViewController;
        controller.preferredContentSize = CGSizeMake(500, 500);
    }
}
@end


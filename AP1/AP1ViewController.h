//
//  AP1ViewController.h
//  AP1
//
//  Created by Casey Marshall on 8/30/10.
//  Copyright Modal Domains 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransparentView.h"
#import "CanvasView.h"
#import "ColorWellButton.h"
#import "ColorWellView.h"
#import "ColorPickerViewController.h"
#import <MessageUI/MessageUI.h>

typedef enum ColorChooserTarget
{
    ColorChooserTargetNone,
    ColorChooserTargetBackground,
    ColorChooserTargetLeftLine,
    ColorChooserTargetRightLine,
    ColorChooserTargetLeftOutlier,
    ColorChooserTargetRightOutlier
} ColorChooserTarget;

@interface AP1ViewController : UIViewController <UIPopoverControllerDelegate,
                                                 UIActionSheetDelegate,
                                                 UIAlertViewDelegate,
                                                 ColorWellTouchDelegate,
                                                 UIImagePickerControllerDelegate,
												 MFMailComposeViewControllerDelegate>
{
    IBOutlet UIView *settingsView;
    IBOutlet UISlider *leftLinesSlider;
    IBOutlet UISlider *lineCountSlider;
    IBOutlet UISlider *rightLinesSlider;
    IBOutlet UISlider *lineSizeSlider;
    IBOutlet ColorWellButton *backgroundColorButton;
    IBOutlet ColorWellButton *leftLineColorButton;
    IBOutlet ColorWellButton *rightLineColorButton;
    IBOutlet ColorWellButton *leftOutlierColorButton;
    IBOutlet ColorWellButton *rightOutlierColorButton;
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *shareItem;
    IBOutlet UIBarButtonItem *takePictureItem;
    IBOutlet UIBarButtonItem *settingsItem;
    IBOutlet UISegmentedControl *curvedJointControl;
    IBOutlet UIButton *infoButton;
    IBOutlet UISegmentedControl *utilityControl;
    
    IBOutlet UIViewController *aboutViewController;
	IBOutlet UILabel *versionLabel;
	
	IBOutlet UIButton *dontShowAgainButton;
    
    CanvasView *canvas;
    
    BOOL showingSettings;
    ColorChooserTarget chooserTarget;
    id /*UIPopoverController */ colorPickerPopover;
    
    UIImageView *saveImageView;
    
    UIActionSheet *shareActionSheet;
    UIActionSheet *imageSourceActionSheet;
    UIActionSheet *saveImageActionSheet;
    UIAlertView *eraseImageAlert;
    
    BOOL handlingUtilityControl;
    
    id /*UIPopoverController */ imagePickerPopover;
    
    UIAlertView *pngSaveAlert;
}

@property (retain) CanvasView *canvas;
@property (retain) TransparentView *transparentView;

- (IBAction) takePictureItemTapped: (id) sender;
- (IBAction) settingsItemTapped: (id) sender;

- (IBAction) leftOutlierSliderChanged: (id) sender;
- (IBAction) lineCountSliderChanged: (id) sender;
- (IBAction) rightOutlierSliderChanged: (id) sender;
- (IBAction) backgroundColorButtonTapped: (id) sender;
- (IBAction) leftLineColorButtonTapped: (id) sender;
- (IBAction) rightLineColorButtonTapped: (id) sender;
- (IBAction) leftOutlierColorButtonTapped: (id) sender;
- (IBAction) rightOutlierColorButtonTapped: (id) sender;
- (IBAction) curvedJointControlChanged: (id) sender;
- (IBAction) infoButtonTapped: (id) sender;
- (IBAction) lineSizeSliderChanged: (id) sender;
- (IBAction) undoButtonTapped: (id) sender;
- (IBAction) trashButtonTapped: (id) sender;

- (IBAction) touchDownInUtilityControl: (id) sender;
- (IBAction) touchUpOutsideUtilityControl: (id) sender;
- (IBAction) utilityControlChanged: (id) sender;

- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

- (void) handlePinch: (UIGestureRecognizer *) gestureRecognizer;

- (void) colorPicker: (ColorPickerViewController *) picker
      didChooseColor: (UIColor *) color;

- (IBAction) aboutDone: (id) sender;

- (IBAction) dontShowAgainButtonTapped: (id) sender;

@end


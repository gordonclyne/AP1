//
//  CanvasView.h
//  AP1
//
//  Created by Casey Marshall on 9/7/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "InvalidPoint.h"
#import "CrosshairView.h"
//#import "hpdf.h"

typedef struct PointEntry
{
    CGPoint p1;
    CGPoint p2;
    struct PointEntry *next;
} PointEntry;

@interface CanvasView : UIView
{
    CrosshairView *xhairView;
    
    PointEntry *head;
    PointEntry *current;
    
    CALayer *mainLayer;
    CAShapeLayer **lineLayers;
    CAShapeLayer **leftLayers;
    CAShapeLayer **rightLayers;
    CAShapeLayer *crosshairLayer;
    //CALayer *gridLayer;

    UIColor *leftLineColor;
    UIColor *rightLineColor;
    UIColor *leftOutlierColor;
    UIColor *rightOutlierColor;
    
    CGFloat lineThickness;
    NSInteger lineCount;
    NSInteger rightOutlierCount;
    NSInteger leftOutlierCount;
    
    BOOL curvedJoints;
    BOOL drawCrosshair;
    
    BOOL inhibitUpdates;
    
    UIImage *backgroundImage;
    BOOL griddedMode;
    CGFloat gridWidth;    
    CGFloat snapLength;
}

@property (retain) UIColor *leftLineColor;
@property (retain) UIColor *rightLineColor;
@property (retain) UIColor *leftOutlierColor;
@property (retain) UIColor *rightOutlierColor;

@property (assign) CGFloat lineThickness;
@property (assign) NSInteger lineCount;
@property (assign) NSInteger rightOutlierCount;
@property (assign) NSInteger leftOutlierCount;

@property (assign) BOOL curvedJoints;
@property (assign) BOOL drawCrosshair;

@property (readonly) CALayer *linesLayer;

@property (retain) UIImage *backgroundImage;
@property (assign) BOOL griddedMode;
@property (assign) CGFloat gridWidth;

- (void) saveCanvasState;
- (void) loadCanvasState;

//- (BOOL) drawPDF: (HPDF_Page) pdfPage;

- (void) commonInit;
- (NSInteger) pathLength;

- (void) redoMainColors;
- (void) redoLeftColors;
- (void) redoRightColors;

- (void) redoMainPaths;
- (void) redoLeftPaths;
- (void) redoRightPaths;

- (void) redoThickness;
- (void) undo;
- (void) closeCurrentPath;

- (void) clearPoints;

- (void) animationDidStop:(NSString *)anim finished:(BOOL)finished context: (void *) ctx;

@end

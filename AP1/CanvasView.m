//
//  CanvasView.m
//  AP1
//
//  Created by Casey Marshall on 9/7/10.
//  Copyright 2010 Modal Domains. All rights reserved.
//

#import "CanvasView.h"
#import "UIColor+rgb.h"

#define kBackgroundColorUserDefaultsKey   @"backgroundColor"
#define kLeftColorUserDefaultsKey         @"leftColor"
#define kRightColorUserDefaultsKey        @"rightColor"
#define kLeftOutlierColorUserDefaultsKey  @"leftOutlierColor"
#define kRightOutlierColorUserDefaultsKey @"rightOutlierColor"
#define kCurvedJointsUserDefaultsKey      @"curvedJoints"
#define kLineThicknessUserDefaultsKey     @"lineThickness"
#define kLineCountUserDefaultsKey         @"lineCount"
#define kLeftOutlierCountUserDefaultsKey  @"leftOutlierCount"
#define kRightOutlierCountUserDefaultsKey @"rightOutlierCount"
#define kPointsUserDefaultsKey            @"points"

#define distance(p1,p2) sqrt((((p1).x - (p2).x) * ((p1).x - (p2).x)) + (((p1).y - (p2).y) * ((p1).y - (p2).y)))

@implementation CanvasView

@synthesize linesLayer = mainLayer;

// Assign val to var, and retain var, releasing the previous value if any,
// and marking the display as dirty.
#define do_retain(var,val) do { \
  if (var != nil)               \
    [var release];              \
  var = val;                    \
  if (var != nil)               \
    [var retain];               \
  [self setNeedsDisplay];       \
} while (NO)

#define do_assign(var,val) do { \
  if (var != val) {             \
    var = val;                  \
    [self setNeedsDisplay];     \
  }                             \
} while (NO)

@synthesize griddedMode;

- (CGFloat) gridWidth
{
    return gridWidth;
}

- (void) setGridWidth: (CGFloat) w
{
    gridWidth = w;
    snapLength = w / 3;
}

- (UIImage *) backgroundImage
{
    return backgroundImage;
}

- (void) setBackgroundImage:(UIImage *) i
{
    if (backgroundImage != nil)
        [backgroundImage release];
    backgroundImage = i;
    if (backgroundImage != nil)
        [backgroundImage retain];
    [self setNeedsDisplay];
}

/*- (BOOL) griddedMode
{
    return griddedMode;
}*/

/*- (void) setGriddedMode: (BOOL) gm
{
    if (gm != griddedMode)
    {
        griddedMode = gm;
        if (griddedMode)
            [self.layer addSublayer: gridLayer];
        else
            [gridLayer removeFromSuperlayer];
    }
}*/

/*- (CGFloat) gridWidth
{
    return gridWidth;
}*/

/*- (void) setGridWidth:(CGFloat) w
{
    if (gridWidth != w)
    {
        
        gridWidth = w;
        UIBezierPath *gridPath = [UIBezierPath bezierPath];
        
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        for (CGFloat x = 0; x < width; x += gridWidth)
        {
            [gridPath moveToPoint: CGPointMake(x, 0)];
            [gridPath addLineToPoint: CGPointMake(x, height)];
            [gridPath closePath];
        }
        for (CGFloat y = 0; y < height; y += gridWidth)
        {
            [gridPath moveToPoint: CGPointMake(0, y)];
            [gridPath addLineToPoint: CGPointMake(width, y)];
            [gridPath closePath];
        }
        
        gridLayer.path = [gridPath CGPath];
    }
}*/

- (UIColor *) leftLineColor { return leftLineColor; }
- (UIColor *) rightLineColor { return rightLineColor; }
- (UIColor *) leftOutlierColor { return leftOutlierColor; }
- (UIColor *) rightOutlierColor { return rightOutlierColor; }

/*- (void) setBackgroundColor:(UIColor *) c
{
    [super setBackgroundColor: c];
    gridLayer.strokeColor = [[UIColor colorWithRed: 1.0 - [c redValue]
                                             green: 1.0 - [c blueValue]
                                              blue: 1.0 - [c greenValue]
                                             alpha: 1.0] CGColor];
}*/

- (void) setLeftLineColor:(UIColor *) c
{
    /*if (leftLineColor != nil)
        [leftLineColor release];
    leftLineColor = c;
    if (leftLineColor != nil)
        [leftLineColor retain];
    [self redoMainColors];*/
    
    do_retain(leftLineColor, c);
}

- (void) setRightLineColor:(UIColor *)c
{
    /*if (rightLineColor != nil)
        [rightLineColor release];
    rightLineColor = c;
    if (rightLineColor != nil)
        [rightLineColor retain];
    [self redoMainColors];*/
    
    do_retain(rightLineColor, c);
}

- (void) setRightOutlierColor:(UIColor *)c
{
    do_retain(rightOutlierColor, c);
}
- (void) setLeftOutlierColor:(UIColor *) c
{
    do_retain(leftOutlierColor, c);
}

- (CGFloat) lineThickness { return lineThickness; }
- (NSInteger) lineCount { return lineCount; }
- (NSInteger) rightOutlierCount { return rightOutlierCount; }
- (NSInteger) leftOutlierCount { return leftOutlierCount; }
- (BOOL) curvedJoints { return curvedJoints; }

- (void) setLineThickness:(CGFloat)t
{
    /*if (lineThickness != t)
    {
        lineThickness = t;
        [self redoThickness];
    }*/
    
    do_assign(lineThickness, t);
}

- (void) setLineCount: (NSInteger) c
{
    /*if (lineCount != c)
    {
        NSInteger oldCount = lineCount;
        lineCount = c;
        if (lineLayers != NULL)
        {
            if (lineCount < oldCount)
            {
                // remove extra paths
                CAShapeLayer **l = (CAShapeLayer **) malloc(lineCount * sizeof(CAShapeLayer *));
                for (int i = 0; i < lineCount; i++)
                    l[i] = lineLayers[i];
                for (int i = oldCount - lineCount; i < oldCount; i++)
                {
                    [lineLayers[i] removeFromSuperlayer];
                    [lineLayers[i] release];
                }
                free(lineLayers);
                lineLayers = l;
            }
            else
            {
                // add new paths
                CAShapeLayer **l = (CAShapeLayer **) malloc(lineCount * sizeof(CAShapeLayer *));
                for (int i = 0; i < oldCount; i++)
                    l[i] = lineLayers[i];
                for (int i = oldCount; i < lineCount; i++)
                {
                    l[i] = [[CAShapeLayer alloc] init];
                    l[i].fillColor = nil;
                    [mainLayer addSublayer: l[i]];
                }
                free(lineLayers);
                lineLayers = l;
            }
        }
        else
        {
            if (c > 0)
            {
                lineLayers = (CAShapeLayer **) malloc(lineCount * sizeof(CAShapeLayer *));
                for (int i = 0; i < lineCount; i++)
                {
                    lineLayers[i] = [[CAShapeLayer alloc] init];
                    lineLayers[i].fillColor = nil;
                    [mainLayer addSublayer: lineLayers[i]];
                }
            }
        }
        
        [self redoMainPaths];
        [self redoMainColors];
        [self redoThickness];
    }*/
    
    do_assign(lineCount, c);
}

- (void) setRightOutlierCount:(NSInteger)c
{
    do_assign(rightOutlierCount, c);
}
- (void) setLeftOutlierCount:(NSInteger)c
{
    do_assign(leftOutlierCount, c);
}
- (void) setCurvedJoints:(BOOL)c
{
    do_assign(curvedJoints, c);
}

- (BOOL) drawCrosshair { return drawCrosshair; }
- (void) setDrawCrosshair:(BOOL)v
{
    drawCrosshair = v;
    // TODO -- don't make crosshair tied to drawing the full view.
    //do_assign(drawCrosshair, v);
}

- (void) commonInit
{
    head = current = NULL;
    self.drawCrosshair = YES;
    
    //mainLayer = [[CALayer layer] retain];
    //[self.layer addSublayer: mainLayer];
    //crosshairLayer = [[CAShapeLayer layer] retain];
    //crosshairLayer.strokeColor = [[UIColor colorWithRed:1.000 green:0.993 blue:0.741 alpha:1.000] CGColor];
    //crosshairLayer.fillColor = nil;
    //[self.layer addSublayer: crosshairLayer];

    lineLayers = NULL;
    leftLayers = NULL;
    rightLayers = NULL;

    xhairView = [[CrosshairView alloc] initWithFrame: self.bounds];
    xhairView.backgroundColor = [UIColor clearColor];
    xhairView.strokeColor = [UIColor colorWithRed: 1.0 green: 0.993 blue: 0.741 alpha: 1.0];
    xhairView.opaque = NO;
    xhairView.container = self;
    [self addSubview: xhairView];
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]))
    {
        [self commonInit];
    }
    return self;
}

- (void) saveCanvasState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat: [self.backgroundColor redValue]],
                          [NSNumber numberWithFloat: [self.backgroundColor greenValue]],
                          [NSNumber numberWithFloat: [self.backgroundColor blueValue]],
                          [NSNumber numberWithFloat: [self.backgroundColor alphaValue]],
                          nil]
                 forKey: kBackgroundColorUserDefaultsKey];
    [defaults setObject: [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat: [self.leftLineColor redValue]],
                          [NSNumber numberWithFloat: [self.leftLineColor greenValue]],
                          [NSNumber numberWithFloat: [self.leftLineColor blueValue]],
                          [NSNumber numberWithFloat: [self.leftLineColor alphaValue]],
                          nil]
                 forKey: kLeftColorUserDefaultsKey];
    [defaults setObject: [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat: [self.rightLineColor redValue]],
                          [NSNumber numberWithFloat: [self.rightLineColor greenValue]],
                          [NSNumber numberWithFloat: [self.rightLineColor blueValue]],
                          [NSNumber numberWithFloat: [self.rightLineColor alphaValue]],
                          nil]
                 forKey: kRightColorUserDefaultsKey];
    [defaults setObject: [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat: [self.leftOutlierColor redValue]],
                          [NSNumber numberWithFloat: [self.leftOutlierColor greenValue]],
                          [NSNumber numberWithFloat: [self.leftOutlierColor blueValue]],
                          [NSNumber numberWithFloat: [self.leftOutlierColor alphaValue]],
                          nil]
                 forKey: kLeftOutlierColorUserDefaultsKey];
    [defaults setObject: [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat: [self.rightOutlierColor redValue]],
                          [NSNumber numberWithFloat: [self.rightOutlierColor greenValue]],
                          [NSNumber numberWithFloat: [self.rightOutlierColor blueValue]],
                          [NSNumber numberWithFloat: [self.rightOutlierColor alphaValue]],
                          nil]
                 forKey: kRightOutlierColorUserDefaultsKey];
    [defaults setBool: self.curvedJoints
               forKey: kCurvedJointsUserDefaultsKey];
    [defaults setFloat: self.lineThickness
                forKey: kLineThicknessUserDefaultsKey];
    [defaults setInteger: self.lineCount
                  forKey: kLineCountUserDefaultsKey];
    [defaults setInteger: self.leftOutlierCount
                  forKey: kLeftOutlierCountUserDefaultsKey];
    [defaults setInteger: self.rightOutlierCount
                  forKey: kRightOutlierCountUserDefaultsKey];
    NSMutableArray *points = [NSMutableArray array];
    for (PointEntry *p = head; p != NULL; p = p->next)
    {
        [points addObject: [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat: p->p1.x],
                            [NSNumber numberWithFloat: p->p1.y],
                            [NSNumber numberWithFloat: p->p2.x],
                            [NSNumber numberWithFloat: p->p2.y],
                            nil]];
    }
    [defaults setObject: points
                 forKey: kPointsUserDefaultsKey];
    [defaults synchronize];
}

- (void) loadCanvasState
{
    inhibitUpdates = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *a = [defaults arrayForKey: kBackgroundColorUserDefaultsKey];
    if (a != nil)
    {
        self.backgroundColor = [UIColor colorWithRed: [[a objectAtIndex: 0] floatValue]
                                               green: [[a objectAtIndex: 1] floatValue]
                                                blue: [[a objectAtIndex: 2] floatValue]
                                               alpha: [[a objectAtIndex: 3] floatValue]];
    }
    a = [defaults arrayForKey: kLeftColorUserDefaultsKey];
    if (a != nil)
    {
        self.leftLineColor = [UIColor colorWithRed: [[a objectAtIndex: 0] floatValue]
                                             green: [[a objectAtIndex: 1] floatValue]
                                              blue: [[a objectAtIndex: 2] floatValue]
                                             alpha: [[a objectAtIndex: 3] floatValue]];
    }
    a = [defaults arrayForKey: kRightColorUserDefaultsKey];
    if (a != nil)
    {
        self.rightLineColor = [UIColor colorWithRed: [[a objectAtIndex: 0] floatValue]
                                              green: [[a objectAtIndex: 1] floatValue]
                                               blue: [[a objectAtIndex: 2] floatValue]
                                              alpha: [[a objectAtIndex: 3] floatValue]];
    }
    a = [defaults arrayForKey: kLeftOutlierColorUserDefaultsKey];
    if (a != nil)
    {
        self.leftOutlierColor = [UIColor colorWithRed: [[a objectAtIndex: 0] floatValue]
                                                green: [[a objectAtIndex: 1] floatValue]
                                                 blue: [[a objectAtIndex: 2] floatValue]
                                                alpha: [[a objectAtIndex: 3] floatValue]];
    }
    a = [defaults arrayForKey: kRightOutlierColorUserDefaultsKey];
    if (a != nil)
    {
        self.rightOutlierColor = [UIColor colorWithRed: [[a objectAtIndex: 0] floatValue]
                                                 green: [[a objectAtIndex: 1] floatValue]
                                                  blue: [[a objectAtIndex: 2] floatValue]
                                                 alpha: [[a objectAtIndex: 3] floatValue]];
    }
    
    self.curvedJoints = [defaults boolForKey: kCurvedJointsUserDefaultsKey];

    CGFloat f = [defaults floatForKey: kLineThicknessUserDefaultsKey];
    if (f > 0)
        self.lineThickness = f;
    else
        self.lineThickness = 2.0;
    
    NSInteger i = [defaults integerForKey: kLineCountUserDefaultsKey];
    if (i > 0)
        self.lineCount = i;
    else
        self.lineCount = 32;
    
    self.leftOutlierCount = [defaults integerForKey: kLeftOutlierCountUserDefaultsKey];
    self.rightOutlierCount = [defaults integerForKey: kRightOutlierCountUserDefaultsKey];
    
    head = current = NULL;
    NSArray *p = [defaults arrayForKey: kPointsUserDefaultsKey];
    if (p != nil)
    {
        for (NSArray *point in p)
        {
            PointEntry *pe = (PointEntry *) malloc(sizeof(PointEntry));
            pe->p1 = CGPointMake([[point objectAtIndex: 0] floatValue],
                                 [[point objectAtIndex: 1] floatValue]);
            pe->p2 = CGPointMake([[point objectAtIndex: 2] floatValue],
                                 [[point objectAtIndex: 3] floatValue]);
            pe->next = NULL;
            if (current != NULL)
            {
                current->next = pe;
                current = pe;
            }
            else
            {
                head = current = pe;
            }
        }
    }
    
    inhibitUpdates = NO;
    
#if defined(DEBUG)
    NSLog(@"loaded state: colors: (%@, %@, %@, %@, %@)",
          self.backgroundColor, self.leftLineColor, self.rightLineColor,
          self.leftOutlierColor, self.rightOutlierColor);
    NSLog(@"               lines: %f, %d, %d, %d, %d",
          self.lineThickness, self.lineCount, self.leftOutlierCount,
          self.rightOutlierCount, self.curvedJoints);
    NSMutableString *s = [NSMutableString string];
    for (PointEntry *p = head; p != NULL; p = p->next)
    {
        [s appendFormat: @"[(%f, %f) (%f, %f)]  ", p->p1.x, p->p1.y, p->p2.x, p->p2.y];
    }
    NSLog(@"              points: %@", s);
#endif
}

- (void) closeCurrentPath
{
    if (head != current && head->next != current) // Only if we have more than two pairs
    {
        if (isInvalidCGPoint(current->p2))
            current->p2 = current->p1;
        PointEntry *p = (PointEntry *) malloc(sizeof(PointEntry));
        p->p1 = head->p1;
        p->p2 = head->p2;
        p->next = NULL;
        current->next = p;
        current = p;
        [self setNeedsDisplay];
        [xhairView setFirstPoint: CGInvalidPoint
                     secondPoint: CGInvalidPoint];
    }
}

- (void) undo
{
    if (head != NULL && head == current)
    {
        free(head);
        head = current = NULL;
        [self setNeedsDisplay];
        return;
    }
    for (PointEntry *p = head; p != NULL; p = p->next)
    {
        if (p->next == current)
        {
            free(current);
            current = p;
            current->next = NULL;
        }
    }
    // If we removed every pair of points but the first, remove the first one too.
    if (head == current)
    {
        free(head);
        head = current = NULL;
    }
    [self setNeedsDisplay];
}

- (void) setNeedsDisplay
{
    if (!inhibitUpdates)
        [super setNeedsDisplay];
}

static CGPoint
center_of_circle(CGPoint point1, CGPoint point2, CGPoint point3)
{
    double ma = (point2.y - point1.y) / (point2.x - point1.x);
    double mb = (point3.y - point2.y) / (point3.x - point2.x);
    CGPoint c; // Center of a circle passing through all three points.
    c.x = (
           (
            (ma * mb * (point1.y - point3.y))
            + (mb * (point1.x + point2.x))
            - (ma * (point2.x + point3.x))
            )
           / (2 * (mb - ma)
              )
           );
    c.y = (
           (
            (-1 / ma)
            * (c.x - ((point1.x + point2.x) / 2))
            )
           + ((point1.y + point2.y) / 2)
           );
    return c;
}

typedef enum winding {
    PosPosPosPos = 0,
    PosPosPosNeg = 1,
    PosPosNegPos = 2,
    PosNegPosPos = 3,
    NegPosPosPos = 4,
    PosPosNegNeg = 5,
    NegNegPosPos = 6,
    PosNegNegPos = 7,
    NegPosPosNeg = 8,    
    PosNegPosNeg = 9,
    NegPosNegPos = 10,
    PosNegNegNeg = 11,
    NegPosNegNeg = 12,
    NegNegPosNeg = 13,
    NegNegNegPos = 14,
    NegNegNegNeg = 15
} winding;

#define pos(v) (v >= 0)
#define neg(v) (v < 0)

static winding
classify(CGFloat dx1, CGFloat dy1, CGFloat dx2, CGFloat dy2)
{
    if (pos(dx1)) // + ? ? ?
    {
        if (pos(dy1)) // + + ? ?
        {
            if (pos(dx2)) // + + + ?
            {
                if (pos(dy2)) // + + + +
                    return PosPosPosPos;
                else          // + + + -
                    return PosPosPosNeg;
            }
            else // + + - ?
            {
                if (pos(dy2)) // + + - +
                    return PosPosNegPos;
                else // + + - -
                    return PosPosNegNeg;
            }
        }
        else // + - ? ?
        {
            if (pos(dx2)) // + - + ?
            {
                if (pos(dy2))
                    return PosNegPosPos;
                else
                    return PosNegPosNeg;
            }
            else // + - - ?
            {
                if (pos(dy2))
                    return PosNegNegPos;
                else
                    return PosNegNegNeg;
            }
        }
    }
    else // -
    {
        if (pos(dy1)) // - +
        {
            if (pos(dx2)) // - + +
            {
                if (pos(dy2))
                    return NegPosPosPos;
                else
                    return NegPosPosNeg;
            }
            else // - + -
            {
                if (pos(dy2))
                    return NegPosNegPos;
                else
                    return NegPosNegNeg;
            }
        }
        else // - -
        {
            if (pos(dx2)) // - - +
            {
                if (pos(dy2))
                    return NegNegPosPos;
                else
                    return NegNegPosNeg;
            }
            else // - - -
            {
                if (pos(dy2))
                    return NegNegNegPos;
                else
                    return NegNegNegNeg;
            }
        }
    }
}

//- (BOOL) drawPDF: (HPDF_Page) pdf
//{
//    HPDF_Page_SetRGBFill(pdf, [self.backgroundColor redValue], [self.backgroundColor greenValue], [self.backgroundColor blueValue]);
//    HPDF_Page_Rectangle(pdf, 0, 0, HPDF_Page_GetWidth(pdf), HPDF_Page_GetHeight(pdf));
//    HPDF_Page_Fill(pdf);
//    
//    HPDF_Page_SetLineWidth(pdf, self.lineThickness);
//    for (int i = -self.leftOutlierCount; i <= self.lineCount + self.rightOutlierCount; i++)
//    {
//        UIColor *lineColor = nil;
//        if (i < 0)
//            lineColor = [UIColor interpolateFromColor: self.leftOutlierColor
//                                              toColor: self.leftLineColor
//                                              atIndex: self.leftOutlierCount + i
//                                                steps: self.leftOutlierCount];
//        if (i >= 0 && i <= self.lineCount)
//            lineColor = [UIColor interpolateFromColor: self.leftLineColor
//                                              toColor: self.rightLineColor
//                                              atIndex: i
//                                                steps: self.lineCount];
//        if (i > self.lineCount)
//            lineColor = [UIColor interpolateFromColor: self.rightLineColor
//                                              toColor: self.rightOutlierColor
//                                              atIndex: i - self.lineCount
//                                                steps: self.rightOutlierCount];
//
//        HPDF_Page_SetRGBStroke(pdf, [lineColor redValue], [lineColor greenValue], [lineColor blueValue]);
//        CGPoint prev1 = CGInvalidPoint;
//        CGPoint prev2 = CGInvalidPoint;
//        {
//            for (PointEntry *p = head; p != NULL; p = p->next)
//            {
//                CGFloat xdv = (p->p2.x - p->p1.x) / self.lineCount;
//                CGFloat ydv = (p->p2.y - p->p1.y) / self.lineCount;
//                
//                CGPoint point = CGPointMake(p->p1.x + (i * xdv), p->p1.y + (i * ydv));
//                
//                if (!isInvalidCGPoint(p->p1) && !isInvalidCGPoint(p->p2))
//                {
//                    if (p == head)
//                        HPDF_Page_MoveTo(pdf, point.x, point.y);
//                    else
//                    {
//                        /*NSLog(@"curved: %@ && %@ && %@", self.curvedJoints ? @"YES" : @"NO",
//                         !isInvalidCGPoint(prev1) ? @"YES" : @"NO",
//                         !isInvalidCGPoint(prev2) ? @"YES" : @"NO");*/
//                        if (self.curvedJoints && !isInvalidCGPoint(prev1) && !isInvalidCGPoint(prev2))
//                        {
//                            CGFloat dx1 = 0.25 * ((prev2.x - prev1.x) + (prev1.x - point.x));
//                            CGFloat dy1 = 0.25 * ((prev2.y - prev1.y) + (prev1.y - point.y));
//                            CGPoint cp1 = CGPointMake(prev1.x - dx1, prev1.y - dy1);
//                            CGPoint cp2 = CGPointMake(point.x + dx1, point.y + dy1);
//                            /*NSLog(@"add curve (%f, %f) (%f, %f) (%f, %f)", cp1.x, cp1.y,
//                             cp2.x, cp2.y, point.x, point.y);*/
//                            HPDF_Page_CurveTo(pdf, cp1.x, cp1.y, cp2.x, cp2.y, point.x, point.y);
//                        }
//                        else
//                            HPDF_Page_LineTo(pdf, point.x, point.y);
//                    }
//                }
//                prev2 = prev1;
//                prev1 = point;
//            }
//            HPDF_Page_Stroke(pdf);
//        }
//    }
//    return YES;
//}

- (void) drawRect:(CGRect)rect
{
    [super drawRect: rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.backgroundImage != nil && drawCrosshair)
    {
        [self.backgroundImage drawInRect: rect
                               blendMode: kCGBlendModeNormal
                                   alpha: 0.5];
    }
    
    /*if (current != NULL && drawCrosshair)
    {
        CGPoint p = current->p2;
        if (isInvalidCGPoint(current->p2))
            p = current->p1;
        
        const CGPoint xp[] = { CGPointMake(p.x - 12, p.y), CGPointMake(p.x + 12, p.y) };
        const CGPoint yp[] = { CGPointMake(p.x, p.y - 12), CGPointMake(p.x, p.y + 12) };
        CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
        CGContextSetLineWidth(context, 1.f);
        CGContextStrokeEllipseInRect(context, CGRectMake(p.x-7, p.y-7, 14, 14));
        CGContextStrokeLineSegments(context, xp, 2);
        CGContextStrokeLineSegments(context, yp, 2);
    }*/
    
    CGContextSetLineWidth(context, self.lineThickness);
    for (int i = -self.leftOutlierCount; i <= self.lineCount + self.rightOutlierCount; i++)
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPoint prev1 = CGInvalidPoint;
        CGPoint prev2 = CGInvalidPoint;
                
        /*if (self.curvedJoints && [self pathLength] >= 3)
        {
            PointEntry *p1 = head;
            PointEntry *p2 = p1->next;
            PointEntry *p3 = p2->next;
            
            double prev_mc = 0;
            
            winding wnd = PosPosPosPos;
            winding last_wnd = wnd;
                        
            while (p3 != NULL)
            {
                CGFloat xdv1 = (p1->p2.x - p1->p1.x) / self.lineCount;
                CGFloat ydv1 = (p1->p2.y - p1->p1.y) / self.lineCount;
                CGFloat xdv2 = (p2->p2.x - p2->p1.x) / self.lineCount;
                CGFloat ydv2 = (p2->p2.y - p2->p1.y) / self.lineCount;
                CGFloat xdv3 = (p3->p2.x - p3->p1.x) / self.lineCount;
                CGFloat ydv3 = (p3->p2.y - p3->p1.y) / self.lineCount;
                
                CGPoint point1 = CGPointMake(p1->p1.x + (i * xdv1), p1->p1.y + (i * ydv1));
                CGPoint point2 = CGPointMake(p2->p1.x + (i * xdv2), p2->p1.y + (i * ydv2));
                CGPoint point3 = CGPointMake(p3->p1.x + (i * xdv3), p3->p1.y + (i * ydv3));

                if (p1 == head)
                    CGPathMoveToPoint(path, NULL, point1.x, point1.y);
                
                double ma = (point2.y - point1.y) / (point2.x - point1.x);
                double mb = (point3.y - point2.y) / (point3.x - point2.x);

                CGFloat dx1 = point2.x - point1.x;
                CGFloat dy1 = point2.y - point1.y;
                CGFloat dx2 = point3.x - point2.x;
                CGFloat dy2 = point3.y - point2.y;
                
                last_wnd = wnd;
                wnd = classify(dx1, dy1, dx2, dy2);

#if defined(DEBUG)
                NSLog(@"ma=%f %d mb=%f %d", ma, isinf(ma), mb, isinf(mb));
#endif
                
                if ((ma == mb || fabs(ma - mb) < 10e-10 || (isinf(ma) && isinf(mb)))
                    && (!isinf(ma) && !isinf(mb)))// nearly collinear
                {
                    prev_mc = mb;
                    CGPathAddLineToPoint(path, NULL, point2.x, point2.y);
#if defined(DEBUG)
                    if (i == 0)
                    {
                        CGContextSetFillColorWithColor(context, [[UIColor colorWithRed: 1.0 green: 1.0 blue: 0.0 alpha: 0.5] CGColor]);
                        if (p1 == head)
                        {
                            CGContextFillRect(context, CGRectMake(point1.x-5, point1.y-5, 10, 10));
                            CGContextFillRect(context, CGRectMake(point2.x-5, point2.y-5, 10, 10));
                        }
                        CGContextFillRect(context, CGRectMake(point3.x-5, point3.y-5, 10, 10));
                    }
#endif
                }
                else
                {
                    CGPoint tp1; // Some point on the tangent line
                    CGPoint tp2;
                    CGPoint c;
                    if (isinf(ma))
                        c = center_of_circle(point2, point3, point1);
                    else if (isinf(mb))
                        c = center_of_circle(point1, point3, point2);
                    else
                        c = center_of_circle(point1, point2, point3);
                    // Slope of the line perpendicular to the line between
                    // point2 and c.
                    double mc = - (c.x - point2.x) / (c.y - point2.y);
                    
#if defined(DEBUG)
                    NSLog(@"mc = %f", mc);
#endif
                    
                    // Distance we want our control point to be from the endpoints.
                    double mag = 0.25 * distance(point1, point2);
                    
                    CGPoint cp1;
                    if (p1 == head)
                    {
#if defined(DEBUG)
                        NSLog(@"--");
#endif
                        cp1 = point1;
                    }
                    else
                    {
#if defined(DEBUG)
                        NSLog(@"tp1.x=%f dx=%f", point2.x, point2.x - point1.x);
#endif
                        double c1 = point1.y - prev_mc * point1.x;
#if defined(DEBUG)
                        NSLog(@"c1=%f", c1);
#endif
                        if (prev_mc >= 0)
                        {
                            if (prev_mc < 1)
                                tp1.x = self.bounds.size.width + 1;
                            else
                                tp1.x = -1;
                        
                        }
                        else
                        {
                            if (prev_mc <= -1)
                                tp1.x = self.bounds.size.width + 1;
                            else
                                tp1.x = -1;
                        }
                        tp1.y = prev_mc * tp1.x + c1;
                        double k1 = mag / distance(point1, tp1);
                        cp1.x = point1.x - k1 * (point1.x - tp1.x);
                        cp1.y = point1.y - k1 * (point1.y - tp1.y);
                    }
                    
                  
#if defined(DEBUG)
                    NSLog(@"tp2.x=%f dx=%f", point3.x, point3.x - point2.x);
#endif
                    CGPoint cp2;
                    double c2 = point2.y - mc * point2.x;
#if defined(DEBUG)
                    NSLog(@"c2=%f", c2);
#endif
                    if (mc >= 0)
                    {
                        if (mc < 1)
                            tp2.x = self.bounds.size.width + 1;
                        else
                            tp2.x = -1;
                    }
                    else
                    {
                        if (prev_mc > -1)
                            tp2.x = self.bounds.size.width + 1;
                        else
                            tp2.x = -1;
                    }
                    tp2.y = mc * tp2.x + c2;
                    double k2 = mag / distance(point2, tp2);
                    cp2.x = point2.x - k2 * (point2.x - tp2.x);
                    cp2.y = point2.y - k2 * (point2.y - tp2.y);
                    
#if defined(DEBUG)
                    NSLog(@"dx1=%f dy1=%f dx2=%f dy2=%f", dx1, dy1, dx2, dy2);
                    NSLog(@"cp1=(%f, %f) cp2=(%f, %f)", cp1.x, cp1.y, cp2.x, cp2.y);
                    if (i == 0)
                    {
                        CGContextSetFillColorWithColor(context, [[UIColor colorWithRed: 1 green: 0 blue: 0 alpha: 0.5] CGColor]);
                        CGContextFillEllipseInRect(context, CGRectMake(tp1.x-5, tp1.y-5, 10, 10));
                        CGContextFillRect(context, CGRectMake(tp2.x-5, tp2.y-5, 10, 10));
                        CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
                        CGContextMoveToPoint(context, tp1.x, tp1.y);
                        CGContextAddLineToPoint(context, point1.x, point1.y);
                        CGContextStrokePath(context);
                        CGContextMoveToPoint(context, tp2.x, tp2.y);
                        CGContextAddLineToPoint(context, point2.x, point2.y);
                        CGContextStrokePath(context);
                        
                        CGContextSetFillColorWithColor(context, [[UIColor colorWithRed: 1.0 green: 1.0 blue: 0.0 alpha: 0.5] CGColor]);
                        if (p1 == head)
                        {
                            CGContextFillEllipseInRect(context, CGRectMake(point1.x-5, point1.y-5, 10, 10));
                            CGContextFillEllipseInRect(context, CGRectMake(point2.x-5, point2.y-5, 10, 10));
                        }
                        CGContextFillEllipseInRect(context, CGRectMake(point3.x-5, point3.y-5, 10, 10));
                        CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite: 1.0 alpha: 0.5] CGColor]);
                        CGContextFillEllipseInRect(context, CGRectMake(cp1.x-5, cp1.y-5, 10, 10));
                        CGContextFillRect(context, CGRectMake(cp2.x-5, cp2.y-5, 10, 10));
                        const CGPoint pp1[2] = { point1, cp1 };
                        const CGPoint pp2[2] = { point2, cp2 };
                        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
                        CGContextSetLineWidth(context, 1.0);
                        CGContextStrokeLineSegments(context, pp1, 2);
                        CGContextStrokeLineSegments(context, pp2, 2);
                        
                        double r = distance(point2, c);
                        NSLog(@"r=%f", r);
                        CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed: 0 green: 0 blue: 1 alpha:0.5] CGColor]);
                        CGContextStrokeEllipseInRect(context, CGRectMake(c.x-r, c.y-r, 2*r, 2*r));
                        CGContextSetFillColorWithColor(context, [[UIColor colorWithRed: 0 green: 0 blue: 1 alpha:0.5] CGColor]);
                        CGContextFillEllipseInRect(context, CGRectMake(c.x-5, c.y-5, 10, 10));
                    }
#endif
                    
                    CGPathAddCurveToPoint(path, NULL, cp1.x, cp1.y, cp2.x, cp2.y, point2.x, point2.y);
                    
                    prev_mc = mc;
                }

                p1 = p1->next;
                p2 = p2->next;
                p3 = p3->next;
            }
            
            // final point
            {
                CGFloat xdv1 = (p1->p2.x - p1->p1.x) / self.lineCount;
                CGFloat ydv1 = (p1->p2.y - p1->p1.y) / self.lineCount;
                CGFloat xdv2 = (p2->p2.x - p2->p1.x) / self.lineCount;
                CGFloat ydv2 = (p2->p2.y - p2->p1.y) / self.lineCount;

                CGPoint point1 = CGPointMake(p1->p1.x + (i * xdv1), p1->p1.y + (i * ydv1));
                CGPoint point2 = CGPointMake(p2->p1.x + (i * xdv2), p2->p1.y + (i * ydv2));
                
                double mag = 0.25 * distance(point1, point2);
                CGPoint cp1;
                double c1 = point1.y - prev_mc * point1.x;
                CGPoint tp1; // Some point on the tangent line
                CGFloat dx1 = point2.x - point1.x;
                CGFloat dy1 = point2.y - point1.y;
                
                if (prev_mc >= 0)
                {
                    if (prev_mc < 1)
                        tp1.x = self.bounds.size.width + 1;
                    else
                        tp1.x = -1;
                    
                }
                else
                {
                    if (prev_mc >= -1)
                        tp1.x = self.bounds.size.width + 1;
                    else
                        tp1.x = -1;
                }
                tp1.y = prev_mc * tp1.x + c1;
                double k1 = mag / distance(point1, tp1);
                cp1.x = point1.x - k1 * (point1.x - tp1.x);
                cp1.y = point1.y - k1 * (point1.y - tp1.y);
                CGPathAddCurveToPoint(path, NULL, cp1.x, cp1.y, point2.x, point2.y,
                                      point2.x, point2.y);
                
#if defined(DEBUG)
                NSLog(@"dx1=%f dy1=%f", dx1, dy1);
                if (i == 0)
                {
                    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed: 0 green: 1 blue: 0 alpha: 0.5] CGColor]);
                    CGContextFillEllipseInRect(context, CGRectMake(tp1.x-5, tp1.y-5, 10, 10));
                    CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
                    CGContextMoveToPoint(context, tp1.x, tp1.y);
                    CGContextAddLineToPoint(context, point1.x, point1.y);
                    CGContextStrokePath(context);

                    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite: 1.0 alpha: 0.5] CGColor]);
                    CGContextFillEllipseInRect(context, CGRectMake(cp1.x-5, cp1.y-5, 10, 10));
                    const CGPoint pp1[2] = { point1, cp1 };
                    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
                    CGContextSetLineWidth(context, 1.0);
                    CGContextStrokeLineSegments(context, pp1, 2);
                }
#endif
            }
        }
        else
         */            
            
        {
            for (PointEntry *p = head; p != NULL; p = p->next)
            {
                CGFloat xdv = (p->p2.x - p->p1.x) / self.lineCount;
                CGFloat ydv = (p->p2.y - p->p1.y) / self.lineCount;
            
                CGPoint point = CGPointMake(p->p1.x + (i * xdv), p->p1.y + (i * ydv));

                if (!isInvalidCGPoint(p->p1) && !isInvalidCGPoint(p->p2))
                {
                    if (p == head)
                        CGPathMoveToPoint(path, NULL, point.x, point.y);
                    else
                    {
                        /*NSLog(@"curved: %@ && %@ && %@", self.curvedJoints ? @"YES" : @"NO",
                         !isInvalidCGPoint(prev1) ? @"YES" : @"NO",
                         !isInvalidCGPoint(prev2) ? @"YES" : @"NO");*/
                        if (self.curvedJoints && !isInvalidCGPoint(prev1) && !isInvalidCGPoint(prev2))
                        {
                            CGFloat dx1 = 0.25 * ((prev2.x - prev1.x) + (prev1.x - point.x));
                            CGFloat dy1 = 0.25 * ((prev2.y - prev1.y) + (prev1.y - point.y));
                            CGPoint cp1 = CGPointMake(prev1.x - dx1, prev1.y - dy1);
                            CGPoint cp2 = CGPointMake(point.x + dx1, point.y + dy1);
                            /*NSLog(@"add curve (%f, %f) (%f, %f) (%f, %f)", cp1.x, cp1.y,
                             cp2.x, cp2.y, point.x, point.y);*/
                            CGPathAddCurveToPoint(path, NULL, cp1.x, cp1.y, cp2.x, cp2.y,
                                                  point.x, point.y);
                        }
                        else
                            CGPathAddLineToPoint(path, NULL, point.x, point.y);
                    }
                }
                prev2 = prev1;
                prev1 = point;
            }
        }
        
        UIColor *lineColor = nil;
        if (i < 0)
            lineColor = [UIColor interpolateFromColor: self.leftOutlierColor
                                              toColor: self.leftLineColor
                                              atIndex: self.leftOutlierCount + i
                                                steps: self.leftOutlierCount];
        if (i >= 0 && i <= self.lineCount)
            lineColor = [UIColor interpolateFromColor: self.leftLineColor
                                              toColor: self.rightLineColor
                                              atIndex: i
                                                steps: self.lineCount];
        if (i > self.lineCount)
            lineColor = [UIColor interpolateFromColor: self.rightLineColor
                                              toColor: self.rightOutlierColor
                                              atIndex: i - self.lineCount
                                                steps: self.rightOutlierCount];
/*#if 0 // defined(DEBUG)
        if (self.curvedJoints && [self pathLength] >= 3)
        {
            if (i == 0)
            {
                CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
                CGContextSetLineWidth(context, 1.0);
                CGContextAddPath(context, path);
                CGContextStrokePath(context);
            }
            CGPathRelease(path);
            return;
        }
#endif */
            
        CGContextSetStrokeColorWithColor(context, [lineColor CGColor]);
        CGContextSetLineWidth(context, self.lineThickness);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
        CGPathRelease(path);
    }
    
    /*CGMutablePathRef *paths = (CGMutablePathRef *) malloc(sizeof(CGMutablePathRef) * 32);
    for (int i = 0; i < 32; i++)
        paths[i] = CGPathCreateMutable();
    for (PointEntry *p = head; p != NULL; p = p->next)
    {
        if (!isInvalidCGPoint(p->p1) && !isInvalidCGPoint(p->p2))
        {
            CGFloat xdv = (p->p2.x - p->p1.x) / 32;
            CGFloat ydv = (p->p2.y - p->p1.y) / 32;
            if (p == head)
            {
                for (int i = 0; i < 32; i++)
                    CGPathMoveToPoint(paths[i], NULL, p->p1.x + (i * xdv), p->p1.y + (i * ydv));
            }
            else
            {
                for (int i = 0; i < 32; i++)
                    CGPathAddLineToPoint(paths[i], NULL, p->p1.x + (i * xdv), p->p1.y + (i * ydv));
            }
        }
    }
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextSetLineWidth(context, 2.f);
    for (int i = 0; i < 32; i++)
    {
        CGContextAddPath(context, paths[i]);
        CGContextStrokePath(context);
        CGPathRelease(paths[i]);
    }
    free(paths); */
}

- (void)dealloc
{
    PointEntry *p = head;
    while (p != NULL)
    {
        PointEntry *n = p->next;
        free(p);
        p = n;
    }
    head = current = NULL;    
    [super dealloc];
}

- (void) clearPoints
{
    PointEntry *p = head;
    while (p != NULL)
    {
        PointEntry *n = p->next;
        free(p);
        p = n;
    }
    head = current = NULL;
    crosshairLayer.path = nil;
    [self setNeedsDisplay];
}

- (NSInteger) pathLength
{
    int i = 0;
    for (PointEntry *p = head; p != NULL; p = p->next)
    {
        if (p != current || (!isInvalidCGPoint(p->p1) && !isInvalidCGPoint(p->p2)))
            i++;
    }
    return i;
}

#pragma mark -
#pragma mark Obsolete Shape layer stuff

// This was an interesting attempt, but shape layers are unusably slow on iOS.

- (void) redoMainPaths
{
    for (int i = 0; i < self.lineCount; i++)
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPoint prev1 = CGInvalidPoint;
        CGPoint prev2 = CGInvalidPoint;
        for (PointEntry *p = head; p != NULL; p = p->next)
        {
            CGFloat xdv = (p->p2.x - p->p1.x) / self.lineCount;
            CGFloat ydv = (p->p2.y - p->p1.y) / self.lineCount;
            
            CGPoint point = CGPointMake(p->p1.x + (i * xdv), p->p1.y + (i * ydv));
            
            if (!isInvalidCGPoint(p->p1) && !isInvalidCGPoint(p->p2))
            {
                if (p == head)
                    CGPathMoveToPoint(path, NULL, point.x, point.y);
                else
                {
                    /*NSLog(@"curved: %@ && %@ && %@", self.curvedJoints ? @"YES" : @"NO",
                     !isInvalidCGPoint(prev1) ? @"YES" : @"NO",
                     !isInvalidCGPoint(prev2) ? @"YES" : @"NO");*/
                    if (self.curvedJoints && !isInvalidCGPoint(prev1) && !isInvalidCGPoint(prev2))
                    {
                        CGFloat dx1 = 0.25 * ((prev2.x - prev1.x) + (prev1.x - point.x));
                        CGFloat dy1 = 0.25 * ((prev2.y - prev1.y) + (prev1.y - point.y));
                        CGPoint cp1 = CGPointMake(prev1.x - dx1, prev1.y - dy1);
                        CGPoint cp2 = CGPointMake(point.x + dx1, point.y + dy1);
                        /*NSLog(@"add curve (%f, %f) (%f, %f) (%f, %f)", cp1.x, cp1.y,
                         cp2.x, cp2.y, point.x, point.y);*/
                        CGPathAddCurveToPoint(path, NULL, cp1.x, cp1.y, cp2.x, cp2.y,
                                              point.x, point.y);
                    }
                    else
                        CGPathAddLineToPoint(path, NULL, point.x, point.y);
                }
            }
            prev2 = prev1;
            prev1 = point;
        }
            
        if (i < self.lineCount)
        {
            lineLayers[i].path = path;
        }
        
        CGPathRelease(path);
    }
}

- (void) redoLeftPaths
{
    // TODO
}

- (void) redoRightPaths
{
    // TODO
}

- (void) redoMainColors
{
    if (self.leftLineColor != nil && self.rightLineColor != nil && lineLayers != NULL)
    {
        for (int i = 0; i < self.lineCount; i++)
        {
            lineLayers[i].strokeColor = [[UIColor interpolateFromColor: self.leftLineColor
                                                               toColor: self.rightLineColor
                                                               atIndex: i
                                                                 steps: self.lineCount] CGColor];
        }
    }
}

- (void) redoLeftColors
{
    // TODO
}

- (void) redoRightColors
{
    // TODO
}

- (void) redoThickness
{
    if (leftLayers != NULL)
        for (int i = 0; i < self.leftOutlierCount; i++)
            leftLayers[i].lineWidth = lineThickness;
    if (lineLayers != NULL)
        for (int i = 0; i < self.lineCount; i++)
            lineLayers[i].lineWidth = lineThickness;
    if (rightLayers != NULL)
        for (int i = 0; i < self.rightOutlierCount; i++)
            rightLayers[i].lineWidth = lineThickness;
}    

#pragma mark -
#pragma mark Touch Handling

- (void) touchesBegan: (NSSet *) touches
            withEvent: (UIEvent *) event
{
    if ([touches count] == 1)
    {
        for (UITouch *touch in touches)
        {
            CGPoint p = [touch locationInView: self];
            
            if (current == NULL || !isInvalidCGPoint(current->p2))
                [xhairView setFirstPoint: p secondPoint: CGInvalidPoint];
            else
                [xhairView setFirstPoint: current->p1 secondPoint: p];
            
            xhairView.alpha = 1.0;
        
            /*CGMutablePathRef xhair = CGPathCreateMutable();
            const CGPoint xp[] = { CGPointMake(p.x - xh1(), p.y), CGPointMake(p.x + xh1(), p.y) };
            const CGPoint yp[] = { CGPointMake(p.x, p.y - xh1()), CGPointMake(p.x, p.y + xh1()) };
        
            CGPathAddEllipseInRect(xhair, NULL, CGRectMake(p.x-xh2(), p.y-xh2(), (2 * xh2()), (2 * xh2())));
            CGPathCloseSubpath(xhair);
            CGPathMoveToPoint(xhair, NULL, xp[0].x, xp[0].y);
            CGPathAddLineToPoint(xhair, NULL, xp[1].x, xp[1].y);
            CGPathMoveToPoint(xhair, NULL, yp[0].x, yp[0].y);
            CGPathAddLineToPoint(xhair, NULL, yp[1].x, yp[1].y);
            
            if (current != NULL && isInvalidCGPoint(current->p2))
            {
                CGPathCloseSubpath(xhair);
                CGPathMoveToPoint(xhair, NULL, p.x, p.y);
                CGPathAddLineToPoint(xhair, NULL, current->p1.x, current->p2.y);
            }
            
            crosshairLayer.path = xhair;
            crosshairLayer.opacity = 1.0;
            CGPathRelease(xhair);*/
        }
    }
}

- (void) animationDidStart:(CAAnimation *)anim
{
#if defined(DEBUG)
    NSLog(@"animationDidStart:%@", anim);
#endif
    // Nothing
}

- (void) animationDidStop: (NSString *) anim
                 finished: (BOOL) finished
                  context: (void *) ctx
{
#if defined(DEBUG)
    NSLog(@"animationDidStop:%@ finished:%d", anim, finished);
#endif
    [crosshairLayer removeAnimationForKey: @"animateOpacity"];
    crosshairLayer.path = nil;
    crosshairLayer.opacity = 1.0;
}

- (void) touchesEnded: (NSSet *) touches
            withEvent: (UIEvent *) event
{
    PointEntry *prev = current;
    if ([touches count] == 1)
    {
        for (UITouch *touch in touches)
        {
            CGPoint p = [touch locationInView: self];
            
            if (griddedMode)
            {
                CGFloat gx1 = floor(p.x / gridWidth) * gridWidth;
                CGFloat gy1 = floor(p.y / gridWidth) * gridWidth;
                CGFloat gx2 = gx1 + gridWidth;
                CGFloat gy2 = gy1 + gridWidth;
                
#if defined(DEBUG)
                NSLog(@"snapTo? (%f, %f) (%f, %f) (%f, %f)", p.x, p.y,
                      gx1, gy1, gx2, gy2);
#endif
                
                if (p.x - gx1 < snapLength)
                {
                    if (p.y - gy1 < snapLength)
                    {
                        CGPoint p2 = CGPointMake(gx1, gy1);
                        CGFloat d = distance(p, p2);
#if defined(DEBUG)
                        NSLog(@"distance = %f", d);
#endif
                        if (d < snapLength)
                            p = p2;
                    }
                    else if (gy2 - p.y < snapLength)
                    {
                        CGPoint p2 = CGPointMake(gx1, gy2);
                        CGFloat d = distance(p, p2);
#if defined(DEBUG)
                        NSLog(@"distance = %f", d);
#endif
                        if (d < snapLength)
                            p = p2;
                    }
                }
                else if (gx2 - p.x < snapLength)
                {
                    if (p.y - gy1 < snapLength)
                    {
                        CGPoint p2 = CGPointMake(gx2, gy1);
                        CGFloat d = distance(p, p2);
#if defined(DEBUG)
                        NSLog(@"distance = %f", d);
#endif
                        if (d < snapLength)
                            p = p2;
                    }
                    else if (gy2 - p.y < snapLength)
                    {
                        CGPoint p2 = CGPointMake(gx2, gy2);
                        CGFloat d = distance(p, p2);
#if defined(DEBUG)
                        NSLog(@"distance = %f", d);
#endif
                        if (d < snapLength)
                            p = p2;
                    }
                }
            }
        
            if (head == NULL)
            {
                head = current = (PointEntry *) malloc(sizeof(PointEntry));
                head->p1 = p;
                head->p2 = CGInvalidPoint;
                head->next = NULL;
                prev = head;
            }
            else
            {
                if (isInvalidCGPoint(current->p2))
                {
                    current->p2 = p;
                }
                else
                {
                    PointEntry *next = (PointEntry *) malloc(sizeof(PointEntry));
                    next->p1 = p;
                    next->p2 = CGInvalidPoint;
                    next->next = NULL;
                    current->next = next;
                    prev = current;
                    current = next;
                }
            }
        }
        
        [xhairView setFirstPoint: current->p1 secondPoint: current->p2];
        
        if (!isInvalidCGPoint(current->p2))
            [self setNeedsDisplay];
    
        /*CGPoint p = prev->p2;
        if (isInvalidCGPoint(p))
            p = prev->p1;
    
        CGMutablePathRef xhair = CGPathCreateMutable();
        const CGPoint xp[] = { CGPointMake(p.x - xh1(), p.y), CGPointMake(p.x + xh1(), p.y) };
        const CGPoint yp[] = { CGPointMake(p.x, p.y - xh1()), CGPointMake(p.x, p.y + xh1()) };
    
        CGPathAddEllipseInRect(xhair, NULL, CGRectMake(p.x-xh2(), p.y-xh2(), (2 * xh2()), (2 * xh2())));
        CGPathCloseSubpath(xhair);
        CGPathMoveToPoint(xhair, NULL, xp[0].x, xp[0].y);
        CGPathAddLineToPoint(xhair, NULL, xp[1].x, xp[1].y);
        CGPathMoveToPoint(xhair, NULL, yp[0].x, yp[0].y);
        CGPathAddLineToPoint(xhair, NULL, yp[1].x, yp[1].y);
        
        if (!isInvalidCGPoint(prev->p2))
        {
            CGPathCloseSubpath(xhair);
            CGPathMoveToPoint(xhair, NULL, prev->p2.x, prev->p2.y);
            CGPathAddLineToPoint(xhair, NULL, prev->p1.x, prev->p1.y);
        }
        
        crosshairLayer.path = xhair;
        CGPathRelease(xhair);
        
        [CATransaction begin];
        [CATransaction setAnimationDuration: 3.0];
        crosshairLayer.opacity = 0.0;
        [CATransaction commit];
        
        CABasicAnimation *opa = [CABasicAnimation animationWithKeyPath: @"opacity"];
        opa.fromValue = [NSNumber numberWithFloat: 1.0];
        opa.toValue = [NSNumber numberWithFloat: 0.0];
        opa.duration = 1.0;
        opa.beginTime = 2.5;
        opa.delegate = self;
        [crosshairLayer addAnimation: opa forKey: @"animateOpacity"];*/
        
        [UIView beginAnimations: @"FadeOutCrosshair" context: NULL];
        [UIView setAnimationDuration: 1.0];
        [UIView setAnimationDelay: 3.0];
        xhairView.alpha = 0.0;
        [UIView commitAnimations];
    }
}

- (void) touchesMoved: (NSSet *) touches
            withEvent: (UIEvent *) event
{
    if ([touches count] == 1)
    {
        for (UITouch *touch in touches)
        {
            CGPoint p = [touch locationInView: self];
            if (current == NULL || !isInvalidCGPoint(current->p2))
                [xhairView setFirstPoint: p secondPoint: CGInvalidPoint];
            else
                [xhairView setFirstPoint: current->p1 secondPoint: p];
            
            /*CGMutablePathRef xhair = CGPathCreateMutable();
            const CGPoint xp[] = { CGPointMake(p.x - xh1(), p.y), CGPointMake(p.x + xh1(), p.y) };
            const CGPoint yp[] = { CGPointMake(p.x, p.y - xh1()), CGPointMake(p.x, p.y + xh1()) };
        
            CGPathAddEllipseInRect(xhair, NULL, CGRectMake(p.x-xh2(), p.y-xh2(), (2 * xh2()), (2 * xh2())));
            CGPathCloseSubpath(xhair);
            CGPathMoveToPoint(xhair, NULL, xp[0].x, xp[0].y);
            CGPathAddLineToPoint(xhair, NULL, xp[1].x, xp[1].y);
            CGPathMoveToPoint(xhair, NULL, yp[0].x, yp[0].y);
            CGPathAddLineToPoint(xhair, NULL, yp[1].x, yp[1].y);
            
            if (current != NULL && isInvalidCGPoint(current->p2))
            {
                CGPathCloseSubpath(xhair);
                CGPathMoveToPoint(xhair, NULL, p.x, p.y);
                CGPathAddLineToPoint(xhair, NULL, current->p1.x, current->p1.y);
            }
            
            crosshairLayer.path = xhair;
            CGPathRelease(xhair);*/
        }
    }
}

@end

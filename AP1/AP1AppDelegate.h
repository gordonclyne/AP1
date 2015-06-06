//
//  AP1AppDelegate.h
//  AP1
//
//  Created by Casey Marshall on 8/30/10. and Gordon on June 3 -2015
//  Copyright Modal Domains 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanvasView.h"

@class AP1ViewController;

@interface AP1AppDelegate : NSObject <UIApplicationDelegate> {
    CanvasView *canvas;
    UIWindow *window;
    AP1ViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AP1ViewController *viewController;

- (void) notifyExternalScreenConnected: (NSNotification *) n;
- (void) notifyExternalScreenDisconnected: (NSNotification *) n;

@end


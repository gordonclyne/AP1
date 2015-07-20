//
//  AppDelegate.h
//  AP1
//
//  Created by Bernardo Santana on 6/6/15.
//  Copyright (c) 2015 Modal Domains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanvasView.h"

@class AP1ViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    CanvasView *canvas;
    AP1ViewController *viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) AP1ViewController *viewController;

@end
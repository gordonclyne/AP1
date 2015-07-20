//
//  AppDelegate.m
//  AP1
//
//  Created by Bernardo Santana on 6/6/15.
//  Copyright (c) 2015 Modal Domains. All rights reserved.
//

#import "AppDelegate.h"
#import "AP1ViewController.h"
#import "UIColor+rgb.h"


@implementation AppDelegate

@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after app launch.
    
    [application setStatusBarHidden: YES
                           animated: YES];
    viewController = (AP1ViewController *)self.window.rootViewController;
    
    canvas = [[CanvasView alloc] initWithFrame: _window.bounds];
    
    canvas.multipleTouchEnabled = YES;
    canvas.backgroundColor = [UIColor blackColor];
    viewController.canvas = canvas;
    canvas.lineCount = 32;
    canvas.lineThickness = 2.0;
    canvas.leftOutlierCount = 0;
    canvas.rightOutlierCount = 0;
    canvas.backgroundColor = [UIColor blackColor];
    canvas.leftLineColor = [UIColor blueColor];
    canvas.rightLineColor = [UIColor redColor];
    canvas.leftOutlierColor = [UIColor whiteColor];
    canvas.rightOutlierColor = [UIColor whiteColor];
    
    [canvas loadCanvasState]; // load saved state, if any, if possible
    
    canvas.gridWidth = 25.0;
    canvas.griddedMode = NO;
    
    [viewController.view addSubview: canvas];
    [viewController.view sendSubviewToBack:canvas];
//    [window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
 
    [canvas saveCanvasState];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [canvas loadCanvasState];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [canvas saveCanvasState];
}

@end

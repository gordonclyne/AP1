//
//  AP1AppDelegate.m
//  AP1
//
//  Created by Casey Marshall on 8/30/10.
//  Copyright Modal Domains 2010. All rights reserved.
//

#import "AP1AppDelegate.h"
#import "AP1ViewController.h"
#import "TransparentView.h"
#import "UIColor+rgb.h"

@implementation AP1AppDelegate

@synthesize window = _window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    if ([application respondsToSelector: @selector(setStatusBarHidden:withAnimation:)])
        [application setStatusBarHidden: YES
                          withAnimation: UIStatusBarAnimationSlide];
    else // iOS 3.1.x
        [application setStatusBarHidden: YES
                               animated: YES];
    // Override point for customization after app launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *mainstoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainViewController = [mainstoryBoard instantiateInitialViewController];
    self.window.rootViewController = mainViewController;
    canvas = [[CanvasView alloc] initWithFrame: window.bounds];
    canvas.multipleTouchEnabled = YES;
    canvas.backgroundColor = [UIColor blackColor];
    ((TransparentView *) viewController.view).forwardingResponder = canvas;
    ((TransparentView *) viewController.view).forwarding = YES;
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
    
    ((TransparentView *) viewController.view).gridColor = [UIColor colorWithRed:0.960 green:0.730 blue:0.730 alpha:1.000];
    ((TransparentView *) viewController.view).gridWidth = 25.0;
    ((TransparentView *) viewController.view).isGridOn = NO;
    canvas.gridWidth = 25.0;
    canvas.griddedMode = NO;
    
    //[window addSubview: canvas];
    //[window addSubview:viewController.view];
    [window makeKeyAndVisible];

	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void) applicationWillTerminate: (UIApplication *) application
{
    [canvas saveCanvasState];
}

- (void) applicationDidEnterBackground:(UIApplication *)application
{
	[canvas saveCanvasState];
}

- (void) applicationWillEnterForeground:(UIApplication *)application
{
	[canvas loadCanvasState];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void) notifyExternalScreenConnected:(NSNotification *)n
{
}

- (void) notifyExternalScreenDisconnected:(NSNotification *)n
{
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

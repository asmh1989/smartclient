//
//  SmartClinetAppDelegate.m
//  SmartClient
//
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "SmartClinetAppDelegate.h"
#import "SmartClinetViewController.h"
#import "SettingStore.h"

#import "MMNavigationController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "SmartClinetLeftMenuViewController.h"
#import "MMExampleDrawerVisualStateManager.h"

@interface SmartClinetAppDelegate ()
@property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation SmartClinetAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    SmartClinetViewController * centerViewController = [[SmartClinetViewController alloc] init];
    
    UIViewController * leftMenuController = [[SmartClinetLeftMenuViewController alloc] initWithCenterController:centerViewController];
    
//    UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:centerViewController];
//    [navigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
    if(OSVersionIsAtLeastiOS7()){
//        UINavigationController * leftSideNavController = [[MMNavigationController alloc] initWithRootViewController:leftMenuController];
		[leftMenuController setRestorationIdentifier:@"leftSideDrawerViewControllerRestorationKey"];
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:centerViewController
                                 leftDrawerViewController:leftMenuController
                                 rightDrawerViewController:nil];
        [self.drawerController setShowsShadow:YES];
    }
    else{
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:centerViewController
                                 leftDrawerViewController:leftMenuController
                                 rightDrawerViewController:nil];
    }
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:160.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(OSVersionIsAtLeastiOS7()){
        UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                              green:173.0/255.0
                                               blue:234.0/255.0
                                              alpha:1.0];
        [self.window setTintColor:tintColor];
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.drawerController];
    [[self window] setRootViewController:navController];
    [[self.drawerController navigationController] setNavigationBarHidden:YES];
    self.drawerController.title = NSLocalizedString(@"Settings", @"Settings");
    
//    [self.window setRootViewController:self.drawerController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   BOOL success = [[SettingStore shareStore] saveSettingsConfig];
    if (success) {
        NSLog(@"success save data");
    } else {
        NSLog(@"error to save");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    id tmp = [self.drawerController centerViewController];
    SmartClinetViewController *controller = tmp;
    [controller checkCurrentSocketStatus];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

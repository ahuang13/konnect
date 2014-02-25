//
//  AppDelegate.m
//  Konnect
//
//  Created by Angus Huang on 2/1/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "AppDelegate.h"
#import "LogInViewController.h"
#import <Parse/Parse.h>
#import "Notifications.h"
#import "Profile.h"
#import "SeekerViewController.h"
#import "LinkedInClient.h"
#import "RecruiterViewController.h"
#import "SeekerOrRecruiterViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong, readonly) UIViewController *rootViewController;
@property (nonatomic, strong) LogInViewController *logInViewController;
@property (nonatomic, strong) SeekerViewController *seekerViewController;
@property (nonatomic, strong) RecruiterViewController *recruiterViewController;
@property (nonatomic, strong) SeekerOrRecruiterViewController *seekerOrRecruiterViewController;
@property (nonatomic, strong) UITabBarController *tabBarController;


@property (nonatomic, strong) UINavigationController *navController;



@end

@implementation AppDelegate

//------------------------------------------------------------------------------
#pragma mark - UIApplicationDelegate Methods
//------------------------------------------------------------------------------

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initParse:launchOptions];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Set the rootViewController depending on the logged in status.
    self.window.rootViewController = self.rootViewController;
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self registerForLoginLogoutNotifications];
    
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//------------------------------------------------------------------------------
#pragma mark - Getters
//------------------------------------------------------------------------------

- (UIViewController *)rootViewController {
    
    if ([self isJobSeekerLoggedIn]) {
        return self.seekerViewController;
    } else {
        return self.logInViewController;
    }
}

- (LogInViewController *)logInViewController {
    
    if (!_logInViewController) {
        _logInViewController = [[LogInViewController alloc] init];
    }
    
    return _logInViewController;
}


- (SeekerViewController *)seekerViewController {
    
    if (!_seekerViewController) {
        _seekerViewController = [[SeekerViewController alloc] init];
    }
    
    return _seekerViewController;
}

- (RecruiterViewController *)recruiterViewController {
    
    if (!_recruiterViewController) {
        _recruiterViewController = [[RecruiterViewController alloc] init];
    }
    
    return _recruiterViewController;
}

- (SeekerOrRecruiterViewController *)seekerOrRecruiterViewController {
    
    if (!_seekerOrRecruiterViewController) {
        _seekerOrRecruiterViewController = [[SeekerOrRecruiterViewController alloc] init];
    }
    
    return _seekerOrRecruiterViewController;
}

- (UITabBarController *)tabBarController {
    
    if (!_tabBarController) {
        _tabBarController = [[UITabBarController alloc] init];
        _tabBarController.viewControllers = [NSArray arrayWithObjects:self.seekerOrRecruiterViewController, self.seekerViewController, nil];
    }
    
    return _tabBarController;
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)initParse:(NSDictionary *)launchOptions {
    
    [Parse setApplicationId:@"FaZR0g3o0QVnqpoezw7skDDwoRiB24Ui8yRGczo5"
                  clientKey:@"hp0j9THk3PJthNhXl3bVDLxATL5cMzP8kXVTGBbQ"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

- (void)registerForLoginLogoutNotifications {
    
    NSNotificationCenter *defaultNotificationCenter = [NSNotificationCenter defaultCenter];
    
    [defaultNotificationCenter addObserver:self
                                  selector:@selector(onSeekerDidLogin)
                                      name:SEEKER_DID_LOGIN_NOTIFICATION
                                    object:nil];
    
    [defaultNotificationCenter addObserver:self
                                  selector:@selector(onSeekerDidLogout)
                                      name:SEEKER_DID_LOGOUT_NOTIFICATION
                                    object:nil];
}

- (void)onSeekerDidLogin {
    self.window.rootViewController = self.tabBarController;
}

- (BOOL)isJobSeekerLoggedIn {
    return ([LinkedInClient instance].accessToken != nil);
}

- (void)onSeekerDidLogout {
    self.window.rootViewController = self.logInViewController;
}


@end

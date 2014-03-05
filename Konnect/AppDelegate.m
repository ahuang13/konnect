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
#import "LinkedInClient.h"
#import "SettingsViewController.h"
#import "SeekerViewController.h"
#import "RecruiterViewController.h"
#import "CandidatesViewController.h"
#import "JobsViewController.h"
#import "RecruiterMessagesViewController.h"
#import "SeekerMessagesViewController.h"
#import "CandidatesContainerViewController.h"

@interface AppDelegate ()

// Root View Controllers
@property (nonatomic, strong, readonly) UIViewController *rootViewController;
@property (nonatomic, strong) LogInViewController *logInViewController;
@property (nonatomic, strong) UITabBarController *tabBarController;

// Tab Bar Content View Controllers
@property (nonatomic, strong) SettingsViewController *settingsViewController;
@property (nonatomic, strong) SeekerViewController *seekerViewController;
@property (nonatomic, strong) RecruiterViewController *recruiterViewController;
@property (nonatomic, strong) CandidatesContainerViewController *candidatesViewController;
// @property (nonatomic, strong) CandidatesViewController *candidatesViewController;
@property (nonatomic, strong) JobsViewController *jobsViewController;
@property (nonatomic, strong) RecruiterMessagesViewController *recruiterMessagesViewController;
@property (nonatomic, strong) SeekerMessagesViewController *seekerMessagesViewController;

// Other private properties
@property (nonatomic, strong) NSArray *recruiterViewControllers;
@property (nonatomic, strong) NSArray *seekerViewControllers;

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
#pragma mark - Public Getters/Setters
//------------------------------------------------------------------------------

- (void)setIsRecruiterMode:(BOOL)isRecruiterMode {
    
    // If the value is not changing, return immediately.
    if (isRecruiterMode == _isRecruiterMode)
        return;
    
    // Set the new value.
    _isRecruiterMode = isRecruiterMode;
    
    // Update the tab bar's content view controllers.
    if (_isRecruiterMode) {
        self.tabBarController.viewControllers = self.recruiterViewControllers;
    } else {
        self.tabBarController.viewControllers = self.seekerViewControllers;
    }
}

//------------------------------------------------------------------------------
#pragma mark - Private Getters/Setters
//------------------------------------------------------------------------------

- (NSArray *)recruiterViewControllers {
    
    if (!_recruiterViewControllers) {
        _recruiterViewControllers = [NSArray arrayWithObjects:
                                     self.settingsViewController,
                                     self.recruiterViewController,
                                     self.candidatesViewController,
                                     self.recruiterMessagesViewController,
                                     nil];
    }
    return _recruiterViewControllers;
}

- (NSArray *)seekerViewControllers {
    
    if (!_seekerViewControllers) {
        _seekerViewControllers = [NSArray arrayWithObjects:
                                  self.settingsViewController,
                                  self.seekerViewController,
                                  self.jobsViewController,
                                  self.seekerMessagesViewController,
                                  nil];
    }
    return _seekerViewControllers;
}

- (UIViewController *)rootViewController {
    
    if ([self isJobSeekerLoggedIn]) {
        return self.tabBarController;
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

- (UITabBarController *)tabBarController {
    
    if (!_tabBarController) {
        
        _tabBarController = [[UITabBarController alloc] init];

        if (_isRecruiterMode) {
            _tabBarController.viewControllers = self.recruiterViewControllers;
        } else {
            _tabBarController.viewControllers = self.seekerViewControllers;
        }
    }
    
    return _tabBarController;
}

- (SettingsViewController *)settingsViewController {
    
    if (!_settingsViewController) {
        _settingsViewController = [[SettingsViewController alloc] init];
    }
    
    return _settingsViewController;
}

- (SeekerViewController *)seekerViewController {
    
    if (!_seekerViewController) {
        _seekerViewController = [[SeekerViewController alloc] initWithProfile:[Profile currentUser]];
    }
    
    return _seekerViewController;
}

- (RecruiterViewController *)recruiterViewController {
    
    if (!_recruiterViewController) {
        _recruiterViewController = [[RecruiterViewController alloc] init];
    }
    
    return _recruiterViewController;
}

- (CandidatesContainerViewController *)candidatesViewController {
    
    if (!_candidatesViewController) {
        _candidatesViewController = [[CandidatesContainerViewController alloc] init];
    }
    
    return _candidatesViewController;
}

//- (CandidatesViewController *)candidatesViewController {
//    
//    if (!_candidatesViewController) {
//        _candidatesViewController = [[CandidatesViewController alloc] init];
//    }
//    
//    return _candidatesViewController;
//}

- (JobsViewController *)jobsViewController {
    
    if (!_jobsViewController) {
        _jobsViewController = [[JobsViewController alloc] init];
    }
    
    return _jobsViewController;
}

- (RecruiterMessagesViewController *)recruiterMessagesViewController {
    
    if (!_recruiterMessagesViewController) {
        _recruiterMessagesViewController = [[RecruiterMessagesViewController alloc] init];
    }
    
    return _recruiterMessagesViewController;
}

- (SeekerMessagesViewController *)seekerMessagesViewController {
    
    if (!_seekerMessagesViewController) {
        _seekerMessagesViewController = [[SeekerMessagesViewController alloc] init];
    }
    
    return _seekerMessagesViewController;
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

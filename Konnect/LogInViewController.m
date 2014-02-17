//
//  LogInViewController.m
//  Konnect
//
//  Created by Angus Huang on 2/2/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "LIALinkedInHttpClient+Helpers.h"
#import "NSString+LIAEncode.h"
#import "Profile.h"
#import "LinkedInClient.h"
#import "RecruiterLoginViewController.h"
#import "RecruiterSignUpViewController.h"
#import "Notifications.h"

@interface LogInViewController ()

- (IBAction)onLoginButtonClicked:(UIButton *)sender;
- (IBAction)onRecruiterLoginButtonClicked:(UIButton *)sender;

@end

@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - PFLogInViewControllerDelegate
//------------------------------------------------------------------------------

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController
shouldBeginLogInWithUsername:(NSString *)username
                   password:(NSString *)password {
    
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil)
                                message:NSLocalizedString(@"Make sure you fill out all of the information!", nil)
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil] show];
    
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    // TODO: Set the current recruiter user and show the recruiter ViewController.
    NSLog(@"%@", user);
    [[NSNotificationCenter defaultCenter] postNotificationName:RECRUITER_LOGGED_IN_NOTIFICATION object:nil];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in as recruiter: %@", error.localizedDescription);
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the recruiter login.");
}

//------------------------------------------------------------------------------
#pragma mark - PFSignUpViewControllerDelegate Methods
//------------------------------------------------------------------------------

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController
           shouldBeginSignUp:(NSDictionary *)info {
    
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController
               didSignUpUser:(PFUser *)user {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    // TODO: Set current user and show Recruiter ViewController.
    NSLog(@"%@", user);
    [[NSNotificationCenter defaultCenter] postNotificationName:RECRUITER_LOGGED_IN_NOTIFICATION object:nil];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController
    didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up: %@", error.localizedDescription);
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the recruiter sign-up.");
}

//------------------------------------------------------------------------------
#pragma mark - IBAction Methods
//------------------------------------------------------------------------------

- (IBAction)onLoginButtonClicked:(UIButton *)sender {
    [[LIALinkedInHttpClient instance] login];
}

- (IBAction)onRecruiterLoginButtonClicked:(UIButton *)sender {
    
    // Create the log in view controller
    RecruiterLoginViewController *logInViewController = [[RecruiterLoginViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Create the sign up view controller
    RecruiterSignUpViewController *signUpViewController = [[RecruiterSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
}

@end

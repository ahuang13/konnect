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
#import "NSString+LIAEncode.h"
#import "Profile.h"
#import "LinkedInClient.h"

@interface LogInViewController ()

- (IBAction)onLoginButtonClicked:(UIButton *)sender;

@end

@implementation LogInViewController {
    LIALinkedInHttpClient *_client;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _client = [self client];
    
    NSLog(@"viewDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButtonClicked:(UIButton *)sender
{
    NSLog(@"onLoginButtonClicked");
    
    [self.client getAuthorizationCode:^(NSString *code) {
        
        [self.client getAccessToken:code
                            success:^(NSDictionary *accessTokenData) {
                                
                                NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
                                [LinkedInClient instance].accessToken = accessToken;
                                
                                [self getCurrentUser];
                            }
                            failure:^(NSError *error) {
                                NSLog(@"Quering accessToken failed %@", error);
                            }];
    }
                               cancel:^{
                                   NSLog(@"Authorization was cancelled by user");
                               }
                              failure:^(NSError *error) {
                                  NSLog(@"Authorization failed %@", error);
                              }];
}

- (void)getCurrentUser {
    
    // Download the current user profile and set the app's current user.
    
    void (^success)(AFHTTPRequestOperation *, id) = ^void(AFHTTPRequestOperation *operation, id response) {
        
        Profile *currentUser = [[Profile alloc] initWithDictionary:response];
        [Profile setCurrentUser:currentUser];

        NSLog(@"current user %@", response);
        NSLog(@"first name: %@", currentUser.firstName);
        NSLog(@"last name: %@", currentUser.lastName);
        NSLog(@"location: %@", currentUser.location);
    };

    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^void(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to download current user: %@", error.localizedDescription);
    };
    
    [[LinkedInClient instance] currentUserWithSuccess:success failure:failure];
}

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://www.ancientprogramming.com/liaexample"
                                                                                    clientId:@"772cu46bnok4kw"
                                                                                clientSecret:@"WpVAXnuGWK1Jsdp3"
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_fullprofile", @"r_network"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}

@end

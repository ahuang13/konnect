//
//  SeekerViewController.m
//  Konnect
//
//  Created by Angus Huang on 2/16/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "SeekerViewController.h"
#import "Profile.h"
#import "AFHTTPRequestOperation.h"
#import "LinkedInClient.h"
#import "Education.h"
#import "Company.h"


@interface SeekerViewController ()

- (IBAction)onSignOutButtonClick:(UIButton *)sender;

@end

@implementation SeekerViewController

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
    
    [self tempGetCurrentUser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------
#pragma mark - IBAction Methods
//------------------------------------------------------------------------------

- (IBAction)onSignOutButtonClick:(UIButton *)sender {
    [[LinkedInClient instance] setAccessToken:nil];
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)tempGetCurrentUser {
    
    // Download the current user profile and set the app's current user.
    
    void (^success)(AFHTTPRequestOperation *, id) = ^void(AFHTTPRequestOperation *operation, id response) {
        
        Profile *currentUser = [[Profile alloc] initWithDictionary:response];
        
        NSLog(@"current user %@", response);
        NSLog(@"first name: %@", currentUser.firstName);
        NSLog(@"last name: %@", currentUser.lastName);
        NSLog(@"location: %@", currentUser.location);
        Education *education = [currentUser.educations objectAtIndex:0];
        NSLog(@"education endYear: %@", education.endYear);
        Company *company = [currentUser.currentPositions objectAtIndex:0];
        NSLog(@"companyName: %@", company.name);
    };
    
    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^void(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to download current user: %@", error.localizedDescription);
    };
    
    [[LinkedInClient instance] currentUserWithSuccess:success failure:failure];
}

@end

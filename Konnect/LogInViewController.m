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
#import "Notifications.h"
#import "CurrentPosition.h"
#import "Education.h"

@interface LogInViewController ()

- (IBAction)onLoginButtonClicked:(UIButton *)sender;

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
#pragma mark - IBAction Methods
//------------------------------------------------------------------------------

- (IBAction)onLoginButtonClicked:(UIButton *)sender {
    [[LIALinkedInHttpClient instance] login];
    [self getCurrentUser];
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)getCurrentUser {
    
    // Download the current user profile and set the app's current user.
    
    void (^success)(AFHTTPRequestOperation *, id) = ^void(AFHTTPRequestOperation *operation, id response) {
        
        Profile *currentUser = [[Profile alloc] initWithDictionary:response];
        [Profile setCurrentUser:currentUser];
        
        [self createOrUpdateCandidateProfile:currentUser];
    };
    
    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^void(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to download current user: %@", error.localizedDescription);
    };
    
    [[LinkedInClient instance] currentUserWithSuccess:success failure:failure];
}

- (void)createOrUpdateCandidateProfile:(Profile *)profile {
    // Get parse object with the user's first and last name
    PFQuery *profileQuery = [PFQuery queryWithClassName:@"SeekerProfile"];
    [profileQuery whereKey:@"linkedInId" equalTo:profile.linkedInId];
    
    
    [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            if ([objects count] == 0) {
                
                // If parse object doesnt exist, create it
                PFObject *seekerProfile = [PFObject objectWithClassName:@"SeekerProfile"];
                
                if (profile.firstName)
                    [seekerProfile setObject:profile.firstName forKey:@"firstName"];
                if (profile.lastName)
                    [seekerProfile setObject:profile.lastName forKey:@"lastName"];
                if (profile.headline)
                    [seekerProfile setObject:profile.headline forKey:@"headline"];
                if (profile.headline)
                    [seekerProfile setObject:profile.location forKey:@"location"];
                if (profile.summary)
                    [seekerProfile setObject:profile.summary forKey:@"summary"];
                if (profile.linkedInId)
                    [seekerProfile setObject:profile.linkedInId forKey:@"linkedInId"];
                
                CurrentPosition *currentPosition = [profile.currentPositions objectAtIndex:0];
                if (currentPosition.company.name)
                    [seekerProfile setObject:currentPosition.company.name forKey:@"companyName"];
                if (currentPosition.summary)
                    [seekerProfile setObject:currentPosition.summary forKey:@"jobDescription"];
                
                // Create parse objects for educations
                for (Education *education in profile.educations) {
                    
                    PFObject *pfeducation = [PFObject objectWithClassName:@"Education"];
                    if (education.school)
                        [pfeducation setObject:education.school forKey:@"schoolName"];
                    if (education.degree)
                        [pfeducation setObject:education.degree forKey:@"degree"];
                    if (education.major)
                        [pfeducation setObject:education.major forKey:@"major"];
                    if (seekerProfile)
                        [pfeducation setObject:seekerProfile forKey:@"seekerProfile"];
                    
                    // Save the new education profile
                    [pfeducation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                        }
                    }];
                }
            }
        }
    }];
}
@end

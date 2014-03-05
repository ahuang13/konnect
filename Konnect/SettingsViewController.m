//
//  SeekerOrRecruiterViewController.m
//  Konnect
//
//  Created by fxie on 2/24/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "SettingsViewController.h"
#import "LinkedInClient.h"
#import "AppDelegate.h"
#import "NSString+LIAEncode.h"
#import "Profile.h"
#import "LinkedInClient.h"
#import "Notifications.h"
#import "CurrentPosition.h"
#import "Education.h"
#import <Parse/Parse.h>


@interface SettingsViewController ()

@property (strong, nonatomic, readonly) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UISegmentedControl *seekerOrRecruiterSegmentedControl;

- (IBAction)signOutButton:(id)sender;

@end

@implementation SettingsViewController

//------------------------------------------------------------------------------
#pragma mark - Initializers
//------------------------------------------------------------------------------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initTabBarItem];
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - Lifecycle
//------------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.seekerOrRecruiterSegmentedControl.selectedSegmentIndex = self.appDelegate.isRecruiterMode ? 1 : 0;
    [self.seekerOrRecruiterSegmentedControl addTarget:self
                                               action:@selector(segmentedControlValueDidChange:)
                                     forControlEvents:UIControlEventValueChanged];
    [self getCurrentUser];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------
#pragma mark - IBActions
//------------------------------------------------------------------------------

- (IBAction)signOutButton:(id)sender {
    [LinkedInClient instance].accessToken = nil;
}

//------------------------------------------------------------------------------
#pragma mark - Getters/Setters
//------------------------------------------------------------------------------

- (AppDelegate *)appDelegate {
    return [[UIApplication sharedApplication] delegate];
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)initTabBarItem {
    
    NSString *title = @"Settings";
    UIImage *icon = [UIImage imageNamed:@"settings-50"];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:icon tag:0];
    
    self.tabBarItem = tabBarItem;
}

- (void)segmentedControlValueDidChange:(UISegmentedControl *)sender {
    self.appDelegate.isRecruiterMode = (sender.selectedSegmentIndex == 1);
}

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
                if (profile.pictureUrl)
                    [seekerProfile setObject:profile.pictureUrl forKey:@"pictureUrl"];
                
                CurrentPosition *currentPosition = [profile.currentPositions objectAtIndex:0];
                if (currentPosition.company.name)
                    [seekerProfile setObject:currentPosition.company.name forKey:@"companyName"];
                if (currentPosition.summary)
                    [seekerProfile setObject:currentPosition.summary forKey:@"jobDescription"];
                if (currentPosition.title)
                    [seekerProfile setObject:currentPosition.title forKey:@"title"];
                
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

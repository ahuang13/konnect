//
//  JobsViewController.m
//  Konnect
//
//  Created by Angus Huang on 3/1/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "JobsViewController.h"
#import "Parse/Parse.h"
#import "Profile.h"
#import "CurrentPosition.h"
#import "JobProfile.h"

@interface JobsViewController ()


@property (strong, nonatomic) NSMutableArray *jobs;
@property (strong, nonatomic) PFObject *pfSeekerProfile;


@end

@implementation JobsViewController

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
    [self loadSeeker];
    [self loadJobs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initTabBarItem {
    
    NSString *title = @"Jobs";
    UIImage *icon = [UIImage imageNamed:@"briefcase-50"];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:icon tag:0];
    
    self.tabBarItem = tabBarItem;
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)loadSeeker {
    Profile *currentUser = [Profile currentUser];
    if (currentUser) {
        PFQuery *profileQuery = [PFQuery queryWithClassName:@"SeekerProfile"];
        [profileQuery whereKey:@"linkedInId" equalTo:currentUser.linkedInId];
        [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects)
                {
                    NSString *firstName = [object objectForKey:@"firstName"];
                    
                    NSLog(@"%@ would like a job!", firstName);
                    
                    self.pfSeekerProfile = object;
                    
                }
            }
        }];
    }
}

- (void) loadJobs {
    // See current user profile to figure out what type of job to load
    Profile *userProfile = [Profile currentUser];
    if (userProfile && [userProfile.currentPositions count] > 0) {
        PFQuery *profileQuery = [PFQuery queryWithClassName:@"JobProfile"];
        CurrentPosition *currentPosition = [userProfile.currentPositions objectAtIndex:0];
        [profileQuery whereKey:@"title" equalTo:currentPosition.title];
    
        [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    JobProfile *jobProfile = [[JobProfile alloc] initWithPFObject:object];
                    NSString *company = jobProfile.companyName;
                    NSString *title = jobProfile.title;
                
                    NSLog(@"Come work as a %@ at %@!", title, company);
                
                    [self.jobs addObject:jobProfile];
                    [self selectJob:jobProfile];
                }
            }
        }];
    }
    else {
        NSLog(@"The position the user is seeking is unknown");
    }
}


- (void)selectJob:(JobProfile *) jobProfile {
    Profile *profile = [Profile currentUser];
    if(profile) {
        
        PFObject *seekerSelection = [PFObject objectWithClassName:@"SeekerSelection"];
        [seekerSelection setObject:jobProfile.userLinkedInId forKey:@"recruiterLinkedInId"];
        [seekerSelection setObject:profile.linkedInId forKey:@"seekerLinkedInId"];
    
        // Save the new seekerSelection
        [seekerSelection saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
            }
        }];
    }
}


@end

//
//  CandidatesViewController.m
//  Konnect
//
//  Created by Angus Huang on 3/1/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "CandidatesViewController.h"
#import "Parse/Parse.h"
#import "Profile.h"
#import "CurrentPosition.h"


@interface CandidatesViewController ()

@property (strong, nonatomic) NSString *jobTitle;
@property (strong, nonatomic) PFObject *pfJobProfile;
@property (strong, nonatomic) NSMutableArray *candidates;



@end

@implementation CandidatesViewController

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
    [self loadJob];
    [self loadCandidates];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabBarItem {
    
    NSString *title = @"Candidates";
    UIImage *icon = [UIImage imageNamed:@"group-50"];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:icon tag:0];
    
    self.tabBarItem = tabBarItem;
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)loadJob {
    Profile *currentUser = [Profile currentUser];
    if (currentUser) {
        PFQuery *profileQuery = [PFQuery queryWithClassName:@"JobProfile"];
        [profileQuery whereKey:@"userLinkedInId" equalTo:currentUser.linkedInId];
        [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects)
                {
                    NSString *companyName = [object objectForKey:@"companyName"];
                    NSLog(@"%@ is hiring!", companyName);
                    
                    self.pfJobProfile = object;
                    
                }
            }
        }];
    }
}

- (void)loadCandidates {
    
    // See current user profile to figure out what type of job to load

    self.jobTitle = @"Software Engineer";
    PFQuery *profileQuery = [PFQuery queryWithClassName:@"SeekerProfile"];
    [profileQuery whereKey:@"title" equalTo:self.jobTitle];
        
    [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *seekerProfile in objects)
            {
                //Load the candidates educations
                PFQuery *educationQuery = [PFQuery queryWithClassName:@"Education"];
                [educationQuery whereKey:@"seekerProfile" equalTo:seekerProfile];
                
                [educationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        
                        //Create profile out of pfobject
                        Profile *candidateProfile = [[Profile alloc] initWithPFObject:seekerProfile educations:objects];
                        NSString *firstName = candidateProfile.firstName;
                        NSString *lastName = candidateProfile.lastName;
                        CurrentPosition *currentPosition = [candidateProfile.currentPositions objectAtIndex:0];
                        NSString *company = currentPosition.company.name;
                    
                        NSLog(@"Hire %@ %@ from %@!", firstName, lastName, company);
                        [self.candidates addObject:candidateProfile];
                    }
                }];
            }
        }
    }];
}

- (void)selectCandidate:(Profile *) profile {
    
    // Get parse object with the profile's linkedInId
    PFQuery *profileQuery = [PFQuery queryWithClassName:@"SeekerProfile"];
    [profileQuery whereKey:@"linkedInId" equalTo:profile.linkedInId];
    
    [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count] > 0) {
                PFObject *recruiterSelection = [PFObject objectWithClassName:@"RecruiterSelection"];
                PFObject *seekerProfile = [objects objectAtIndex:0];
                
                [recruiterSelection setObject:seekerProfile forKey:@"SeekerProfile"];
                [recruiterSelection setObject:self.pfJobProfile forKey:@"JobProfile"];
                
                // Save the new recruiterSelection
                [recruiterSelection saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                    }
                }];
                
            }
            
        }
    }];
}



@end

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
    [self loadJobs];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)loadJobs {
    
    // See current user profile to figure out what type of job to load
    Profile *userProfile = [Profile currentUser];
    if (userProfile)
    {
        PFQuery *profileQuery = [PFQuery queryWithClassName:@"JobProfile"];
        CurrentPosition *currentPosition = [userProfile.currentPositions objectAtIndex:0];
        [profileQuery whereKey:@"title" equalTo:currentPosition.title];
    
        [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects)
                {
                    JobProfile *jobProfile = [[JobProfile alloc] initWithPFObject:object];
                    NSString *company = jobProfile.companyName;
                    NSString *title = jobProfile.title;
                
                    NSLog(@"Come work as a %@ at %@!", title, company);
                
                    [self.jobs addObject:jobProfile];
                }
            }
        }];
    }
}

- (void)initTabBarItem {
    
    NSString *title = @"Jobs";
    UIImage *icon = [UIImage imageNamed:@"briefcase-50"];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:icon tag:0];
    
    self.tabBarItem = tabBarItem;
}

@end

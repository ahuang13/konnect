//
//  CandidatesViewController.m
//  Konnect
//
//  Created by Angus Huang on 3/1/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "CandidatesViewController.h"
#import "Parse/Parse.h"


@interface CandidatesViewController ()

@property (strong, nonatomic) NSString *jobTitle;
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

- (void)loadCandidates {
    
    // See current user profile to figure out what type of job to load

    self.jobTitle = @"Software Engineer";
    PFQuery *profileQuery = [PFQuery queryWithClassName:@"SeekerProfile"];
    [profileQuery whereKey:@"title" equalTo:self.jobTitle];
        
    [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects)
            {
                NSString *firstName = [object objectForKey:@"firstName"];
                NSString *lastName = [object objectForKey:@"lastName"];
                NSString *company = [object objectForKey:@"companyName"];
                    
                NSLog(@"Hire %@ %@ from %@!", firstName, lastName, company);
                    
                [self.candidates addObject:object];
            }
        }
    }];
}

- (void)initTabBarItem {
    
    NSString *title = @"Candidates";
    UIImage *icon = [UIImage imageNamed:@"group-50"];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:icon tag:0];
    
    self.tabBarItem = tabBarItem;
}

@end

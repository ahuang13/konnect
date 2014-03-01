//
//  RecruiterViewController.m
//  Konnect
//
//  Created by Angus Huang on 2/16/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "RecruiterViewController.h"
#import <Parse/Parse.h>
#import "Notifications.h"
#import "Profile.h"
#import "Company.h"
#import "AFHTTPRequestOperation.h"
#import "LinkedInClient.h"
#import "CurrentPosition.h"

@interface RecruiterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companySizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *salaryTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) Company *company;


@end

@implementation RecruiterViewController

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
    
    [self getCurrentUserCompany];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------
#pragma mark - IBActions
//------------------------------------------------------------------------------

- (void)onSignOutButton {
    [[LinkedInClient instance] setAccessToken:nil];
}


//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void)initTabBarItem {
    
    NSString *title = @"Job Listing";
    UIImage *icon = [UIImage imageNamed:@"contact_card-50"];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:icon tag:0];
    
    self.tabBarItem = tabBarItem;
}

- (void)getCurrentUserCompany {
    
    // Download the current user profile and set the app's current user.
    
    void (^success)(AFHTTPRequestOperation *, id) = ^void(AFHTTPRequestOperation *operation, id response) {
        
        Profile *currentUser = [[Profile alloc] initWithDictionary:response];
        NSLog(@"current user %@", response);
        CurrentPosition *currentPosition = [currentUser.currentPositions objectAtIndex:0];
        self.company = currentPosition.company;
        self.companyNameLabel.text = self.company.name;
        self.companySizeLabel.text = self.company.size;
        
        NSLog(@"companyName: %@", self.company.name);
        NSLog(@"company id: %ld", (long)self.company.id);
        
        // Download company details to set description
        [self getCompanyDetailsWithCompany:self.company];
    };
    
    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^void(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to download current user: %@", error.localizedDescription);
    };
    
    [[LinkedInClient instance] currentUserWithSuccess:success failure:failure];
}

- (void)getCompanyDetailsWithCompany:(Company *) company{
    
    // Download the current user's company profile and set the app's user company.
    void (^success)(AFHTTPRequestOperation *, id) = ^void(AFHTTPRequestOperation *operation, id response) {
        
        NSLog(@"company detail: %@", response);
        company.companyDetails = response;
        self.descriptionLabel.text = company.description;
        
        NSLog(@"company description: %@", company.description );
        NSLog(@"company logo url: %@", company.logoUrl);
    };
    
    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^void(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to download current company: %@", error);//error.localizedDescription);
    };
    
    [[LinkedInClient instance] currentCompanyWithId: company.id success:success failure:failure];
    
}

@end

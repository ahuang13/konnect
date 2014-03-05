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
#import "Parse/Parse.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"


@interface RecruiterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companySizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *salaryTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property(nonatomic, retain) UINavigationController *navController;


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
    
    [self getCompanyDetailsWithProfile:[Profile currentUser]];
    
    self.titleTextField.delegate = self;
    self.salaryTextField.delegate = self;
    self.locationTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------
#pragma mark - Getters/Setters
//------------------------------------------------------------------------------

#pragma mark - UITextFieldDelegate Methods
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.titleTextField){
        NSLog(@"title field is %@", textField.text);
    }
    else if (textField == self.salaryTextField){
        NSLog(@"salary field is %@", textField.text);

    }
    else if (textField == self.locationTextField){
        NSLog(@"location field is %@", textField.text);
        
    }
    [self.view endEditing: YES];
}
//------------------------------------------------------------------------------
#pragma mark - IBActions
//------------------------------------------------------------------------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (void) doneButtonPressed {
    [self createOrUpdateJob];
    
}

- (void)initTabBarItem {
    
    NSString *title = @"Job Listing";
    UIImage *icon = [UIImage imageNamed:@"contact_card-50"];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:icon tag:0];
    
    self.tabBarItem = tabBarItem;
}

- (void)getCompanyDetailsWithProfile:(Profile*)profile {
    
    // Load current company basics from profile
    if ([profile.currentPositions count] > 0) {
        CurrentPosition *currentPosition = [profile.currentPositions objectAtIndex:0];
        Company *company = currentPosition.company;
    
        // Download the current user's company profile and set the app's user company.
        void (^success)(AFHTTPRequestOperation *, id) = ^void(AFHTTPRequestOperation *operation, id response) {
        
            NSLog(@"company detail: %@", response);
            company.companyDetails = response;
            self.descriptionLabel.text = company.description;
        
            NSLog(@"company description: %@", company.description );
            NSLog(@"company logo url: %@", company.logoUrl);
        
            NSString *imageUrl = company.logoUrl;
            [self.logoImage setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
        
            [self loadedJobProfileFromServerWithProfile:profile];
        };
    
        void (^failure)(AFHTTPRequestOperation *, NSError *) = ^void(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to download current company: %@", error);//error.localizedDescription);
        };
    

        [[LinkedInClient instance] currentCompanyWithId:currentPosition.company.id success:success failure:failure];
    }
    
}

- (void)createOrUpdateJob {
    
    Profile *profile = [Profile currentUser];
    // Load current company basics from profile
    if ([profile.currentPositions count] > 0) {
        
        CurrentPosition *currentPosition = [profile.currentPositions objectAtIndex:0];
        Company *company = currentPosition.company;
    
        // Get parse object with user's linkedin id
        PFQuery *profileQuery = [PFQuery queryWithClassName:@"JobProfile"];
        [profileQuery whereKey:@"userLinkedInId" equalTo:profile.linkedInId];
    
        [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if ([objects count] == 0) {
                
                    // If parse object doesnt exist, create it
                    PFObject *jobProfile = [PFObject objectWithClassName:@"JobProfile"];
                    if (self.titleTextField.text) {
                        [jobProfile setObject:self.titleTextField.text forKey:@"title"];
                    }
                    if (self.locationTextField.text) {
                        [jobProfile setObject:self.locationTextField.text forKey:@"location"];
                    }
                    if (self.salaryTextField.text) {
                        [jobProfile setObject:self.salaryTextField.text forKey:@"salary"];
                    }
                    /*if (self.companyNameLabel.text) {
                        [jobProfile setObject:self.companyNameLabel.text forKey:@"companyName"];
                    }
                    if (self.companySizeLabel.text) {
                        [jobProfile setObject:self.companySizeLabel.text forKey:@"companySize"];
                    }*/
                    if (self.descriptionLabel.text) {
                        [jobProfile setObject:self.descriptionLabel.text forKey:@"description"];
                    }
                    if (company.logoUrl) {
                        [jobProfile setObject:company.logoUrl forKey:@"logoUrl"];
                    }
                    if (profile.linkedInId) {
                        [jobProfile setObject:profile.linkedInId forKey:@"userLinkedInId"];
                    }
                
                    // Save the new education profile
                    [jobProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                        }
                    }];
                }
            }
        }];
    }
}

- (BOOL)loadedJobProfileFromServerWithProfile:(Profile*)profile {
    
    // Get parse object with the user's linkedin ir
    PFQuery *profileQuery = [PFQuery queryWithClassName:@"JobProfile"];
    [profileQuery whereKey:@"userLinkedInId" equalTo:profile.linkedInId];
    
    __block BOOL foundProfile = NO;
    [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count] > 0) {
                PFObject *jobProfile = [objects objectAtIndex:0];
                self.titleTextField.text = [jobProfile objectForKey:@"title"];
                self.salaryTextField.text = [jobProfile objectForKey:@"salary"];
                self.locationTextField.text = [jobProfile objectForKey:@"location"];
            
                foundProfile = YES;
            }
                 
        }
    }];
    
    return foundProfile;
}
@end

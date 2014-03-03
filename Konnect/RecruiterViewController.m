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

@property (strong, nonatomic) Profile *currentUser;
@property (strong, nonatomic) Company *company;


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
    
    UINavigationBar *naviBarObj = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed)];

    [self.view addSubview:naviBarObj];
    
    UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:@"Job Listing"];
    navigItem.rightBarButtonItem = doneItem;
    naviBarObj.items = [NSArray arrayWithObjects: navigItem,nil];
    
    [self getCurrentUserCompany];
    
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

- (void)getCurrentUserCompany {
    
    // Download the current user profile and set the app's current user.
    
    void (^success)(AFHTTPRequestOperation *, id) = ^void(AFHTTPRequestOperation *operation, id response) {
        
        self.currentUser = [[Profile alloc] initWithDictionary:response];
        [Profile setCurrentUser:self.currentUser];

        NSLog(@"current user %@", response);
        CurrentPosition *currentPosition = [self.currentUser.currentPositions objectAtIndex:0];
        self.company = currentPosition.company;
        self.companyNameLabel.text = self.company.name;
        self.companySizeLabel.text = self.company.size;
        
        NSLog(@"companyName: %@", self.company.name);
        NSLog(@"company id: %ld", (long)self.company.id);
        
        // Download company details to set description
        [self getCompanyDetails];
    };
    
    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^void(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to download current user: %@", error.localizedDescription);
    };
    
    [[LinkedInClient instance] currentUserWithSuccess:success failure:failure];
}

- (void)getCompanyDetails{
    
    // Download the current user's company profile and set the app's user company.
    void (^success)(AFHTTPRequestOperation *, id) = ^void(AFHTTPRequestOperation *operation, id response) {
        
        NSLog(@"company detail: %@", response);
        self.company.companyDetails = response;
        self.descriptionLabel.text = self.company.description;
        
        NSLog(@"company description: %@", self.company.description );
        NSLog(@"company logo url: %@", self.company.logoUrl);
        
        //NSString *imageUrl = company.logoUrl;
        //[self.logoImage setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
        
        [self loadedJobProfileFromServer];
    };
    
    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^void(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to download current company: %@", error);//error.localizedDescription);
    };
    
    [[LinkedInClient instance] currentCompanyWithId: self.company.id success:success failure:failure];
    
}

- (void)createOrUpdateJob {
    
    // Get parse object with user's linkedin id
    PFQuery *profileQuery = [PFQuery queryWithClassName:@"JobProfile"];
    [profileQuery whereKey:@"userLinkedInId" equalTo:self.currentUser.linkedInId];
    
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
                if (self.companyNameLabel.text) {
                    [jobProfile setObject:self.companyNameLabel.text forKey:@"companyName"];
                }
                if (self.companySizeLabel) {
                    [jobProfile setObject:self.companySizeLabel.text forKey:@"companySize"];
                }
                if (self.description) {
                    [jobProfile setObject:self.descriptionLabel.text forKey:@"description"];
                }
                if (self.company.logoUrl) {
                    [jobProfile setObject:self.company.logoUrl forKey:@"logoUrl"];
                }
                if (self.currentUser.linkedInId) {
                    [jobProfile setObject:self.currentUser.linkedInId forKey:@"userLinkedInId"];
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

- (BOOL)loadedJobProfileFromServer {
    
    // Get parse object with the user's linkedin ir
    PFQuery *profileQuery = [PFQuery queryWithClassName:@"JobProfile"];
    [profileQuery whereKey:@"userLinkedInId" equalTo:self.currentUser.linkedInId];
    
    __block BOOL foundProfile = NO;
    [profileQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *jobProfile = [objects objectAtIndex:0];
            self.titleTextField.text = [jobProfile objectForKey:@"title"];
            self.salaryTextField.text = [jobProfile objectForKey:@"salary"];
            self.locationTextField.text = [jobProfile objectForKey:@"location"];
            
            foundProfile = YES;
        }
    }];
    
    return foundProfile;
}
@end

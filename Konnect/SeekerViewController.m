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
#import "CurrentPosition.h"
#import "SeekerProfileHeaderCell.h"
#import "SeekerProfileExperienceCell.h"
#import "SeekerProfileEducationCell.h"
#import "UIImageView+AFNetworking.h"
#import "UITableView+Seeker.h"

@interface SeekerViewController ()

- (IBAction)onSignOutButtonClick:(UIButton *)sender;

//@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation SeekerViewController

//------------------------------------------------------------------------------
#pragma mark - Constants
//------------------------------------------------------------------------------

static const NSInteger HEADER = 0;
static const NSInteger SUMMARY = 1;
static const NSInteger POSITIONS = 2;
static const NSInteger EDUCATIONS = 3;

//------------------------------------------------------------------------------
#pragma mark - View Lifecycle
//------------------------------------------------------------------------------

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
    [self.tableView registerSeekerCells];
}

- (void)viewWillAppear:(BOOL)animated {
    [self tempGetCurrentUser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSignOutButtonClick {
    [[LinkedInClient instance] setAccessToken:nil];
}
//------------------------------------------------------------------------------
#pragma mark - IBAction Methods
//------------------------------------------------------------------------------

- (IBAction)onSignOutButtonClick:(UIButton *)sender {
    [[LinkedInClient instance] setAccessToken:nil];
}

//------------------------------------------------------------------------------
#pragma mark - UITableViewDelegate
//------------------------------------------------------------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200; // TODO
}

//------------------------------------------------------------------------------
#pragma mark - UITableViewDataSource
//------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cellForRowAtIndexPath: %zd %zd", indexPath.section, indexPath.row);
    
    NSInteger sectionIndex = indexPath.section;
    NSInteger rowIndex = indexPath.row;
    
    switch (sectionIndex) {
        case HEADER: {
            SeekerProfileHeaderCell *cell = [tableView dequeueReusableHeaderCell];
            [cell initWithProfile:self.currentUserProfile];
            return cell;
        }
        case SUMMARY: {
            UITableViewCell *cell = [tableView dequeueReusableSummaryCell];
            cell.textLabel.text = @"<Summary>"; // TODO self.currentUserProfile.summary;
            return cell;
        }
        case POSITIONS: {
            SeekerProfileExperienceCell *cell = [tableView dequeueReusableExperienceCell];
            CurrentPosition *position = self.currentUserProfile.currentPositions[rowIndex];
            [cell initWithPosition:position];
            return cell;
        }
        case EDUCATIONS: {
            SeekerProfileEducationCell *cell = [tableView dequeueReusableEducationCell];
            Education *education = self.currentUserProfile.educations[rowIndex];
            [cell initWithEducation:education];
            return cell;
        }
        default: {
            return nil;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.currentUserProfile) ? 4 : 0;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case HEADER:
            return 1;
            
        case SUMMARY:
            return 0;
            
        case POSITIONS:
            return self.currentUserProfile.currentPositions.count;
            
        case EDUCATIONS:
            return self.currentUserProfile.educations.count;
        
        default:
            return 0;
    }
}

//------------------------------------------------------------------------------
#pragma mark - Getters/Setters
//------------------------------------------------------------------------------

- (void)setCurrentUserProfile:(Profile *)currentUserProfile {
    _currentUserProfile = currentUserProfile;
    [self.tableView reloadData];
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
        CurrentPosition *position = [currentUser.currentPositions objectAtIndex:0];
        NSLog(@"companyName: %@", position.company.name);
        
        self.currentUserProfile = currentUser;
    };
    
    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^void(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to download current user: %@", error.localizedDescription);
    };
    
    [[LinkedInClient instance] currentUserWithSuccess:success failure:failure];
}

@end

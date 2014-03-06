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
#import "Education.h"
#import "SeekerProfileHeaderCell.h"
#import "SeekerProfileExperienceCell.h"
#import "SeekerProfileEducationCell.h"
#import "UIImageView+AFNetworking.h"
#import "UITableView+Seeker.h"
#import "Parse/Parse.h"

@interface SeekerViewController ()

- (IBAction)onSignOutButtonClick:(UIButton *)sender;

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

- (id)initWithProfile:(Profile *)profile {
    self = [super initWithNibName:@"SeekerViewController" bundle:nil];
    if (self) {
        _currentUserProfile = profile;
        [self initTabBarItem];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerSeekerCells];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    NSInteger sectionIndex = indexPath.section;
    NSInteger rowIndex = indexPath.row;

    CGFloat cellWidth = tableView.frame.size.width;
    
    switch (sectionIndex) {
        case HEADER: {
            return [SeekerProfileHeaderCell heightForProfile:self.currentUserProfile];
        }
        case POSITIONS: {
            CurrentPosition *position = self.currentUserProfile.currentPositions[rowIndex];
            return [SeekerProfileExperienceCell heightForPosition:position withWidth:cellWidth];
        }
        case EDUCATIONS: {
            Education *education = self.currentUserProfile.educations[rowIndex];
            return [SeekerProfileEducationCell heightForEducation:education withWidth:cellWidth];
        }
        default: {
            return 200;
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

//------------------------------------------------------------------------------
#pragma mark - UITableViewDataSource
//------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
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
            cell.textLabel.text = self.currentUserProfile.summary;
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
            return (self.currentUserProfile.summary == nil) ? 0 : 1;
            
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

- (void)initTabBarItem {
    
    NSString *title = @"My Profile";
    UIImage *icon = [UIImage imageNamed:@"user_male4-50"];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:icon tag:0];
    
    self.tabBarItem = tabBarItem;
}

@end

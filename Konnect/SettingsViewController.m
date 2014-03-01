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
    UIImage *icon = [UIImage imageNamed:@"settings"];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:icon tag:0];
    
    self.tabBarItem = tabBarItem;
}

- (void)segmentedControlValueDidChange:(UISegmentedControl *)sender {
    self.appDelegate.isRecruiterMode = (sender.selectedSegmentIndex == 1);
}

@end

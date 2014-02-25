//
//  SeekerOrRecruiterViewController.m
//  Konnect
//
//  Created by fxie on 2/24/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "SeekerOrRecruiterViewController.h"
#import "LinkedInClient.h"
#import "AppDelegate.h"
@interface SeekerOrRecruiterViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *seekerOrRecruiterSegmentedControl;
- (IBAction)signOutButton:(id)sender;

@end

@implementation SeekerOrRecruiterViewController

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
    self.seekerOrRecruiterSegmentedControl.selectedSegmentIndex = 0;
    [self.seekerOrRecruiterSegmentedControl addTarget:self
                                               action:@selector(selectSeekerOrRecruiter:)
                                     forControlEvents:UIControlEventValueChanged];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signOutButton:(id)sender {
    [LinkedInClient instance].accessToken = nil;
    
}

#pragma mark - Private Methods
- (void) selectSeekerOrRecruiter:(UISegmentedControl *)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.seekerOrRecruiter = sender.selectedSegmentIndex;
        
    
}
@end

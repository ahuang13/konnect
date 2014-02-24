//
//  SeekerOrRecruiterViewController.m
//  Konnect
//
//  Created by fxie on 2/22/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "SeekerOrRecruiterViewController.h"
#import "Notifications.h"


@interface SeekerOrRecruiterViewController ()
- (IBAction)onCandidateButton:(id)sender;
- (IBAction)onHiringManagerButton:(id)sender;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCandidateButton:(id)sender {
}

- (IBAction)onHiringManagerButton:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RECRUITER_DID_LOGIN_NOTIFICATION object:nil];
}
@end

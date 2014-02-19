//
//  LogInViewController.m
//  Konnect
//
//  Created by Angus Huang on 2/2/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "LIALinkedInHttpClient+Helpers.h"
#import "NSString+LIAEncode.h"
#import "Profile.h"
#import "LinkedInClient.h"

@interface LogInViewController ()

- (IBAction)onLoginButtonClicked:(UIButton *)sender;

@end

@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - IBAction Methods
//------------------------------------------------------------------------------

- (IBAction)onLoginButtonClicked:(UIButton *)sender
{
    [[LIALinkedInHttpClient instance] login];
}

@end

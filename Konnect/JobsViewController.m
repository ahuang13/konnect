//
//  JobsViewController.m
//  Konnect
//
//  Created by Angus Huang on 3/1/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "JobsViewController.h"

@interface JobsViewController ()

@end

@implementation JobsViewController

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

- (void)initTabBarItem {
    
    NSString *title = @"Jobs";
    UIImage *icon = [UIImage imageNamed:@"briefcase-50"];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:icon tag:0];
    
    self.tabBarItem = tabBarItem;
}

@end

//
//  JobsContainerViewController.m
//  Konnect
//
//  Created by Angus Huang on 3/5/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "JobsContainerViewController.h"
#import "RecruiterViewController.h"

@interface JobsContainerViewController ()

@end

@implementation JobsContainerViewController

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

- (void)initTabBarItem {
    
    NSString *title = @"Jobs";
    UIImage *icon = [UIImage imageNamed:@"briefcase-50"];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:icon tag:0];
    
    self.tabBarItem = tabBarItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------
#pragma mark - TinderViewControllerDataSource
//------------------------------------------------------------------------------

- (UIViewController *)nextViewController {
    return nil;//[[RecruiterViewController alloc] initWithCompany:];
}

//------------------------------------------------------------------------------
#pragma mark - TinderViewControllerDelegate
//------------------------------------------------------------------------------

- (void)didLikeViewController:(UIViewController *)viewController {
    NSLog(@"didLikeViewController");
}

- (void)didDislikeViewController:(UIViewController *)viewController {
    NSLog(@"didDislikeViewController");
}

@end

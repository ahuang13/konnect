//
//  CandidatesContainerViewController.m
//  Konnect
//
//  Created by Angus Huang on 3/5/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "CandidatesContainerViewController.h"
#import "SeekerViewController.h"
#import "Profile.h"

@interface CandidatesContainerViewController ()

@end

@implementation CandidatesContainerViewController

//------------------------------------------------------------------------------
#pragma mark - Initializers
//------------------------------------------------------------------------------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self initTabBarItem];
    }
    return self;
}

- (void)initTabBarItem {
    
    NSString *title = @"Candidates";
    UIImage *icon = [UIImage imageNamed:@"group-50"];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:icon tag:0];
    
    self.tabBarItem = tabBarItem;
}

//------------------------------------------------------------------------------
#pragma mark - Lifecycle
//------------------------------------------------------------------------------

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
    return [[SeekerViewController alloc] initWithProfile:[Profile currentUser]];
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

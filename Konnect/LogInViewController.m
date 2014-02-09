//
//  LogInViewController.m
//  Konnect
//
//  Created by Angus Huang on 2/2/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"viewDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButtonClicked:(UIButton *)sender
{
    NSLog(@"onLoginButtonClicked");
    [self.view endEditing:YES];
    
    // Parse does not support unique constraints on column
    // We have to query the table to make sure an entry doesn't
    // already exist before writing it.
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"email" equalTo:self.emailTextField.text];
    NSArray *array = [query findObjects];
    if(array.count == 0)
    {
        PFObject *testObject = [PFObject objectWithClassName:@"Users"];
        testObject[@"email"] = self.emailTextField.text;
        [testObject saveInBackground];
    }
    
    UIViewController *viewController = [[UIViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end

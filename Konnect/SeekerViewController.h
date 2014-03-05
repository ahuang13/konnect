//
//  SeekerViewController.h
//  Konnect
//
//  Created by Angus Huang on 2/16/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Profile;

@interface SeekerViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) Profile *currentUserProfile;

- (id)initWithProfile:(Profile *)profile;

@end

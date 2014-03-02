//
//  SeekerProfileHeaderCell.h
//  Konnect
//
//  Created by Angus Huang on 2/23/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Profile;

@interface SeekerProfileHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

- (void)initWithProfile:(Profile *)profile;

@end

//
//  SeekerProfileHeaderCell.m
//  Konnect
//
//  Created by Angus Huang on 2/23/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "SeekerProfileHeaderCell.h"
#import "Profile.h"

@implementation SeekerProfileHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithProfile:(Profile *)profile {
    
    self.nameLabel.text = profile.fullName;
    self.locationLabel.text = profile.location;
    
    // TODO: Set profile image URL
}

@end

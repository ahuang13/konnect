//
//  SeekerProfileExperienceCell.m
//  Konnect
//
//  Created by Angus Huang on 2/23/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "SeekerProfileExperienceCell.h"
#import "CurrentPosition.h"

@implementation SeekerProfileExperienceCell

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

- (void)initWithPosition:(CurrentPosition *)position {
    
    self.positionLabel.text = position.title;
    self.companyLabel.text = position.company.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //self.datesLabel.text = [dateFormatter stringFromDate:position.startDate];
    
    self.summaryLabel.text = position.summary;
}

@end

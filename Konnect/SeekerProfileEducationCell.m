//
//  SeekerProfileEducationCell.m
//  Konnect
//
//  Created by Angus Huang on 2/24/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "SeekerProfileEducationCell.h"
#import "Education.h"

@implementation SeekerProfileEducationCell

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

- (void)initWithEducation:(Education *)education {
    self.schoolLabel.text = education.school;
    self.degreeLabel.text = education.degree;
    self.yearsLabel.text = education.endYear;
}

@end

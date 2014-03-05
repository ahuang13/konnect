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


+ (CGFloat)heightForEducation:(Education *)education withWidth:(CGFloat)width {
    
    UIFont *systemFont10 = [UIFont systemFontOfSize:10];
    UIFont *boldSystemFont11 = [UIFont boldSystemFontOfSize:11];
    
    CGFloat height = 10; // top margin
    height += [education.degree sizeWithAttributes:@{NSFontAttributeName:boldSystemFont11}].height;
    height += 5;
    height += [education.school sizeWithAttributes:@{NSFontAttributeName:boldSystemFont11}].height;
    height += 5;
    height += [education.endYear sizeWithAttributes:@{NSFontAttributeName:systemFont10}].height;
    height += 20;

    return height;
}

@end

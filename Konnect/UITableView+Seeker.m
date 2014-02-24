//
//  UITableView+Seeker.m
//  Konnect
//
//  Created by Angus Huang on 2/23/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "UITableView+Seeker.h"

@implementation UITableView (Seeker)

//------------------------------------------------------------------------------
#pragma mark - Constants
//------------------------------------------------------------------------------

// Constants for the cell reuse identifiers.
static NSString *HeaderCellIdentifier = @"HeaderCell";
static NSString *SummaryCellIdentifier = @"SummaryCell";
static NSString *ExperienceCellIdentifier = @"ExperienceCell";
static NSString *EducationCellIdentifier = @"EducationCell";

//------------------------------------------------------------------------------
#pragma mark - Public Methods
//------------------------------------------------------------------------------

- (void)registerSeekerCells {
    
    UINib *headerCellNib = [UINib nibWithNibName:@"SeekerProfileHeaderCell" bundle:nil];
    [self registerNib:headerCellNib forCellReuseIdentifier:HeaderCellIdentifier];
    
    UINib *experienceCellNib = [UINib nibWithNibName:@"SeekerProfileExperienceCell" bundle:nil];
    [self registerNib:experienceCellNib forCellReuseIdentifier:ExperienceCellIdentifier];

    UINib *educationCellNib = [UINib nibWithNibName:@"SeekerProfileEducationCell" bundle:nil];
    [self registerNib:educationCellNib forCellReuseIdentifier:EducationCellIdentifier];
}

- (SeekerProfileHeaderCell *)dequeueReusableHeaderCell {
    return [self dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
}

- (UITableViewCell *)dequeueReusableSummaryCell {
    
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:SummaryCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:SummaryCellIdentifier];
    }

    return cell;
}

- (SeekerProfileExperienceCell *)dequeueReusableExperienceCell {
    return [self dequeueReusableCellWithIdentifier:ExperienceCellIdentifier];
}

- (SeekerProfileEducationCell *)dequeueReusableEducationCell {
    return [self dequeueReusableCellWithIdentifier:EducationCellIdentifier];
}

@end

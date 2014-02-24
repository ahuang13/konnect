//
//  UITableView+Seeker.h
//  Konnect
//
//  Created by Angus Huang on 2/23/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SeekerProfileHeaderCell;
@class SeekerProfileExperienceCell;
@class SeekerProfileEducationCell;

@interface UITableView (Seeker)

- (void)registerSeekerCells;
- (SeekerProfileHeaderCell *)dequeueReusableHeaderCell;
- (UITableViewCell *)dequeueReusableSummaryCell;
- (SeekerProfileExperienceCell *)dequeueReusableExperienceCell;
- (SeekerProfileEducationCell *)dequeueReusableEducationCell;

@end

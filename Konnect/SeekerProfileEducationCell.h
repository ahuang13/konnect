//
//  SeekerProfileEducationCell.h
//  Konnect
//
//  Created by Angus Huang on 2/24/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Education;

@interface SeekerProfileEducationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearsLabel;

- (void)initWithEducation:(Education *)education;

@end

//
//  SeekerProfileExperienceCell.h
//  Konnect
//
//  Created by Angus Huang on 2/23/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CurrentPosition;

@interface SeekerProfileExperienceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *datesLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

- (void)initWithPosition:(CurrentPosition *)position;

+ (CGFloat)heightForPosition:(CurrentPosition *)position withWidth:(CGFloat)width;

@end

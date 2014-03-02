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
    self.datesLabel.text = position.dates;
    
    self.summaryLabel.text = position.summary;
}

+ (CGFloat)heightForPosition:(CurrentPosition *)position withWidth:(CGFloat)width {

    UIFont *systemFont10 = [UIFont systemFontOfSize:10];
    UIFont *systemFont11 = [UIFont systemFontOfSize:11];
    UIFont *boldSystemFont11 = [UIFont boldSystemFontOfSize:11];
    
    CGFloat height = 10; // top margin
    height += [position.title sizeWithAttributes:@{NSFontAttributeName:boldSystemFont11}].height;
    height += 2;
    height += [position.company.name sizeWithAttributes:@{NSFontAttributeName:boldSystemFont11}].height;
    height += 2;
    height += [position.dates sizeWithAttributes:@{NSFontAttributeName:systemFont10}].height;
    height += 2;
    
    CGSize constraints = CGSizeMake(width - 10 - 10, CGFLOAT_MAX);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
    CGRect boundingRect = [position.summary boundingRectWithSize:constraints
                                                         options:options
                                                      attributes:@{NSFontAttributeName:systemFont11}
                                                         context:nil];
    height += boundingRect.size.height;
    height +=10;
    
    return height;
}

@end

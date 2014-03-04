//
//  JobProfile.h
//  Konnect
//
//  Created by fxie on 3/3/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"


@interface JobProfile : NSObject

@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companySize;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *logoUrl;
@property (nonatomic, strong) NSString *salary;



- (id)initWithPFObject: (PFObject *)pfObject;

@end

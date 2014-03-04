//
//  JobProfile.m
//  Konnect
//
//  Created by fxie on 3/3/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "JobProfile.h"
#import "Parse/Parse.h"

@implementation JobProfile

- (id)initWithPFObject: (PFObject *)pfObject {
    self = [super init];
    if (self) {
        _companyName = [pfObject objectForKey:@"companyName"];
        _companySize = [pfObject objectForKey:@"companySize"];
        _description = [pfObject objectForKey:@"description"];
        _location = [pfObject objectForKey:@"location"];
        _title = [pfObject objectForKey:@"title"];
        _salary = [pfObject objectForKey:@"salary"];
        _logoUrl = [pfObject objectForKey:@"logoUrl"];

    }
    
    return self;
}

@end

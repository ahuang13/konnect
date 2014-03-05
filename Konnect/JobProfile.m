//
//  JobProfile.m
//  Konnect
//
//  Created by fxie on 3/3/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "JobProfile.h"
#import "Parse/Parse.h"
#import "LinkedInClient.h"

@implementation JobProfile

//------------------------------------------------------------------------------
#pragma mark - Constants
//------------------------------------------------------------------------------

NSString * const CURRENT_JOB_KEY = @"CurrentJobKey";

//------------------------------------------------------------------------------
#pragma mark - Static Variables
//------------------------------------------------------------------------------

static JobProfile *_currentJobProfile;

//------------------------------------------------------------------------------
#pragma mark - Initializer
//------------------------------------------------------------------------------

- (id)initWithDictionary: (NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        _data = dictionary;
        _companyName = dictionary[@"companyName"];
        _companySize = dictionary[@"companySize"];
        _description = dictionary[@"description"];
        _location = dictionary[@"location"];
        _title = dictionary[@"title"];
        _logoUrl = dictionary[@"logoUrl"];
        _salary = dictionary[@"salary"];

    }
    
    return self;
}

- (id)initWithPFObject: (PFObject *)pfObject {
    self = [super init];
    if (self) {
        _data = [self dictionaryWithPFObject:pfObject];
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

+ (JobProfile *)currentJobProfile {
    if (!_currentJobProfile) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:CURRENT_JOB_KEY];
        if (userData) {
            NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:userData options:NSJSONReadingMutableContainers error:nil];
            _currentJobProfile = [[JobProfile alloc] initWithDictionary:userDictionary];
        }
    }
    
    return _currentJobProfile;
}

+ (void)setCurrentJobProfile:(JobProfile *)jobProfile {
    _currentJobProfile = jobProfile;
    if (jobProfile) {
        NSData *userData = [NSJSONSerialization dataWithJSONObject:jobProfile.data options:NSJSONWritingPrettyPrinted error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:CURRENT_JOB_KEY];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENT_JOB_KEY];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary*)dictionaryWithPFObject:(PFObject*)pfObject {
    
    NSArray * allKeys = [pfObject allKeys]; NSMutableDictionary * retDict = [[NSMutableDictionary alloc] init];
    
    for (NSString * key in allKeys) {
        
        [retDict setObject:[pfObject objectForKey:key] forKey:key];
    }
    return retDict;
}

@end

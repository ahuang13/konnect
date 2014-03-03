//
//  Profile.m
//  Konnect
//
//  Created by fxie on 2/14/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "Profile.h"
#import "NSDictionary+CPAdditions.h"
#import "LinkedInClient.h"
#import "Notifications.h"
#import "Education.h"
#import "Company.h"
#import "CurrentPosition.h"


@implementation Profile

//------------------------------------------------------------------------------
#pragma mark - Constants
//------------------------------------------------------------------------------

NSString * const CURRENT_USER_KEY = @"CurrentUserKey";

//------------------------------------------------------------------------------
#pragma mark - Static Variables
//------------------------------------------------------------------------------

static Profile *_currentUser;

//------------------------------------------------------------------------------
#pragma mark - Initializer
//------------------------------------------------------------------------------

- (id)initWithDictionary: (NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        self.data = dictionary;
        self.firstName = dictionary[@"firstName"];
        self.lastName = dictionary[@"lastName"];
        self.pictureUrl = dictionary[@"pictureUrl"];
        self.location = dictionary[@"location"][@"name"];
        self.linkedInId = dictionary[@"id"];
        
        self.currentPositions = [Profile parseCurrentPositions:dictionary];
        self.educations = [Profile parseEducations:dictionary];
    }
    
    return self;
}

+ (Profile *)currentUser {
    if (!_currentUser) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:CURRENT_USER_KEY];
        if (userData) {
            NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:userData options:NSJSONReadingMutableContainers error:nil];
            _currentUser = [[Profile alloc] initWithDictionary:userDictionary];
        }
    }
    
    return _currentUser;
}

+ (void)setCurrentUser:(Profile *)currentUser {
    _currentUser = currentUser;
    if (currentUser) {
        NSData *userData = [NSJSONSerialization dataWithJSONObject:currentUser.data options:NSJSONWritingPrettyPrinted error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:CURRENT_USER_KEY];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENT_USER_KEY];
        [LinkedInClient instance].accessToken = nil;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//------------------------------------------------------------------------------
#pragma mark - Getters/Setters
//------------------------------------------------------------------------------

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

//------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------

+ (NSArray *)parseCurrentPositions:(NSDictionary *)dictionary {
    
    NSMutableArray *currentPositions = [[NSMutableArray alloc] init];
    
    NSArray *currentPositionsJSONArray = dictionary[@"threeCurrentPositions"][@"values"];
    
    for (id positionDict in currentPositionsJSONArray) {
        CurrentPosition *position = [[CurrentPosition alloc] initWithDictionary:positionDict];
        [currentPositions addObject:position];
    }
    
    return currentPositions;
}

+ (NSArray *)parseEducations:(NSDictionary *)dictionary {
    
    NSMutableArray *educations = [[NSMutableArray alloc] init];
    
    NSArray *educationsJSONArray = dictionary[@"educations"][@"values"];
    
    for (id educationDict in educationsJSONArray) {
        Education *education = [[Education alloc] initWithDictionary:educationDict];
        [educations addObject:education];
    }
    
    return educations;
}

@end
